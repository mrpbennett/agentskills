# Pre-Publish Checklist

Run through all four items before telling the user their plugin is ready to
submit or share. These mirror the submission checklist used for listing a
plugin publicly (e.g. on omarchyplugins.com). Treat them as gates, not
suggestions — a plugin that fails any of them isn't ready.

Three of these you can verify yourself from the repo contents. One of them
you cannot: it's an attestation only the human submitter can make.

## 1. The repository is public and contains installation and removal instructions.

Verify:
- The remote is actually public. If it's on GitHub: `gh repo view <owner>/<repo> --json isPrivate`
  (read-only check — this assistant does not create or change repo
  visibility). If the user hasn't pushed yet, this item isn't satisfied
  yet — say so.
- `README.md` contains an **Install** section with the literal command:
  ```bash
  omarchy plugin add https://github.com/<user>/<repo>.git --enable
  ```
- `README.md` contains a **Remove** section with:
  ```bash
  omarchy plugin remove <id>
  ```
- Bonus but recommended: an **Update** section with
  `omarchy plugin update <id>`.

Missing any of these → not done. Point at the exact missing section rather
than rewriting the whole README.

## 2. The plugin license and any external dependencies are documented.

Verify:
- A `LICENSE` (or `LICENSE.md`) file exists at the repo root. This skill
  does not pick a license for the user — that's their call. If they need a
  pointer, https://choosealicense.com is a reasonable one to suggest.
- `README.md` names the license (not just "see LICENSE file" — state which
  one).
- `README.md` has a **Dependencies** section (or equivalent) listing:
  - Any binaries the plugin shells out to (`Process`/`exec`-style calls in
    the QML)
  - Any non-Quickshell-stdlib QML imports
  - Any network calls the plugin makes and to what
- If the plugin has zero external dependencies, the README should say so
  explicitly ("No external dependencies") rather than omitting the section
  — omission reads as undocumented, not as "none."

Grep for the risky bits instead of trusting a description:
```bash
grep -rnE 'Process|exec|Quickshell\.exec|fetch|XMLHttpRequest|Http' ./my-plugin --include='*.qml'
```
Anything that turns up needs a line in the Dependencies section.

## 3. Ownership/permission to submit the plugin and its preview assets. — ATTESTATION ONLY

**This item cannot be verified by inspecting the repo, and this assistant
must not check it off on the user's behalf.** Code and screenshots don't
carry proof of authorship. Ask the human directly:

> "Do you own this plugin's code and any screenshots/GIFs/preview images in
> it, or do you otherwise have permission to submit them?"

Only proceed once the user has explicitly confirmed. If any preview asset
came from somewhere else (a stock icon, a screenshot of someone else's
theme, art pulled from another repo), that needs either removal, a license
that permits redistribution, or explicit attribution — don't let it pass
silently.

## 4. The plugin does not overwrite user configuration without explicit consent.

Verify by reading the plugin's own code, not by asking the author to
self-report:
```bash
grep -rnE '\.config/omarchy|shell\.json|writeFile|FileIO' ./my-plugin --include='*.qml'
```
For anything that writes outside the plugin's own directory
(`~/.config/omarchy/plugins/<id>/`) — especially `shell.json` or another
plugin's files:
- It must be behind an explicit user action (a button press, a setting the
  user opts into), never a silent write on load/startup.
- The README should document what it writes and when.
- It must never touch another plugin's directory.

A plugin that only ever reads `shell.json` (e.g. to react to bar layout) is
fine. A plugin that writes to it — or to any file outside its own plugin
folder — without the user having asked for that specific action fails this
check.

## Sign-off

Only report the plugin as publish-ready once:
- [ ] Item 1 verified (public repo + install/remove docs in README)
- [ ] Item 2 verified (LICENSE file + Dependencies section, or explicit "none")
- [ ] Item 3 confirmed **by the user**, not assumed
- [ ] Item 4 verified (no config writes outside the plugin's own folder without an explicit user action)
- [ ] `omarchy plugin validate ./my-plugin` passes with no errors
