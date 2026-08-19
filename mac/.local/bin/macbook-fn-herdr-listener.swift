import AppKit
import CoreGraphics
import Foundation
import IOKit.hid

private let controlBKeyCode: CGKeyCode = 11
private let maximumTapDuration: TimeInterval = 0.35
private let allowedTerminalBundleIdentifiers: Set<String> = [
    "com.mitchellh.ghostty",
    "org.alacritty",
]
private let selfEventMarker: Int64 = 0x4D46484C
private let appleVendorID = 0x05AC
private let builtInKeyboardProductID = 0x0342
private let appleVendorTopCaseUsagePage: UInt32 = 0x00FF
private let appleVendorTopCaseFnUsage: UInt32 = 0x0003
private let systemDefinedEventType: UInt32 = 14

private let logURL = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Logs/macbook-fn-herdr-listener.log")

private var eventTap: CFMachPort?

private final class FnPress {
    let startedAt: TimeInterval
    let startedInAllowedTerminal: Bool
    var cancelled = false

    init(startedAt: TimeInterval, startedInAllowedTerminal: Bool) {
        self.startedAt = startedAt
        self.startedInAllowedTerminal = startedInAllowedTerminal
    }
}

private var fnPress: FnPress?

private func log(_ message: String) {
    let line = "\(ISO8601DateFormatter().string(from: Date())) \(message)\n"
    guard let data = line.data(using: .utf8) else { return }

    let logDirectory = logURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(
        at: logDirectory,
        withIntermediateDirectories: true
    )

    if FileManager.default.fileExists(atPath: logURL.path),
       let handle = try? FileHandle(forWritingTo: logURL) {
        defer { try? handle.close() }
        _ = try? handle.seekToEnd()
        try? handle.write(contentsOf: data)
    } else {
        try? data.write(to: logURL)
    }
}

private func isAllowedTerminalFrontmost() -> Bool {
    guard let bundleIdentifier = NSWorkspace.shared.frontmostApplication?.bundleIdentifier else {
        return false
    }
    return allowedTerminalBundleIdentifiers.contains(bundleIdentifier)
}

private func hasOtherModifier(_ flags: CGEventFlags) -> Bool {
    let otherModifiers: CGEventFlags = [
        .maskAlphaShift,
        .maskShift,
        .maskControl,
        .maskAlternate,
        .maskCommand,
        .maskHelp,
        .maskNumericPad,
    ]

    return !flags.intersection(otherModifiers).isEmpty
}

private func cancelActiveFnPress(reason: String) {
    guard let fnPress, !fnPress.cancelled else { return }
    fnPress.cancelled = true
    log("Fn tap cancelled reason=\(reason)")
}

private func beginFnPress() {
    guard fnPress == nil else {
        log("ignored duplicate Fn HID down")
        return
    }

    let press = FnPress(
        startedAt: ProcessInfo.processInfo.systemUptime,
        startedInAllowedTerminal: isAllowedTerminalFrontmost()
    )
    press.cancelled = hasOtherModifier(
        CGEventSource.flagsState(.combinedSessionState)
    )
    fnPress = press
    log(
        "Fn HID down allowedTerminal=\(press.startedInAllowedTerminal) " +
        "cancelled=\(press.cancelled)"
    )
}

private func endFnPress() {
    guard let press = fnPress else {
        log("ignored Fn HID up without an active Fn press")
        return
    }
    fnPress = nil

    let duration = ProcessInfo.processInfo.systemUptime - press.startedAt
    let endsInAllowedTerminal = isAllowedTerminalFrontmost()
    let formattedDuration = String(format: "%.3f", duration)

    guard duration <= maximumTapDuration,
          press.startedInAllowedTerminal,
          endsInAllowedTerminal,
          !press.cancelled else {
        log(
            "Fn HID release ignored duration=\(formattedDuration) " +
            "startedInAllowedTerminal=\(press.startedInAllowedTerminal) " +
            "endsInAllowedTerminal=\(endsInAllowedTerminal) " +
            "cancelled=\(press.cancelled)"
        )
        return
    }

    postHerdrPrefix()
}

private func postHerdrPrefix() {
    guard CGPreflightPostEventAccess() else {
        log("Fn tap skipped: Accessibility permission for posting events is not granted")
        return
    }

    guard let eventSource = CGEventSource(stateID: .hidSystemState),
          let keyDown = CGEvent(
              keyboardEventSource: eventSource,
              virtualKey: controlBKeyCode,
              keyDown: true
          ),
          let keyUp = CGEvent(
              keyboardEventSource: eventSource,
              virtualKey: controlBKeyCode,
              keyDown: false
          ) else {
        log("Fn tap skipped: could not create Ctrl+B events")
        return
    }

    for event in [keyDown, keyUp] {
        event.flags = .maskControl
        event.setIntegerValueField(.eventSourceUserData, value: selfEventMarker)
        event.post(tap: .cghidEventTap)
    }

    log("Fn tap triggered Ctrl+B")
}

