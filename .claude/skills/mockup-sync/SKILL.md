---
name: mockup-sync
description: Convert a saved outerHTML capture of a SEVIMA Platform page into a clean static mockup wired live to the QUANTUM design system, plus a drift/token report. Use when the user says things like "sync outerHTML ini ke QUANTUM", "buatkan mockup dari halaman yang aku save", or "/mockup-sync <file>".
---

# Mockup ↔ QUANTUM sync

Full background and rationale: [`mockups/README.md`](../../../mockups/README.md).
Non-technical step-by-step guide for designers/PMs (how to capture a page,
what to type, how to read the report): [`mockups/TUTORIAL.md`](../../../mockups/TUTORIAL.md).
This skill operationalizes that flow so it runs end-to-end from one prompt.

## When invoked

The user gives you a path (or just a filename) to a raw outerHTML capture,
usually sitting under `mockups/raw/<name>/`, or newly dropped at the project
root. `args` may contain the path and optionally a `module/page` target, e.g.
`/mockup-sync raw/kerjasama-daftar/Daftar Kerjasama.html kerjasama/daftar`.

Pages are grouped **one folder per module** under `mockups/pages/`, not one
folder per page - `mockups/pages/kerjasama/daftar.html`,
`mockups/pages/kerjasama/detail.html`, `.../create.html`, etc. all live
together and share a single `_assets/` folder, since they're always built
from the exact same QUANTUM/app CSS+JS bundle regardless of which page it's
attached to.

**Determine the module from the captured URL, not from what the page looks
like.** Read the `saved from url=(NNN)https://host/path` comment on the raw
capture's first line - the module is the first real path segment (skip
`v1`/`v2`/`api`). A page that visually looks like a "dashboard" can still
belong to another module: in this project, the page that *looks* like a
dashboard was captured from `/v2/kerjasama/dashboard`, so it's
`kerjasama/index`, NOT its own standalone `dashboard/` module - don't be
fooled by the page's title or content. If a page's URL doesn't fit any
existing module, a single-segment target (e.g. `login`) is fine and becomes
`mockups/pages/login/index.html`. The build itself also cross-checks this:
if the module you pass doesn't match the URL's segment, it prints a WARNING
and adds a banner at the top of that page's `manifest.md` - don't ignore it,
rebuild with the suggested module so the page joins its real siblings
instead of sitting isolated in its own folder.

## Steps

