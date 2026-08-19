# Custom Shortcut Reference

Last audited against live settings: 2026-08-18

## Purpose

This is the quick reference for custom inputs managed through Logitech
Options+, BetterTouchTool, and Spokenly. It records what a physical input does
now. Use the detailed setup guides for implementation history, database fields,
backup procedures, and troubleshooting:

- [Logitech Options+ and Spokenly setup](logitech-options-spokenly.md)
- [BetterTouchTool gesture setup](btt/README.md)
- [Spokenly transcription profile](transcription/spokenly/README.md)
- [Ducky One 2 macOS setup](ducky-one-2-setup.md)

Live application settings are authoritative when this file and a detailed guide
disagree.

## Logitech MX Master 3S

### Shared gesture button

The gesture/top button (`c196`) uses Logitech's Application Navigation card in
all current profiles.

| Physical input | Result |
| --- | --- |
| Click | Launchpad |
| Hold and move up | Mission Control |
| Hold and move down | App Expose |
| Hold and move left or right | Switch applications |

### Application profiles

The Logitech profile displayed as `ChatGPT` targets Codex bundle ID
`com.openai.codex`.

| Profile | Auxiliary/thumb `c195` | Wheel click `c82` | Back `c83` | Forward `c86` | Thumb wheel left | Thumb wheel right |
| --- | --- | --- | --- | --- | --- | --- |
| Desktop/default | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | Native horizontal scroll | Native horizontal scroll |
| Codex, shown as ChatGPT | Logitech Smart Action `Spokenly Hands-Free` | Return | `Ctrl+Tab` | `Cmd+K`, open search | `Cmd+Delete` | `Shift+Return` |
| Claude | Logitech Smart Action `Spokenly Hands-Free` | Return | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Warp | Logitech Smart Action `Spokenly Hands-Free` | Enter | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Ghostty | Logitech Smart Action `Spokenly Hands-Free` | Enter | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Safari | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Google Chrome | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Brave Browser | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Firefox | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Helium | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Native Back | Native Forward | `Ctrl+Shift+Tab` | `Ctrl+Tab` |
| Sioyek | Logitech Smart Action `Spokenly Hands-Free` | Middle click | Right Arrow | Left Arrow | `-`, zoom out | `=`, zoom in |

## BetterTouchTool

### Global keyboard sequences

| Physical input | Result |
| --- | --- |
| Triple F4, no more than 0.35 seconds between events | Lock the screen using BTT's native Lock Screen action |

### Native MacBook keyboard listener

| Physical input | App scope | Owner | Result |
| --- | --- | --- | --- |
| Standalone Globe/Fn tap, no more than 0.35 seconds | Ghostty or Alacritty | `macbook-fn-herdr-listener` LaunchAgent | Sends `Ctrl+B`, the Herdr prefix |

The listener reads explicit down/up values from the built-in keyboard's raw
IOHID Fn element, then uses a listen-only event tap to detect other keys,
modifiers, and media-key activity. It leaves all physical input unchanged and
sends the prefix only when Ghostty or Alacritty is frontmost at press and
release and no other input participates. The former BTT trigger
`3D18BB81-90D9-4CD9-BED3-9B46FBB2F683` is disabled and preserved solely for
rollback.

The working deployment requires the compiled binary at
`~/Library/Caches/dotfiles/macbook-fn-herdr-listener` to be enabled in both
Input Monitoring and Device Control and Data Access. The quick-tap path was
physically verified in Ghostty on 2026-08-15 and in Alacritty on 2026-08-16.
The live Alacritty test produced exactly one `Ctrl+B`, with the listener log
showing `allowedTerminal=true` and one `Fn tap triggered Ctrl+B` entry.

### Global MacBook trackpad gestures

| Physical input | Result |
| --- | --- |
| 3-finger swipe right | Open BTT's Application Switcher |
| 3-finger swipe left | `Cmd+Delete`, delete to the beginning of the line |
| 3-finger tap | Open `Spokenly Toggle.app`, which calls `spokenly://toggle` for hands-free dictation |
| 4-finger tap | Return |

The 3-finger click trigger is disabled and reserved for future use.

### Global Magic Mouse gestures