private let callback: CGEventTapCallBack = { _, type, event, _ in
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        log("event tap disabled type=\(type.rawValue), re-enabling")
        fnPress = nil
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    if event.getIntegerValueField(.eventSourceUserData) == selfEventMarker {
        return Unmanaged.passUnretained(event)
    }

    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

    switch type {
    case .flagsChanged:
        // Raw IOHID input provides the authoritative Fn down/up transitions.
        // The passive event tap observes only other modifier activity so Fn
        // used with another key cannot become a bare-tap prefix.
        if keyCode != 63 {
            cancelActiveFnPress(reason: "modifier keyCode=\(keyCode)")
        }

    case .keyDown, .keyUp:
        if keyCode != 63 {
            cancelActiveFnPress(reason: "key event type=\(type.rawValue) keyCode=\(keyCode)")
        }

    default:
        if type.rawValue == systemDefinedEventType {
            cancelActiveFnPress(reason: "systemDefined event")
        }
        break
    }

    return Unmanaged.passUnretained(event)
}

private func makePassiveEventTap() -> CFMachPort? {
    let eventMask = (CGEventMask(1) << CGEventType.keyDown.rawValue) |
        (CGEventMask(1) << CGEventType.keyUp.rawValue) |
        (CGEventMask(1) << CGEventType.flagsChanged.rawValue) |
        (CGEventMask(1) << systemDefinedEventType)

    return CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .listenOnly,
        eventsOfInterest: eventMask,
        callback: callback,
        userInfo: nil
    )
}

private let hidValueCallback: IOHIDValueCallback = { _, result, _, value in
    guard result == kIOReturnSuccess else {
        log("Fn HID callback error result=\(result)")
        fnPress = nil
        return
    }

    let element = IOHIDValueGetElement(value)
    guard IOHIDElementGetUsagePage(element) == appleVendorTopCaseUsagePage,
          IOHIDElementGetUsage(element) == appleVendorTopCaseFnUsage else {
        return
    }

    if IOHIDValueGetIntegerValue(value) != 0 {
        beginFnPress()
    } else {
        endFnPress()
    }
}

private func makeFnHIDManager() -> IOHIDManager {
    let manager = IOHIDManagerCreate(
        kCFAllocatorDefault,
        IOOptionBits(kIOHIDOptionsTypeNone)
    )

    // ioreg identifies this MacBook's internal top-case keyboard as Apple's
    // built-in VendorID 0x05AC, ProductID 0x0342 device. Its report descriptor
    // exposes Fn as Apple vendor page 0xFF, usage 0x03.
    let deviceMatch: [String: Any] = [
        kIOHIDVendorIDKey as String: appleVendorID,
        kIOHIDProductIDKey as String: builtInKeyboardProductID,
        kIOHIDBuiltInKey as String: true,
    ]
    let valueMatch: [String: Any] = [
        kIOHIDElementUsagePageKey as String: appleVendorTopCaseUsagePage,
        kIOHIDElementUsageKey as String: appleVendorTopCaseFnUsage,
    ]

    IOHIDManagerSetDeviceMatching(manager, deviceMatch as CFDictionary)
    IOHIDManagerSetInputValueMatching(manager, valueMatch as CFDictionary)
    IOHIDManagerRegisterInputValueCallback(manager, hidValueCallback, nil)
    return manager
}

atexit {
    log("exiting")
}

if !CGPreflightPostEventAccess(), !CGRequestPostEventAccess() {
    log("startup warning: Accessibility permission for posting events is not granted")
}

guard let passiveTap = makePassiveEventTap() else {
    log("failed to create passive event tap; grant Input Monitoring permission and restart")
    exit(1)
}

let fnHIDManager = makeFnHIDManager()
IOHIDManagerScheduleWithRunLoop(
    fnHIDManager,
    CFRunLoopGetCurrent(),
    CFRunLoopMode.commonModes.rawValue
)
let hidOpenResult = IOHIDManagerOpen(fnHIDManager, IOOptionBits(kIOHIDOptionsTypeNone))
guard hidOpenResult == kIOReturnSuccess else {
    log("failed to open built-in Fn HID device result=\(hidOpenResult)")
    exit(1)
}

eventTap = passiveTap
let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, passiveTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
CGEvent.tapEnable(tap: passiveTap, enable: true)
log("started built-in Fn HID listener and passive event tap")
CFRunLoopRun()
