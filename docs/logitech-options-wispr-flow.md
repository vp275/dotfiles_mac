# Logitech Options+ and Transcription Setup

Last audited: 2026-08-01

## Goal

Keep the MX Master 3S controls predictable across Codex, AI apps, terminals,
browsers, Wispr Flow, and Spokenly.

The important split:

- Chat/terminal-like apps, including Codex: wheel click sends `Enter`.
- Browsers: wheel click stays a real middle click.
- Wispr Flow hands-free should not steal browser back/middle-click behavior.

## Source of Truth

Logitech Options+ stores its profile state in:

```text
~/Library/Application Support/LogiOptionsPlus/settings.db
```

The real settings are stored as one JSON blob in SQLite table `data`, column
`file`.

Wispr Flow stores shortcuts in:

```text
~/Library/Application Support/Wispr Flow/config.json
```

The authoritative Wispr shortcuts are under:

```text
prefs.user.shortcuts
```

`prefs.cache.splitKeybinds` is a derived/cache view and can be rebuilt by
Wispr.

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
| `mx-master-3s-2b034_c195` | Aux/thumb-style button | Provider-specific dictation action in every current Logitech profile. For Spokenly, the Smart Action opens a background helper that calls `spokenly://toggle`. |
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

`trx` assigns the provider-specific thumb action directly in every Logitech
profile listed by the live database. This avoids profile inheritance gaps.

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

## Current Wispr Flow Shortcut Benchmark

Wispr shortcuts currently relevant to this setup are shown below. The complete
effective list, with built-in and custom entries classified separately, lives
in the [Wispr Flow input profile](transcription/wispr-flow/README.md).

| Shortcut code | Wispr action | Origin |
| --- | --- | --- |
| `61` | `popo` / hands-free; right Option key | Custom |
| `63` | `ptt` | Built-in default |

Important absence:

- `4098 => enter_rebind` is intentionally removed.
- `4099 => popo` and `4100 => popo` are intentionally removed; the legacy raw
  Mouse 4 and Mouse 5 fallbacks are no longer needed.
- `65535 => popo` is intentionally removed. The Logitech aux/thumb button is
  now provider-specific and currently routes to Spokenly through a Logitech
  Smart Action.
- Physical middle click should not be globally bound in Wispr.

Why: when Wispr globally owns physical middle click, browser middle-click stops
being a normal browser middle-click.

## Related BetterTouchTool Docs

BetterTouchTool trackpad gestures and future Magic Mouse experiments are
documented separately:

[BetterTouchTool gesture setup](btt/README.md)

The provider-specific input mapping and implemented `trx` switch contract are
documented here:

[Wispr Flow transcription input profile](transcription/wispr-flow/README.md)

## Lessons Learned

### Do Not Use Logitech-Generated Chords As BTT Transcription Triggers

We tried mapping wheel click in Codex to a weird keyboard chord and then making
Wispr listen for that chord. It did not reliably trigger Wispr.

Better pattern:

- If the target app needs "send", set Logi wheel click directly to `Enter`.
- If the target app needs browser behavior, keep Logi wheel click as `MB3`.
- For Wispr Flow, make the transcription thumb button emit Right Option
  directly. Wispr treats Right Option (`61`) as `popo`. Run `trx wispr` to
  install that assignment in every current Logitech profile. Run
  `trx spokenly` to restore the `Spokenly Hands-Free` Smart Action in those
  profiles.
- Do not claim that a Logitech-generated F20, Hyper chord, `Ctrl+Shift+B`, or
  modified mouse click can be routed through BTT from `c195`. None reached BTT
  during physical testing.
- Do not claim that BTT-generated Right Option is Spokenly-compatible. Spokenly
  ignored both BTT's generic keyboard action and its dedicated modifier action.

### Codex Focus Problem

Historical note: this was the earlier layout before the later Codex button
swaps. The current Codex profile now uses wheel click (`c82`) for `Enter`,
thumb (`c195`) for the current Spokenly Smart Action, back (`c83`) for `Ctrl+Tab`, and
forward (`c86`) for `Cmd+K`.

Original bug:

- Wispr `Middle Click -> Press Enter` only worked when the cursor was inside
  the Codex composer.
- Clicking elsewhere in Codex moved focus before Wispr sent Enter.

Earlier fix:

- In the Codex Logi profile, set wheel click (`c82`) to a plain `Enter`
  keystroke instead of a physical middle click.
- This means no mouse click reaches Codex, so focus is not stolen.

### Browser Middle-Click Problem

Original bug:

- Helium/browser middle-click did not act like browser middle-click.

Cause:

- Wispr had global physical middle click (`4098`) bound to `enter_rebind`.

Fix:

- Remove Wispr `4098 => enter_rebind`.
- Keep browser Logi profiles as real `MB3`.

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

### Wispr Shortcut Summary

```bash
python3 - <<'PY'
import json, os

path = os.path.expanduser('~/Library/Application Support/Wispr Flow/config.json')
with open(path) as f:
    data = json.load(f)

print('prefs.user.shortcuts')
for key, value in sorted(data.get('prefs', {}).get('user', {}).get('shortcuts', {}).items()):
    print(key, '=>', value)

print('\nprefs.cache.splitKeybinds')
for binding in data.get('prefs', {}).get('cache', {}).get('splitKeybinds') or []:
    print(binding)
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
work/wispr-backups/
```

When changing Wispr shortcuts:

- Patch `prefs.user.shortcuts`.
- Patch `prefs.cache.splitKeybinds` only as a cache convenience.
- Restart Wispr and re-check because cache-only edits can be discarded.