| Physical input | Result |
| --- | --- |
| 1-finger tap | Left click at the pointer |
| 1-finger tap right | Right click at the pointer |
| TipTap Left, 1 Finger Fix | Open `Spokenly Toggle.app`, which calls `spokenly://toggle` for hands-free dictation |
| 2-finger swipe right | Open BTT's Application Switcher |
| 3-finger tap | Middle click at the pointer |

### Application-specific BTT shortcuts

Application-specific triggers override matching global gestures.

| Application | Input | Result |
| --- | --- | --- |
| Codex | Trackpad 2-finger swipe right | Open the Codex chat switcher, then select the hovered chat when the final finger lifts |
| Codex | Magic Mouse 3-finger tap | Return instead of the global middle click |
| Codex | `Ctrl+B` | Toggle the sidebar between `By project` and `In one list` through the debounced helper |
| Codex | Normal-mouse horizontal scroll right | Toggle the sidebar between `By project` and `In one list` through the direct helper |
| YouTube Brave app | `Cmd+Shift+C` | Open the application menu and run its native Copy URL command |

### Current Spokenly adapters

| Input | Owner and action | Result |
| --- | --- | --- |
| Trackpad 3-finger tap | BTT trigger `CA4B9E78-76FB-4764-9301-A9937EE84D12` | Open the background helper at `~/Applications/Spokenly Toggle.app`, which calls `spokenly://toggle` |
| MX Master auxiliary/thumb button | Logitech Smart Action `Spokenly Hands-Free`, ID `d18fe790-d754-4fbc-8e82-0e5df78bda9e` | Open the same background helper and toggle Spokenly |
| Magic Mouse TipTap Left, 1 Finger Fix | BTT trigger `497F16E1-1725-4D6E-BD16-B8F88259EF2F` | Open the same background helper and toggle Spokenly |

Standalone Right Option is not a Spokenly adapter. It remains a native modifier
in keyboard chords, and no repository-level standalone Right Option mechanism
is configured.

### Removed Logitech-to-BTT transcription experiments

The former global F20 trigger
`1F6581F7-5158-4562-96BC-4651E63C893D` was removed on 2026-08-01. BTT did not
receive Logitech's generated F20 or Hyper chord. A second test using a modified
middle-click and BTT high-level mouse recognition also failed to reach BTT.
BTT's generic and dedicated modifier actions emitted synthetic events that
Spokenly ignored. The later `Ctrl+Shift+B` BTT adapter also failed because the
Logitech thumb-button event never reached BTT. Those routes and their BTT
triggers are removed. The current adapter is a native Logitech Device-triggered
Smart Action and does not use a generated keyboard shortcut.

`Ctrl+B` remains an active Codex BTT trigger, but the current Logitech Codex
profile does not emit `Ctrl+B`. The live Logitech thumb wheel currently emits
`Cmd+Delete` to the left and `Shift+Return` to the right.

## Spokenly

Spokenly `2.27.16` (`538`) uses MacBook Fn with Push-to-talk activation. The
live preference serializes it as `rawFlags: 8388608`,
`activationMode: "pushToTalk"`, and `modeMac: "autoInsert"`.

| Input | Result | Origin |
| --- | --- | --- |
| MacBook Fn held while speaking | Push-to-talk; release stops recording | Direct Spokenly shortcut |
| MX Master auxiliary/thumb button | Open the same helper and toggle Spokenly | Logitech Smart Action |

The three hands-free inputs converge on the same background helper. MacBook Fn
remains a separate direct push-to-talk control. Standalone Right Option does not
toggle Spokenly.

See the [Spokenly input profile](transcription/spokenly/README.md) for live
settings, device compatibility, automation hooks, and verification.

## Ducky modifier mapping

The Ducky One 2 Command, Option, and Caps mappings are owned by native macOS in
`com.apple.keyboard.modifiermapping.1241-661-0`. The repository contains no
standalone Right Option rule.

## Maintenance

Update this file whenever a Logitech Options+ profile, BetterTouchTool trigger,
or Spokenly shortcut changes. Record current behavior here, and keep
implementation history and troubleshooting detail in the specialized guides.

Audit the live sources before editing this reference:

- Logitech Options+: `~/Library/Application Support/LogiOptionsPlus/settings.db`
- BetterTouchTool: BTT's `get_triggers` AppleScript command
- Spokenly: `~/Library/Preferences/app.spokenly.plist`
