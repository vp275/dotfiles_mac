# Logitech Options+ and Spokenly Setup

Last audited: 2026-08-18

## Goal

Keep the MX Master 3S controls predictable across Codex, AI apps, terminals,
browsers, and Spokenly.

The important split:

- Chat and terminal-like apps, including Codex: wheel click sends `Enter`.
- Browsers: wheel click stays a real middle click.
- The auxiliary/thumb button opens `Spokenly Toggle.app` in every profile.

## Source of Truth

Logitech Options+ stores its profile state in:

```text
~/Library/Application Support/LogiOptionsPlus/settings.db
```

The real settings are stored as one JSON blob in SQLite table `data`, column
`file`.

## MX Master 3S Slot IDs

Observed device prefix:

```text
mx-master-3s-2b034
```

Useful slots:

| Slot | Physical control | Notes |
| --- | --- | --- |
| `mx-master-3s-2b034_c82` | Wheel click / middle button | `Enter` in terminal-like apps and Codex, `MB3` in browsers. |
| `mx-master-3s-2b034_c83` | Back button | Native Back in browsers/default; `Ctrl+Tab` in Codex. |
| `mx-master-3s-2b034_c86` | Forward button | Native Forward in browsers/default; `Cmd+K` in Codex. |
| `mx-master-3s-2b034_c195` | Aux/thumb-style button | Smart Action `Spokenly Hands-Free` in every current Logitech profile. It opens a background helper that calls `spokenly://toggle`. |
| `mx-master-3s-2b034_c196` | Gesture/top button | App navigation gesture card. |

## Current Logitech Profile Benchmark

### Full Profile Snapshot

Generated from the live Logitech Options+ database and rechecked on 2026-08-02.

| App/profile | Bundle id | Thumb button `c195` | Wheel click `c82` | Back `c83` | Forward `c86` |
| --- | --- | --- | --- | --- | --- |
| Desktop/default | global fallback | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Codex | `com.openai.codex` | Smart Action `Spokenly Hands-Free` | `Enter` | `Ctrl+Tab` | `Cmd+K` |
| Claude | `com.anthropic.claudefordesktop` | Smart Action `Spokenly Hands-Free` | `Enter` | Native Back | Native Forward |
| Warp | `dev.warp.Warp-Stable` | Smart Action `Spokenly Hands-Free` | `Enter` | Native Back | Native Forward |
| Ghostty | `com.mitchellh.ghostty` | Smart Action `Spokenly Hands-Free` | `Enter` | Native Back | Native Forward |
| Safari | `com.apple.Safari` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Google Chrome | `com.google.Chrome` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Brave Browser | `com.brave.Browser` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Firefox | `org.mozilla.firefox` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Helium | `net.imput.helium` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Native Back | Native Forward |
| Sioyek | `info.sioyek.sioyek` | Smart Action `Spokenly Hands-Free` | Real middle click: `MB3` | Right Arrow | Left Arrow |

Every current profile assigns the thumb button directly to the Spokenly Smart
Action. This avoids profile inheritance gaps.

### Wheel Click

| App/profile | Bundle id | Wheel click |
| --- | --- | --- |
| Codex | `com.openai.codex` | `Enter` key |
| Claude | `com.anthropic.claudefordesktop` | `Enter` key |
| Warp | `dev.warp.Warp-Stable` | `Enter` key |
| Ghostty | `com.mitchellh.ghostty` | `Enter` key |
| Desktop/default | global fallback | Real middle click: `MB3` |
| Safari | `com.apple.Safari` | Real middle click: `MB3` |
| Google Chrome | `com.google.Chrome` | Real middle click: `MB3` |
| Brave Browser | `com.brave.Browser` | Real middle click: `MB3` |
| Firefox | `org.mozilla.firefox` | Real middle click: `MB3` |
| Helium | `net.imput.helium` | Real middle click: `MB3` |

Use `Enter` for apps where wheel click means "send/submit current composer"
and a real middle click would steal focus.

Use `MB3` for browsers because middle click opens links in background tabs and
does browser-native tab behavior.

### Back / Forward

Known-good browser/default shape:

| Slot | Expected action |
| --- | --- |
| `c83` | `OSX_GESTURE_BACK` |
| `c86` | `OSX_GESTURE_FORWARD` |

Profiles currently matching that browser/default shape:

- Desktop/default
- Safari
- Google Chrome
- Brave Browser
- Firefox
- Helium
- Claude
- Warp
- Ghostty

Every current profile sets the thumb button (`c195`) to a macro reference for the
Logitech Smart Action `Spokenly Hands-Free`, ID
`d18fe790-d754-4fbc-8e82-0e5df78bda9e`. The Smart Action opens the background
helper at `~/Applications/Spokenly Toggle.app`; the helper calls Spokenly's
documented `spokenly://toggle` deeplink.

Codex currently has a custom four-button layout:

| Slot | Current Codex assignment |
| --- | --- |
| `c195` | Smart Action `Spokenly Hands-Free`; opens `Spokenly Toggle.app`, then `spokenly://toggle` |
| `c82` | `Enter` / `Return` |
| `c83` | `Ctrl+Tab` (`code: 43`, modifiers `[224]`) |
| `c86` | `Cmd+K` (`code: 14`, modifiers `[227]`) |