1. **Locate the raw file.** If the user just gave a bare filename that isn't
   yet under `mockups/raw/`, first move it (and its sibling `<name>_files/`
   folder, if present — that's a browser "Save Complete" asset dump) into
   `mockups/raw/<name>/` so future runs stay organized (raw capture folders
   stay one-per-capture even though the generated output groups by module).
   Confirm with the user before moving files that live outside `mockups/` or
   `QUANTUM/` if it's ambiguous which capture they belong to.

2. **Make sure the token registry is fresh.** If `mockups/tokens/design-tokens.json`
   or `mockups/tokens/component-classes.json` don't exist yet, or the user
   mentions QUANTUM was just updated/pulled, run:
   ```
   python mockups/scripts/extract_tokens.py
   ```

3. **Build the mockup.**
   ```
   python mockups/scripts/build_mockup.py raw/<name>/<filename>.html <module>/<page>
   ```
   This writes `mockups/pages/<module>/<page>.html` (cleaned, static). For
   rendering CSS it prefers the page's own captured stylesheets (copied to
   `mockups/pages/<module>/_assets/captured/` — ground truth, guaranteed to
   match production) and only falls back to a vendored copy of QUANTUM's
   compiled CSS (`_assets/quantum.css` + `_assets/vendor/`) when no `_files`
   capture folder exists. Either way the CSS lives inside the module's own
   `_assets/` folder — no cross-directory links — so it renders correctly
   whether opened by double-click, Live Server, or a VSCode webview, AND is
   shared/deduplicated across every page in that module (copied once, reused
   by the rest - check-before-copy, so building a second page in the same
   module doesn't duplicate anything). It also writes
   `mockups/pages/<module>/<page>.manifest.md` (the component/token report).
   Never hand-edit anything under `pages/` — re-run the script if the source
   capture or QUANTUM changes; direct edits get silently overwritten/ignored
   next run.
   Check the manifest's "Rendering CSS source" line: if it says "QUANTUM
   fallback", warn the user the visuals may not exactly match production
   since there was no capture to render from.

   There's no `npm install` shortcut here: QUANTUM (`@quantum/web`) is a
   private package hosted on SEVIMA's internal GitLab, not any registry this
   environment can reach, so vendoring a local copy from the `QUANTUM/`
   checkout is the only offline-friendly option — that's what `_assets/`
   is, just deduplicated per module instead of per page.

   The build is offline-only by design: it vendors Chart.js + the real
   chart-init script (so charts render from actual data, not a screenshot),
   reimplements **every** standard Bootstrap 5 `data-bs-*` interaction with a
   small local script (`mockup-interactions.js`) matching Bootstrap's own CSS
   state-class contract — dropdown, collapse (navbar toggler, filter panels,
   accordions), modal, offcanvas, tabs/pills, and alert-dismiss all covered
   generically, not hardcoded per page (the real bundle is an ES module that
   imports chunks the capture never saved, so it can't be reused as-is).
   Whatever a given page actually uses gets auto-detected and listed under
   the manifest's "Interactions" section — nothing to configure per page.
   It also resolves hashed font/pattern references against
   `QUANTUM/quantum-ai/source/quantum-v3.4/` when there's a first-party match,
   strips framework-glue attributes (Turbo/CSRF/Livewire wiring - dead weight
   once there's no backend behind the mockup) and stale Chart.js-computed
   canvas styles. If a future page references an asset with no local match
   anywhere in `QUANTUM/`, the manifest will say so under "external url()s
   dropped" — don't silently re-point those at the live/testing server to
   make it "look right".

   **Cross-page navigation is dynamic, not hardcoded.** Every capture made
   via "Save Complete" carries a `saved from url=(...)` comment recording
   the real route it came from; the build records that in
   `mockups/pages/route-map.json` and rewrites every `<a href>`/`<form
   action>` pointing at the live domain into a real link to whichever
   sibling mockup matches that route (navbar tabs, "Tambah", row-level
   Detail/Edit buttons - all of it, not special-cased per page). Links with
   no match yet become `#` but keep the original path on
   `data-mockup-unresolved`, and **every build also re-sweeps all previously
   built mockups** to fix up their own pending links against the
   now-current route map - so build order never matters, and an old
   mockup's dead "Detail" button starts working the moment you build the
   detail page, with no need to touch the old one again. When several
   captures share the exact same route (e.g. a detail page and its
   "berhasil diubah" confirmation state both live at `/kerjasama/{id}`),
   the resolver prefers the plain/canonical one over a `*-success` capture,
   so a list's "Detail" button doesn't land on a transient success screen.
   Delete/hapus buttons reuse the **real confirmation modal already in the
   capture** (same "Hapus X? ... tidak dapat dikembalikan" title/body/button
   labels QUANTUM ships) instead of a generic `confirm()` popup - detected by
   matching modal title/body wording, separately for per-row and bulk
   (checked-rows) delete, including the "you didn't select anything" warning
   modal when the bulk button is clicked with nothing checked. Confirming
   closes the modal and removes the row(s); no backend, but it looks and
   behaves like production. Only falls back to a plain `confirm()` when a
   trigger has no matching modal in the same document (or just a Livewire
   `wire:confirm` attribute and nothing else).

   Note the honest limitation: a create/update flash alert that only appears
   *after* a real form submission can't be triggered in a static mockup
   (there's no backend to respond). If the user needs that exact state,
   tell them to capture the page again right after triggering it live, then
   re-run the build — don't try to fake it with a hardcoded always-visible
   alert.

4. **Read `manifest.md`** and summarize it to the user in your own words, not
   a raw dump of the file. Call out, in priority order:
   - What's under "Internal navigation" — how many links now point at a real
     sibling mockup vs. are still pending (`#`, waiting for that page to be
     captured). If there are pending paths the user clearly cares about
     (e.g. an "Edit" button with no edit-form mockup yet), tell them exactly
     which page to capture next to complete the flow.
   - What's under "Interactions" — which dropdown/collapse/modal/offcanvas/
     tab/alert-dismiss triggers were found and are now live in the mockup.
     If the page clearly has a filter or navbar-toggler that *isn't* listed
     there, it likely doesn't use standard `data-bs-toggle` markup - flag
     that to the user rather than silently leaving it non-functional.
   - Any classes under "⚠️ Possible design-system drift" — these look like
     QUANTUM components (`qn-` prefix) but aren't in the local `QUANTUM/`
     checkout. Tell the user plainly whether this looks like (a) the local
     QUANTUM checkout being behind the live app, or (b) a genuinely new
     component that should be proposed back to QUANTUM. If they want to file
     it, draft the issue using the exact template/labels from
     `QUANTUM/quantum/README.md` (title format `[Suggestion]: ...`, labels
     `/label ~"suggestion" ~"component"`) — but only actually create/send
     anything if the user explicitly asks; drafting the text is enough by
     default.
   - Hex colors that already map to a QUANTUM token — recommend replacing the
     hardcoded hex with `var(--token-name)` in whatever real template/blade
     file the color was copy-pasted from (the mockup itself is disposable;
     the point is fixing the source).
   - Hex colors with no matching token at all — flag as "not in design
     system yet", don't invent a token for them.
   - The "Other / app-specific classes" bucket — one-line judgment on
     whether each looks like a legitimate one-off or something worth
     promoting into QUANTUM.

5. **Offer to open the mockup** (`mockups/pages/<module>/<page>.html`) so the
   user can eyeball it in a browser. It's a self-contained static file: no
   Livewire, no build step, just double-click or open with a Live Server.

## Repeat for new pages

This is not dashboard-specific. Any time the user saves a new page's
outerHTML, the same three steps apply — just a new `<module>/<page>` target
(reuse the existing module name if it belongs to a module you've already
built pages for). Don't create a new script or process per page; reuse
`build_mockup.py` as-is. Building a new page also benefits every *earlier*
mockup that had a dead link pointing at this page's route — mention that
connection to the user when it happens (the build's own stdout and the
manifest's "Internal navigation" section both report how many older mockups
got relinked).

## Guardrails

- Don't edit anything under `QUANTUM/` — it's the source of truth, treated as
  read-only by this flow.
- Don't hand-clean HTML yourself as a substitute for running the script —
  the script's regex/known-class matching is what keeps every mockup's
  report consistent and comparable across pages. If the script mis-classifies
  something (e.g. a legitimate Bootstrap utility landing in "other"), fix the
  heuristic in `mockups/scripts/build_mockup.py` itself so every future page
  benefits, rather than manually patching just this one output.
- Every generated `<page>.html` is meant to be **slicing-ready**: DOM structure
  and classes stay byte-identical to the real capture (never simplified or
  rewritten), and framework-only glue attributes (Turbo/CSRF/Livewire) are
  stripped since they're dead weight once copied into a fresh Blade file. If
  you need to hand-adjust anything for a specific ask, prefer extending
  `build_mockup.py`'s cleanup rules over editing the generated HTML directly
  - direct edits get silently discarded next time the script re-runs.
- `mockup-interactions.js` is scaffolding for the mockup only - never suggest
  copying it into the real project, which already ships full Bootstrap JS.
  Say so explicitly if a user asks to "take the whole mockup" into the repo.