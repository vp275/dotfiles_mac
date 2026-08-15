# Ducky One 2 - macOS Setup

## Problem

Ducky One 2 doesn't have a Mac/Windows switch like Keychron. By default:
- Alt key → Option (⌥)
- Windows key → Command (⌘)

This is reversed from Mac layout where Command should be next to the spacebar.

## Solution

Added device-specific modifier swap in Karabiner-Elements (`mac/.config/karabiner/karabiner.json`):

- Left/Right Option ↔ Left/Right Command (for Ducky only, vendor 1241, product 661)

Other keyboards (including MacBook built-in) are unaffected.

## Other Settings

- Caps Lock → Escape (global, applies to all keyboards)

## Function Row

The Ducky hardware Fn key is handled by the keyboard firmware. macOS does not
see it as the MacBook Fn/Globe key, and `Fn+F1-F12` is not the right path for
Mac media keys on this board.

`~/.local/bin/ducky-one-2-media-keys` maps the media keys below with `hidutil`,
targeted to the Ducky vendor/product ID only. A LaunchAgent at
`~/Library/LaunchAgents/com.vp.ducky-one2-media-keys.plist` reapplies the
mapping on login and every 30 seconds so it survives keyboard replugging.

- Triple F4 → BetterTouchTool's global key sequence locks the screen using its
  native Lock Screen action. Single and double F4 presses have no custom
  action. F4 passes through the F8 listener unchanged so BTT can recognize it.
- MacBook built-in F4 → `~/.local/bin/macbook-f4-proton-key` remaps Apple's
  Spotlight/Search HID usage to normal F4, targeted only to the built-in Apple
  keyboard so it does not overwrite the Ducky media mapping. The helper keeps
  its legacy filename, but F4 no longer controls Proton VPN.
- F8 → the same listener calls `~/.local/bin/aerospace-toggle-enabled` to
  kill/relaunch the AeroSpace process. Starting prefers
  `~/Applications/AeroSpace Sticky.app`; `/Applications/AeroSpace.app` remains
  the manual rollback.
  A LaunchAgent at
  `~/Library/LaunchAgents/com.vp.ducky-f8-aerospace-listener.plist` keeps the
  listener running.
- F10 → Mute
- F11 → Volume Down
- F12 → Volume Up

## Herdr Prefix Across Keyboards

Herdr uses `Ctrl+B` as its canonical prefix in
`~/.config/herdr/config.toml`.

- Ducky One 2: press physical `Ctrl+B`. The Ducky Fn key cannot be used
  because its firmware does not expose that key to macOS.
- MacBook keyboard: BetterTouchTool key sequence
  `Ghostty Fn to Ctrl+B - Herdr prefix` translates a press and release of the
  Fn/Globe key into `Ctrl+B`.

The BTT trigger action checks that the frontmost application bundle identifier
is `com.mitchellh.ghostty` before sending `Ctrl+B`. The modifier-only key
sequence is listed in BTT's Global section, but its action emits no key outside
Ghostty. Its current trigger UUID is
`3D18BB81-90D9-4CD9-BED3-9B46FBB2F683`.

macOS **Press Globe key to** is set to **Do Nothing**
(`com.apple.HIToolbox AppleFnUsageType = 0`) so the native Globe action does not
compete with BTT. This means the MacBook Fn/Globe key does nothing outside
Ghostty when pressed by itself.

The Ducky-specific function-row mappings remain unchanged. In particular,
Ducky F12 is still Volume Up rather than a Herdr prefix.
