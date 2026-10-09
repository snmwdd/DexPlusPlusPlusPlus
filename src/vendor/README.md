# Supplied Cobalt bundle

`Cobalt.luau` is the unmodified Simplified Chinese fixed bundle supplied by the user.
Its header credits **deivid** and **upio** and identifies the upstream project as
<https://gitlab.com/upio/cobalt/>. Original author and dependency notices are retained.
No translator attribution was present in the supplied header, so none is invented.

Run `python3 src/adapt_cobalt.py` before the normal Lua build to regenerate
`modules/CobaltRuntime.lua`. The adapter changes Cobalt's UI palette, typography,
window mounting and initialization handoff. The Dex `Spy` module owns the window,
startup preload, duplicate-instance guard, error display and cleanup bridge. Spy,
serializer, actor and interception modules are retained from the supplied bundle.

Spy UI labels, placeholders, dialogs and notifications follow Dex's Chinese/English
setting through `SpyLocalization`. Captured remote/script names, argument values,
editable content and generated code are excluded from translation.
The menu entry and native title are `spy`. The original Cobalt close, minimize
and restore controls are removed. Spy loads synchronously under the existing Dex
startup intro, with its native GUI disabled until opened from the menu. Closing
or minimizing keeps capture initialized; Dex reload/unload destroys its runtime.
Settings and call-filter toggles use `Lib.Checkbox`; common actions use Dex icon
maps, retaining Cobalt's fallback for icons without a Dex equivalent. Checkbox
vetoes and failed saves restore the previous visual state. Sibling Z-index
ordering keeps secondary dialogs above the main-page rows.
