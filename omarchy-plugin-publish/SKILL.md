---
name: omarchy-plugin-publish
description: >
  Scaffold, validate, and publish a third-party Omarchy shell plugin (bar
  widget, panel, overlay, menu, service, or bar replacement) as a public git
  repository. Use when the user wants to create a NEW Omarchy shell plugin,
  package one for distribution, prepare it for the omarchyplugins.com
  directory, or write its manifest.json/README/LICENSE. Covers the
  pre-publish checklist (public repo with install/removal docs, license and
  dependency disclosure, ownership/rights attestation, no silent config
  overwrites) and the `omarchy plugin add/validate/update/remove` install
  flow end users will follow. Distinct from the `omarchy` skill's
  plugins.md, which covers using or cloning plugins that already exist on an
  installed system — this skill is for authoring and shipping a new one.
effort: low
---

# Omarchy Shell Plugin: Author & Publish

Read this before building a new Omarchy shell plugin for public distribution,
or before preparing an existing one for submission to
[omarchyplugins.com](https://omarchyplugins.com).

This skill is about **authoring a plugin repo from scratch and getting it
ready to ship**. If the user instead wants to customize a plugin that's
already installed or built-in, that's `omarchy plugin clone` territory —
use the `omarchy` skill's `plugins.md` guide instead.

## Scope check: where does this repo live?

A plugin *repo you're developing* is a normal git project — it lives
wherever the user keeps their source (e.g. `~/src/omarchy-weather/`), not
under `~/.config/omarchy/plugins/`. It only lands in
`~/config/omarchy/plugins/<id>/` once someone runs `omarchy plugin add` (or
the developer symlinks it there for live testing). Don't confuse the two
locations.

**GitHub is read-only for this assistant** per the user's global policy: no
creating repos, no pushing, no commits/PRs. This skill scaffolds files
locally and validates them — the user pushes to their own remote and
creates the public repo themselves, unless they've explicitly told you
otherwise for this session.

## Workflow

1. **Pick the plugin kind(s)** and confirm the `id` (`username.pluginname`,
   e.g. `dhh.clock` — see [`manifest-schema.md`](manifest-schema.md)). The
   `omarchy.` namespace is reserved for built-ins; never use it.
2. **Scaffold the repo** from [`templates/`](templates/):
   - `manifest.json` — fill in `id`, `name`, `version`, `kinds`,
     `entryPoints`, and (for `bar-widget`) the `barWidget` block.
   - One QML file per declared kind, matching the `entryPoints` paths.
   - `README.md` — see the [README section](#readme-requirements) below.
   - `LICENSE` — see [`checklist.md`](checklist.md) item 2.
3. **Validate the manifest** before going further:

   ```bash
   omarchy plugin validate ./my-plugin
   ```

   This checks schema-version compliance, required fields, that the `id`
   doesn't collide with the reserved `omarchy.` namespace, that every
   declared kind has a matching entry point that exists as a safe relative
   path, and that there are no symlinks inside the plugin folder. Fix
   everything it flags — don't publish past a validation failure.
4. **Look at real examples before writing QML.** Don't guess at the
   Quickshell/plugin API. Read existing built-in plugins for real patterns
   (reading is always safe, per the `omarchy` skill's safety rules):

   ```bash
   ls "$OMARCHY_PATH/shell/plugins/"
   cat "$OMARCHY_PATH/shell/plugins/<name>/manifest.json"
   cat "$OMARCHY_PATH/shell/plugins/<name>/"*.qml
   ```

5. **Run the full pre-publish checklist** in
   [`checklist.md`](checklist.md) — all four items, including the one only
   the human can attest to (ownership of the plugin and any preview
   assets). Do not check that item off on the user's behalf; ask them to
   confirm it explicitly.
6. **Hand off for publishing.** Tell the user to create the public repo and
   push (or do it yourself only if they've explicitly asked you to write to
   GitHub in this session). Once public, installers use:

   ```bash
   omarchy plugin add https://github.com/<user>/<repo>.git --enable
   ```

## README Requirements

Every third-party plugin README must give installers everything Omarchy's
own manual describes at
[omarchy.org/manual/shell-plugins/#adding-a-plugin-from-git](https://omarchy.org/manual/shell-plugins/#adding-a-plugin-from-git).
Start from [`templates/README.md.template`](templates/README.md.template),
which includes:

- **What it is** — one-paragraph description, screenshot/GIF if it's a
  visual widget (only assets the submitter actually owns — see checklist
  item 3).
- **Install** — the exact command, with the real repo URL substituted in:

  ```bash
  omarchy plugin add https://github.com/<user>/<repo>.git --enable
  ```

  Note for readers that Omarchy will show a trust warning first (plugins
  run as unsandboxed code inside the long-lived shell process) and require
  explicit confirmation before cloning into
  `~/.config/omarchy/plugins/<id>/`. It never runs an install hook or asks
  for sudo.
- **Update**:

  ```bash
  omarchy plugin update <id>
  ```

- **Remove**:

  ```bash
  omarchy plugin remove <id>
  ```

- **License** — name it and link/include the LICENSE file.
- **Dependencies** — anything the plugin shells out to, imports, or talks
  to over the network (see checklist item 2).

## Decision Framework

1. **Building a brand-new plugin?** Scaffold from `templates/`, then follow
   the numbered workflow above.
2. **Plugin already has code, just needs packaging for release?** Skip to
   step 3 (validate) and confirm `README.md`/`LICENSE` meet the
   requirements above, then run the checklist.
3. **Just want to run `omarchy plugin validate`?** That alone doesn't
   require this skill's full checklist — just run the command.
4. **User wants to customize/clone a plugin that's already installed?**
   Wrong skill — use `omarchy`'s `plugins.md` instead.
5. **Unsure about a manifest field or QML API?** Don't guess — read a
   built-in plugin's source under `$OMARCHY_PATH/shell/plugins/` first.

## Example Requests

- "Help me build an Omarchy bar widget that shows my calendar" → scaffold a
  `bar-widget` kind plugin, walk through the manifest and README, run
  `omarchy plugin validate`.
- "I've got a plugin working locally, get it ready to publish" → jump to
  the pre-publish checklist and README requirements.
- "What needs to be true before I submit to omarchyplugins.com?" →
  [`checklist.md`](checklist.md).
- "Does my manifest.json look right?" → cross-check against
  [`manifest-schema.md`](manifest-schema.md), then run
  `omarchy plugin validate`.
