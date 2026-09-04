---
name: mockup-sync
description: Convert a saved outerHTML capture of a SEVIMA Platform page into a clean static mockup wired live to the QUANTUM design system, plus a drift/token report. Use when the user says things like "sync outerHTML ini ke QUANTUM", "buatkan mockup dari halaman yang aku save", or "/mockup-sync <file>".
---

# Mockup ↔ QUANTUM sync

Full background and rationale: [`mockups/README.md`](../../../mockups/README.md).
Non-technical step-by-step guide for designers/PMs (how to capture a page,
what to type, how to read the report): [`mockups/TUTORIAL.md`](../../../mockups/TUTORIAL.md).
Root-level versioning/deploy conventions (why pages end up in `v1/`, the
`<base href="/v1/">` pattern, how Vercel serves it): [`README.md`](../../../README.md).
This skill operationalizes the mockup-sync flow so it runs end-to-end from
one prompt.

## When invoked

The user gives you a path (or just a filename) to a raw outerHTML capture,
usually sitting under `mockups/raw/<name>/`, or newly dropped at the project
root. `args` may contain the path and optionally a `module/page` target, e.g.
`/mockup-sync raw/kerjasama-daftar/Daftar Kerjasama.html kerjasama/daftar`.

Output follows the same versioned-folder convention as the sibling
`tracer-study` project: every page for the current design iteration
(`v1` right now - see `CURRENT_VERSION` in `build_mockup.py`) is written
**flat** into `v1/` at the repo root, not grouped into per-module
subfolders - `v1/kerjasama.html`, `v1/kerjasama-detail.html`, `v1/mitra.html`,
`v1/index.html`, etc. all sit as siblings, sharing one `v1/assets/` (vendored
QUANTUM CSS/JS/fonts, chart scripts, archived capture CSS - copied once,
reused by every page). The `module/page` target you pass (e.g.
`kerjasama/daftar`) still matters - it's the route-map key AND it decides
the output filename via `output_stem()` in `build_mockup.py`:
- `kerjasama/index` (this version's home/dashboard - see `HOME_PAGE_ID`) -> `v1/index.html`
- any other `<module>/index` or `<module>/daftar` (that module's own
  main/list page) -> `v1/<module>.html`
- `<module>/<page>` where `<page>` already starts with `<module>-` ->
  `v1/<page>.html` as-is (avoids a stutter like
  `kerjasama-kerjasama-mitra.html`)
- anything else -> `v1/<module>-<page>.html`

**Determine the module from the captured URL, not from what the page looks
like** - but a few second-level URL segments are the exception, because
they're their own reference-data entity even though they live under a
broader module's URL prefix. Read the `saved from url=(NNN)https://host/path`
comment on the raw capture's first line: the module is normally the first
real path segment (skip `v1`/`v2`/`api`), UNLESS the *second* segment is
listed in `SUB_ENTITY_SEGMENTS` in `build_mockup.py` (currently `mitra` and
`unit-kerja`) - then that second segment IS the module. Concretely, in this
project: `/v2/kerjasama/dashboard` -> `kerjasama/index` (a page that *looks*
like a dashboard, but it's this app's actual home page, not its own
`dashboard` module - don't be fooled by the page's title); `/v2/kerjasama/mitra/62`
-> `mitra/detail` (NOT `kerjasama/mitra-detail` - `mitra` is a sub-entity,
so it gets its own module identity: `v1/mitra.html`, `v1/mitra-detail.html`,
...); `/v2/kerjasama/kerjasama-mitra/63` -> `kerjasama/kerjasama-mitra`
(NOT treated as a `mitra` sub-entity - `kerjasama-mitra` isn't in
`SUB_ENTITY_SEGMENTS`, so it stays grouped under `kerjasama`, landing on
`v1/kerjasama-mitra.html` via the de-stutter rule above). If a page's URL
doesn't fit any existing module, a single-segment target (e.g. `login`) is
fine and becomes `v1/login.html`. The build itself also cross-checks this:
if the module you pass doesn't match what `suggest_module()` derives from
the URL (including the sub-entity exception), it prints a WARNING and adds
a banner at the top of that page's `manifest.md` - don't ignore it, rebuild
with the suggested module. If a future page needs a new sub-entity
recognized this way, add its URL segment to `SUB_ENTITY_SEGMENTS` rather
than hand-picking a filename for just that one page.

To start a new design iteration (`v2`, `v3`, ...): bump `CURRENT_VERSION` in
`mockups/scripts/build_mockup.py`, add a row to the root `README.md`, and
re-run the build for whichever pages belong to that version - see
"Menambah Versi Baru" in the root `README.md` for the full pattern
(mirrors tracer-study exactly).

## Steps

1. **Locate the raw file.** If the user just gave a bare filename that isn't
   yet under `mockups/raw/`, first move it (and its sibling `<name>_files/`
   folder, if present — that's a browser "Save Complete" asset dump) into
   `mockups/raw/<name>/` so future runs stay organized (raw capture folders
   stay one-per-capture even though the generated output goes flat into
   `v1/`, not grouped by module). Confirm with the user before moving files
   that live outside `mockups/` or `QUANTUM/` if it's ambiguous which
   capture they belong to.

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
   This writes `v1/<output_stem(module, page)>.html` (cleaned, static — see
   the filename rule above). For rendering CSS it prefers the page's own
   captured stylesheets (copied to `v1/assets/captured/` — ground truth,
   guaranteed to match production) and only falls back to the vendored
   QUANTUM release bundle (`v1/assets/vendors/quantum-v2.2.1-202310260001/assets/release/qn-202310260001.css`)
   when no `_files` capture folder exists. **Don't expect the fallback to
   look right**: that bundle is an Oct-2023 release that turned out to share
   almost no class-level CSS with this app's actual production markup
   (~9% of classes matched vs ~94% for captured CSS, checked directly) — a
   different, unrelated generation of the design system, not a "slightly
   behind" one. Always push for a proper "Save Complete" capture over
   relying on this fallback. Either way the vendored/captured CSS lives
   inside `v1/assets/` (shared/deduplicated across every page in the version
   — check-before-copy, so building the next page doesn't duplicate
   anything). It also writes `v1/<output_stem(module, page)>.manifest.md`
   (the component/token report) alongside the page. Never hand-edit
   anything under `v1/` — re-run the script if the source capture or
   QUANTUM changes; direct edits get silently overwritten/ignored next run.
   Check the manifest's "Rendering CSS source" line: if it says "QUANTUM
   vendor fallback", warn the user the visuals will likely look badly
   unstyled, not just slightly off, since there was no capture to render
   from — get a real capture instead if at all possible.

   There's no `npm install` shortcut here: QUANTUM (`@quantum/web`) is a
   private package hosted on SEVIMA's internal GitLab, not any registry this
   environment can reach, so vendoring a local copy from the `QUANTUM/`
   checkout (specifically `QUANTUM/pwa-laravel/public/vendors/quantum-v2.2.1-202310260001/`,
   the newest pre-built bundle available in any local QUANTUM checkout, used
   only as the last-resort fallback above) is the only offline-friendly
   option — that's what `v1/assets/vendors/` is, deduplicated across the
   whole version instead of per page.

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
   `mockups/route-map/v1.json` and rewrites every `<a href>`/`<form
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

5. **Offer to open the mockup** (`v1/<output_stem(module, page)>.html`) so the
   user can eyeball it in a browser. It's a self-contained static file: no
   Livewire, no build step - but it does need a local server, NOT a plain
   double-click (`file://`), because every page carries a `<base
   href="/v1/">` tag (see the root `README.md`) that requires an origin to
   resolve against. VS Code's **Live Preview** extension is easiest (its
   `.vscode/settings.json` default path is already `/v1/index.html`), or
   `npx serve .` from the repo root, then open `http://localhost:<port>/v1/<file>.html`.

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
- `mockup-interactions.js` and `set-header-height.js` are scaffolding for the
  mockup only - never suggest copying either into the real project, which
  already ships full Bootstrap JS and its own header-height logic. Say so
  explicitly if a user asks to "take the whole mockup" into the repo.
  `set-header-height.js` measures `.qn-header`'s real rendered height and
  sets it as `--qn-header-height` on load/resize - without it, anything the
  captured CSS positions with `var(--qn-header-height, 0)` (e.g. an
  offcanvas `.qn-sidebar`'s `top` offset) silently falls back to `0` and
  renders hidden behind the sticky header instead of below it, with no
  visible error. If a page looks like it's missing a whole section (a
  sidebar, a panel) that the capture clearly has markup for, check this
  before assuming the section itself is broken.