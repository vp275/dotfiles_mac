# Transcription Provider Profiles

## Purpose

This directory documents transcription applications as interchangeable input
providers. Each provider gets its own directory containing:

- The application's built-in defaults.
- The shortcuts and device mappings customized in this setup.
- The physical input paths for the MacBook trackpad, MX Master 3S, and Magic
  Mouse.
- The provider-specific values the `trx` switcher activates.
- Verification and rollback notes.

Keeping these categories separate is important. A shortcut appearing in an
application's saved preferences does not necessarily mean it was created in
this dotfiles setup.

## Provider Status

| Provider | Profile | Status |
| --- | --- | --- |
| Wispr Flow | [Wispr Flow profile](wispr-flow/README.md) | Documented from the current live configuration |
| Spokenly | [Spokenly profile](spokenly/README.md) | Documented from the current live configuration |
| Superwhisper | Not created | Planned |
| Hex | Not created | Planned; confirm the application name and bundle ID when profiling it |

Wispr Flow and Spokenly are documented. The other applications should be
audited one at a time before their directories and switching behavior are
added.

## `trx` Provider Switcher

The installed `trx` command selects one provider, redirects the three physical
inputs to that provider, and makes the selected application the only running
provider. Interactive terminal switches display an animated spinner and elapsed
seconds until the operation completes.

```text
trx spokenly
trx wispr
trx toggle
trx status
trx verify
trx plan spokenly
trx plan wispr
```

The initial logical input is:

| Logical input | Trackpad input | MX Master input | Magic Mouse input |
| --- | --- | --- | --- |
| `primary_dictation_trigger` | 3-finger tap | Auxiliary/thumb button | TipTap Left, 1 Finger Fix |

Each provider profile defines what a short input and a held input mean.
Spokenly can interpret both interactions through one Automatic shortcut. Wispr
Flow uses separate hands-free and push-to-talk shortcuts. The trackpad, MX
Master, and Magic Mouse are now provider-specific Spokenly inputs. All three
open the background `Spokenly Toggle` helper, which calls Spokenly's official
`spokenly://toggle` deeplink. The helper routes avoid generated keyboard
shortcuts and the synthetic Right Option events that Spokenly rejected.

Every provider switch:

1. Creates a timestamped rollback snapshot.
2. Replaces the two global BTT triggers for the trackpad and Magic Mouse.
3. Replaces the MX Master `c195` assignment in every Logitech profile listed
   by the live database.
4. Verifies the BTT mappings, Logitech mappings, Wispr shortcut, and Logitech
   database integrity.
5. Stops the other provider and launches the selected provider.
6. Records the selected provider and shows a macOS notification.

The state file is `~/Library/Application Support/trx/active-provider`, backups
are under `~/Library/Application Support/trx/backups/`, and the log is
`~/Library/Logs/trx.log`. If a switch fails, `trx` restores the previous BTT,
Logitech, application, and saved-state configuration. A force kill or power
loss can leave `${TMPDIR}/trx.lock`; remove that directory only after confirming
that no `trx` process is running.

Wispr Flow and Spokenly both use Right Option as their configured application
shortcut, but they do not accept the same event sources. A provider switcher
therefore cannot leave every device adapter unchanged. The MX Master can switch
between direct Right Option for Wispr and the Logitech Smart Action for Spokenly.
The trackpad and Magic Mouse must switch between their Spokenly helper actions
and Right Option for Wispr.

See the [Spokenly switch details](spokenly/README.md#trx-provider-switch) for
the exact provider values and verification steps.

## Documentation Rules

- Label every shortcut as `Built-in default`, `Custom`, or `Removed`.
- Record live behavior separately from historical experiments.
- Keep stable trigger IDs, slot IDs, bundle IDs, and source-of-truth paths.
- Update [the quick shortcut reference](../shortcut-reference.md) when current
  behavior changes.
- Keep detailed Logitech and BetterTouchTool troubleshooting in their existing
  setup guides.
