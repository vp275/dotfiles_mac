# Spokenly Transcription Setup

## Purpose

This directory documents the current Spokenly input setup:

- The application's built-in defaults.
- The shortcuts customized in this setup.
- The physical input paths for the MacBook and Ducky keyboards, MacBook
  trackpad, MX Master 3S, and Magic Mouse.
- Verification notes and source-of-truth paths.

Keeping these categories separate is important. A shortcut appearing in an
application's saved preferences does not necessarily mean it was created in
this dotfiles setup.

## Current Provider

| Provider | Profile | Status |
| --- | --- | --- |
| Spokenly | [Spokenly profile](spokenly/README.md) | Installed and verified against the current live configuration |

Spokenly is the sole configured transcription provider. Additional providers
should be audited independently before adding their shortcuts or device routes.

## Current Spokenly Input Paths

Three hands-free toggle inputs converge on the same background helper. MacBook
Fn is a separate direct Spokenly push-to-talk control:

| Physical input | Owner | Action |
| --- | --- | --- |
| MacBook Fn held while speaking | Spokenly | Push-to-talk; release stops recording |
| Trackpad 3-finger tap | BetterTouchTool | Opens `Spokenly Toggle.app` |
| Magic Mouse TipTap Left, 1 Finger Fix | BetterTouchTool | Opens `Spokenly Toggle.app` |
| MX Master auxiliary/thumb button | Logitech Options+ | Runs Smart Action `Spokenly Hands-Free`, which opens `Spokenly Toggle.app` |

`Spokenly Toggle.app` calls the official `spokenly://toggle` deeplink without
foreground activation. Standalone Right Option is not a Spokenly toggle. It
remains a native modifier in keyboard chords, and no repository-level
standalone Right Option mechanism is configured. MacBook Fn remains available
for push-to-talk.

See the [Spokenly input profile](spokenly/README.md) for exact identifiers,
live preference serialization, helper details, and verification steps.

## Documentation Rules

- Label every shortcut as `Built-in default`, `Custom`, or `Removed`.
- Record live behavior separately from historical experiments.
- Keep stable trigger IDs, slot IDs, bundle IDs, and source-of-truth paths.
- Update [the quick shortcut reference](../shortcut-reference.md) when current
  behavior changes.
- Keep detailed Logitech and BetterTouchTool troubleshooting in their existing
  setup guides.
