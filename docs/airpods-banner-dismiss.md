# AirPods smart-routing banner investigation

## Status

No verified selective suppression is installed.

The WindowServer alpha experiment was a false positive. A `MenuBarAgent`
window appeared at the same timestamps as Connected and ReverseRoute events,
and `CGSSetWindowAlpha` returned success, but user screenshots proved that the
AirPods banner remained fully visible. `CGSGetWindowAlpha` subsequently
confirmed that the correlated window was already at alpha 0 while the banner
was visible. It was an invisible coordination window, not the rendered banner
surface.

The ineffective LaunchAgent was unloaded and its implementation files were
removed immediately after that user-visible test.

## Earlier attempts

The original `airpods-banner-dismiss` LaunchAgent was removed after real idle
testing proved that its unified-log reaction was too late. The matching log
record becomes visible about 130 to 150 ms after `usernoted` receives the
request, by which time Control Center has already created the system banner.

Private SkyLight APIs found a `MenuBarAgent` coordination window correlated
with each event, but changing that window does not affect the visible banner.

The Sound-status-item experiment was tested against natural idle
Connected/ReverseRoute cycles and disproved. It used:

```bash
defaults write com.apple.controlcenter 'NSStatusItem Visible Sound' -bool false
killall ControlCenter
```

The AirPods entered the two-device Tipi state and produced ReverseRoute at
05:13:26 and 05:13:36. Despite the hidden status item, Control Center logged
`Did present banner of type SmartRoutingSystemBannerContent: true` both times.
The Sound status item was restored immediately afterward.

Restore the Sound status item with:

```bash
defaults write com.apple.controlcenter 'NSStatusItem Visible Sound' -bool true
killall ControlCenter
```

## Observed cause

On macOS 27.0 build 26A5406e, idle AirPods repeatedly oscillated between the
smart-routing actions `Route` and `DontRoute`. That generated alternating
Connected and ReverseRoute requests even though neither the Mac nor iPhone was
playing audio.

The delivery path is:

```text
audioaccessoryd
  -> com.apple.BTUserNotifications
  -> usernoted
  -> Essential-urgency resolution
  -> Control Center Sound system banner
```

Control Center logged successful Connected presentations as:

```text
show smart routing connected ...
Directly showing banner for Sound: ... menuBarDisplayableVisible=true
```

ReverseRoute updates used the same smart-routing banner service. Static binary
inspection also found Control Center's alternate branch:

```text
banner requested for ..., but no module menu bar displayable is visible yet,
queuing it.
```

Natural idle testing disproved using that branch through Sound-status-item
visibility.

## Disproved approaches

- Notification Center authorization and banner flags do not block these
  records. The hidden bundle supplies system defaults and the events resolve at
  private `Essential` urgency.
- A Focus rule that explicitly silences `com.apple.BTUserNotifications` still
  resolves as allowed because of mode-configuration urgency.
- Calling Control Center's private `removeSmartRoutingForEvent:` method from an
  ad-hoc helper is ignored because the helper is not an Apple platform client.
- Hosting the same private call inside Apple-signed `/usr/bin/osascript` is
  also rejected by the `com.apple.SystemBannerService` XPC listener. The
  service requires a specific client entitlement, not only an Apple signature.
- Restarting Control Center does not help because the pending request survives
  and is delivered after relaunch.
- Reacting to `usernoted` unified logs and immediately killing `usernoted` is
  too late. Both TERM and KILL were tested against natural idle cycles.
- A SQLite `BEFORE INSERT ... RAISE(IGNORE)` trigger scoped to
  `com.apple.BTUserNotifications` stops persistence but not presentation.
  `usernoted` delivers its in-memory record independently of that insert.
- The hidden Bluetooth preference `srConnectionAlert=false` controls a
  different branch. Connected and ReverseRoute banners continued after
  `audioaccessoryd` reloaded it. The experimental key was deleted afterward.
- Smart-routing banners expose no accessibility descendants and no public Core
  Graphics windows while Control Center logs successful presentation. A live
  probe observed multiple Connected and ReverseRoute presentations without a
  corresponding accessibility or public-window object, so ordinary UI-click
  automation cannot target them.
- A private WindowServer probe found a correlated `MenuBarAgent` window, but
  setting its alpha to zero did not hide the banner. Successful SkyLight return
  codes and timestamp correlation are not sufficient evidence of suppression.

## Research references

- Apple documents that compatible AirPods can automatically switch between
  Apple devices, but exposes no separate switch for these routing banners:
  <https://support.apple.com/en-au/104988>
- Apple's notification documentation describes Critical alerts as able to
  bypass Do Not Disturb. The AirPods records use the related private
  `Essential` urgency in local logs:
  <https://developer.apple.com/documentation/usernotifications/unnotificationinterruptionlevel/critical>
- Apple's notification guidance explains that elevated interruption levels can
  break through Focus:
  <https://developer.apple.com/design/human-interface-guidelines/managing-notifications>