Treat Codex side buttons separately from browser side buttons.

### Codex Thumb Wheel And Sidebar Toggle

The Logitech Options+ application profile is displayed as `ChatGPT`, but it
targets the Codex application:

```text
Application: /Applications/ChatGPT.app
Bundle ID: com.openai.codex
```

The current known-good assignments are:

| Physical control | Assignment |
| --- | --- |
| Forward button | `Cmd+K` (`code: 14`, modifiers `[227]`) |
| Thumb wheel up | `Ctrl+B` (`code: 5`, modifiers `[224]`) |
| Thumb wheel down | `Cmd+Delete` (`code: 42`, modifiers `[227]`) |

The thumb-wheel-up shortcut is consumed by a Codex-specific BetterTouchTool
keyboard trigger. BTT then runs:

```text
~/Library/Application Support/BetterTouchTool/CustomScripts/codex-sidebar-toggle-debounced
```

That wrapper toggles the Codex sidebar between `By project` and `In one list`
through the compiled `codex-sidebar-toggle` helper. It suppresses repeated
invocations for `1.5` seconds because one physical thumb-wheel movement can
produce multiple `Ctrl+B` events. Before the debounce wrapper was added, the
sidebar could toggle twice and finish in its original state, which looked like
the shortcut had not run.

The Logitech settings database was backed up before repairing these
assignments:

```text
~/Library/Application Support/LogiOptionsPlus/settings.db.backup-codex-20260728
```

See the related BTT guide for trigger details and troubleshooting:

[Codex sidebar organization shortcut](btt/README.md#codex-sidebar-organization-shortcut)

## Related BetterTouchTool Docs

BetterTouchTool trackpad gestures and future Magic Mouse experiments are
documented separately:

[BetterTouchTool gesture setup](btt/README.md)

## Input Ownership Lessons

Do not route the Logitech auxiliary/thumb button through generated keyboard
chords or BetterTouchTool. Physical tests showed that Logitech-generated F20,
Hyper, `Ctrl+Shift+B`, and modified mouse clicks did not enter BTT's trigger
pipeline reliably.

Keep each input with one owner:

- Logitech Options+ owns the MX Master auxiliary/thumb button and opens
  `Spokenly Toggle.app`.
- BTT owns the trackpad and Magic Mouse Spokenly gestures.
- Browser wheel click remains native `MB3`.
- Chat and terminal wheel click sends `Enter` directly from Logitech Options+.
- BTT-generated Right Option is not a Spokenly-compatible replacement for the
  helper route.

### Codex And Browser Focus

Codex uses a plain `Enter` keystroke for wheel click. No mouse click reaches
Codex first, so focus is not moved before the send action.

Browser profiles keep wheel click as real `MB3`, preserving background-tab and
other browser-native middle-click behavior.

### YouTube PWA / Brave App Gotcha

YouTube installed from Brave can run as a separate app shim, for example:

```text
/Users/vp/Applications/Brave Browser Apps.localized/YouTube.app
com.brave.Browser.app.agimnkijcaahngcdmfeangaknmldooml
```

That may not use the normal Brave Browser profile. It can fall back to the
Desktop/default profile.

If YouTube behaves differently from Brave:

1. Check whether it is running as a Brave PWA/app shim.
2. Check the Desktop/default Logi profile.
3. If needed, create a dedicated Logi profile for the YouTube app bundle.

In this setup, the default profile should keep:

- Wheel click: `MB3`
- Back: `OSX_GESTURE_BACK`
- Forward: `OSX_GESTURE_FORWARD`

## Audit Commands

### Logitech Profile Summary

```bash
python3 - <<'PY'
import json, os, sqlite3

db = os.path.expanduser('~/Library/Application Support/LogiOptionsPlus/settings.db')
root = json.loads(sqlite3.connect(db).execute('select file from data limit 1').fetchone()[0])
apps = {a.get('applicationId'): a for a in root.get('applications', {}).get('applications', [])}

for pid in root.get('profile_keys', []):
    prof = root[pid]
    app = apps.get(prof.get('applicationId'), {})
    name = app.get('name') or prof.get('applicationId')
    bundle = app.get('bundleId') or ''
    print(f'\n{name}\t{bundle}\t{pid}')

    for slot in [
        'mx-master-3s-2b034_c82',
        'mx-master-3s-2b034_c83',
        'mx-master-3s-2b034_c86',
        'mx-master-3s-2b034_c195',
        'mx-master-3s-2b034_c196',
    ]:
        assignment = next((a for a in prof.get('assignments', []) if a.get('slotId') == slot), None)
        if not assignment:
            continue
        card = assignment.get('card', {})
        print(slot, card.get('id'), card.get('macro', {}))
PY
```

## Safe Editing Notes

Before editing Logitech settings manually:

1. Back up the database.
2. Quit Logi Options+ and stop its launch agent.
3. Patch the JSON blob in SQLite.
4. Run SQLite integrity check.
5. Restart Logi Options+.
6. Re-audit after restart because Logi can overwrite direct edits from memory.

Example backup path used during debugging:

```text
work/logi-backups/
```
