# Custom Shortcut Reference

Last audited against live settings: 2026-08-01

## Purpose

This is the quick reference for custom inputs managed through Logitech
Options+, BetterTouchTool, and Wispr Flow. It records what a physical input does
now. Use the detailed setup guides for implementation history, database fields,
backup procedures, and troubleshooting:

- [Logitech Options+ and Wispr Flow setup](logitech-options-wispr-flow.md)
- [BetterTouchTool gesture setup](btt/README.md)
- [Transcription provider profiles](transcription/README.md)
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

`trx wispr` changes `c195` in every current Logitech profile to Right Option.
`trx spokenly` restores the Smart Action shown in the table. `trx` discovers
the profile list from the live Logitech database on every switch.

## BetterTouchTool

### Global keyboard sequences

| Physical input | Result |
| --- | --- |
| Triple F4, no more than 0.35 seconds between events | Lock the screen using BTT's native Lock Screen action |

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

### `trx` provider adapters

The current verified state is Spokenly. These are the only three device
mappings that `trx` changes:

| Physical input | `trx spokenly` | `trx wispr` |
| --- | --- | --- |
| Trackpad 3-finger tap | BTT launches `Spokenly Toggle.app` | BTT sends Right Option, code `61` |
| MX Master auxiliary/thumb `c195`, every Logitech profile | Logitech runs Smart Action `Spokenly Hands-Free` | Logitech sends Right Option, HID code `230` |
| Magic Mouse TipTap Left, 1 Finger Fix | BTT launches `Spokenly Toggle.app` | BTT sends Right Option, code `61` |

```text
trx spokenly   # select Spokenly mappings and application
trx wispr      # select Wispr mappings and application
trx toggle     # switch to the other provider
trx status     # show saved state, live mappings, and running apps
trx verify     # validate mappings, process state, and Logitech database
```

The command snapshots the previous setup before changing anything. See the
[provider switch documentation](transcription/README.md#trx-provider-switcher)
for backup, rollback, and lock details.

### Current Spokenly adapter details

| Input | Owner and action | Result |
| --- | --- | --- |
| Trackpad 3-finger tap | BTT trigger `CA4B9E78-76FB-4764-9301-A9937EE84D12` | Open the background helper at `~/Applications/Spokenly Toggle.app`, which calls `spokenly://toggle` |
| MX Master auxiliary/thumb button in Desktop/default, Codex, or Ghostty | Logitech Smart Action `Spokenly Hands-Free`, ID `d18fe790-d754-4fbc-8e82-0e5df78bda9e` | Open the same background helper and toggle Spokenly hands-free dictation |
| Magic Mouse TipTap Left, 1 Finger Fix | BTT trigger `497F16E1-1725-4D6E-BD16-B8F88259EF2F` | Open the same background helper and toggle Spokenly hands-free dictation |

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

## Wispr Flow Effective Shortcuts

These are the effective entries in `prefs.user.shortcuts` in Wispr Flow's live
configuration. This object contains built-in defaults as well as custom
entries. See the [Wispr Flow input profile](transcription/wispr-flow/README.md)
for device routing and switching details.

| Input | Wispr code | Result | Origin |
| --- | --- | --- | --- |
| Escape | `53` | Dismiss Wispr | Built-in default |
| Right Option | `61` | Start or stop hands-free dictation, `popo` | Custom, replaces `Fn+Space` |
| Fn | `63` | Push-to-talk, `ptt` | Built-in default |
| `Ctrl+Fn` | `59+63` | Open Wispr Lens | Built-in default |
| `Cmd+Ctrl+C` | `55+59+8` | Copy the last dictated text | Built-in default |
| `Cmd+Ctrl+V` | `55+59+9` | Paste the last dictated text | Built-in default |

The derived Wispr cache also contains `Cmd+Z` for undo and `Cmd+V` for a paste
event. They are absent from `prefs.user.shortcuts`, so they are not treated as
authoritative active shortcuts.

## Spokenly

The current Spokenly `Default Mode` uses Right Option with Automatic
activation.

| Input | Result | Origin |
| --- | --- | --- |
| Brief Right Option press | Toggle recording on or off | Custom user selection in Spokenly |
| Hold Right Option | Push-to-talk; release stops recording | Same Automatic shortcut |

The physical keyboard supports both interactions directly. The trackpad,
Magic Mouse, and MX Master hands-free inputs open the background helper
documented above. The helper calls the official `spokenly://toggle` deeplink.

See the [Spokenly input profile](transcription/spokenly/README.md) for live
settings, device compatibility, automation hooks, and the implemented provider
switch.

## Related Karabiner remaps

| Physical input | Result | Impact |
| --- | --- | --- |
| Ducky Right Command | Right Option | Emits the shared Right Option input because the Ducky swaps Command and Option |
| Ducky Right Option | Right Command | Does not emit the shared transcription trigger |
| Mouse button 4 | `Ctrl+Z` | Karabiner-only remap; it is not a Wispr shortcut |

The Mouse button 4 Karabiner rule is labelled for Wispr Flow, but `Ctrl+Z` is
not present in Wispr's authoritative shortcut list. Wispr's former raw Mouse 4
and Mouse 5 hands-free bindings were removed on 2026-07-31.

## Maintenance

Update this file whenever a Logitech Options+ profile, BetterTouchTool trigger,
Wispr shortcut, Spokenly shortcut, or related Karabiner remap changes. Record
current behavior here, and keep implementation history and troubleshooting
detail in the specialized guides.

Audit the live sources before editing this reference:

- Logitech Options+: `~/Library/Application Support/LogiOptionsPlus/settings.db`
- BetterTouchTool: the current `btt_data_store.version_*` database under
  `~/Library/Application Support/BetterTouchTool/`, or BTT's `get_triggers`
  AppleScript command
- Wispr Flow: `~/Library/Application Support/Wispr Flow/config.json`, especially
  `prefs.user.shortcuts`
- Karabiner: `mac/.config/karabiner/karabiner.json`
- Provider switch: `mac/.local/bin/trx`
