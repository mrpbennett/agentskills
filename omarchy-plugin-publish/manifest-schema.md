# manifest.json Reference

Source of truth: run `omarchy plugin validate ./my-plugin` — it enforces
all of this. This file is a quick reference so you don't have to trial-and-error
your way through validation errors.

## Required top-level fields

| Field | Type | Notes |
|-------|------|-------|
| `schemaVersion` | number | Currently `1`. |
| `id` | string | Unique, namespaced — see below. |
| `name` | string | Display name shown to users. |
| `version` | string | Plugin's own version string (e.g. `"0.1.0"`), unrelated to `schemaVersion`. |
| `kinds` | array | One or more of the kinds below. |
| `entryPoints` | object | Maps each declared kind to its QML file, as a safe relative path (no `..`, no absolute paths, no symlinks). |

## Plugin kinds

| Kind | Purpose |
|------|---------|
| `bar-widget` | A component placed in the bar. |
| `panel` | A floating window, persistent or summoned. |
| `overlay` | A fullscreen interface. |
| `menu` | A summoned menu surface. |
| `service` | A headless singleton with no UI. |
| `bar` | A full replacement for the default bar. |

A plugin can declare more than one kind (e.g. a `service` plus a
`bar-widget` that displays its state), but every kind listed in `kinds`
must have a matching entry in `entryPoints`.

## `barWidget` block (required when `kinds` includes `bar-widget`)

```json
"barWidget": {
  "name": "Display Name",
  "category": "...",
  "defaultSection": "right",
  "allowMultiple": false
}
```

- `name` — display name (can match top-level `name` or be more specific).
- `category` — classification used in the bar-widget picker UI. The exact
  set of valid category strings isn't nailed down here — check
  `$OMARCHY_PATH/shell/plugins/*/manifest.json` for real values in use, or
  let `omarchy plugin validate` tell you if yours is rejected.
- `defaultSection` — optional; which bar section (`left`/`center`/`right`)
  the widget lands in by default.
- `allowMultiple` — boolean; whether more than one instance can be added to
  the bar at once.

## Plugin ID naming convention

Built-in plugins all start with `omarchy.` — that namespace is **reserved**
and `omarchy plugin validate` will reject third-party manifests that use
it. Use a `username.pluginname` format instead, e.g. `dhh.clock`. This
keeps IDs collision-free across independently published plugins.

## Directory layout

```
my-plugin/
├── manifest.json
├── LICENSE
├── README.md
└── Widget.qml          # or however many QML files entryPoints references
```

Once installed, this same layout lands at
`~/.config/omarchy/plugins/<id>/` (third-party) — built-ins live at
`$OMARCHY_PATH/shell/plugins/` instead, which is package-owned and never
where you develop a third-party plugin.

## Validation rules `omarchy plugin validate` enforces

- `schemaVersion` is present and supported.
- All required fields above are present.
- `id` doesn't collide with the reserved `omarchy.` namespace, and doesn't
  collide with an already-installed plugin's id.
- Every declared kind has a corresponding `entryPoints` entry.
- Entry-point paths are safe relative paths and actually exist.
- No symlinks anywhere inside the plugin folder.

Fix every validation error before moving on — don't hand-wave past one
because "it'll probably still load."
