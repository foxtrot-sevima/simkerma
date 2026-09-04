# Mockup sync report - kerjasama/mitra-detail

- Source capture: `mockups/raw/Kerjasama/SEVIMA Platform - Detail Mitra.html`
- Generated mockup: `v1/kerjasama-mitra-detail.html`
- Rendering CSS source: **captured (3 file(s))**
  (this page's own captured stylesheet was used, so visuals should match production exactly)
- Everything is local now - 4 font/pattern url()s resolved to first-party QUANTUM files (`quantum-symbols`, header/sidebar patterns), 0 unresolvable external url()s dropped to `none`.

## Internal navigation

- Links pointing to other app pages that already have a mockup built: **12** - rewritten to open that mockup directly (navbar tabs, "Tambah"/Edit/Detail buttons, etc. actually navigate, same as production).
- Links with no matching mockup yet: **12** - left as `#` for now. Capture one of these pages next and re-run the build (any slug) to wire them up automatically, on this page AND every other mockup that links to it:

  - `/gate/menu`
  - `/v2/gate/sessions/logout`
  - `/v2/gate/sessions/switch-role`
  - `/v2/kerjasama`
  - `/v2/kerjasama/bentuk-kegiatan`
  - `/v2/kerjasama/jenis-dokumen`
  - `/v2/kerjasama/kegiatan`
  - `/v2/kerjasama/kriteria-mitra`
  - `/v2/kerjasama/laporan-kerjasama`
  - `/v2/kerjasama/sasaran-kinerja`
  - `/v2/kerjasama/sumber-dana`

## Interactions

Detected on this page and wired up via `mockup-interactions.js` (a small local Bootstrap-5-compatible re-implementation - the real production JS bundle isn't reusable from a static capture, but the CSS state classes it drives are the same ones already in the captured stylesheet, so behavior matches production):

- Collapse panels (navbar toggler, accordions, filter drawers): **1** trigger(s)
- Dropdowns (navbar menus, filter pickers, etc.): **3** trigger(s)
- Modals: **1** trigger(s)
- Offcanvas panels: **1** trigger(s)

Charts: 0 functional script(s) vendored locally (Chart.js + datalabels plugin + chart-settings) and the real inline chart-init script (with its actual data) was preserved - charts render for real, not a static image.

**Create/update flash alerts**: a `.alert` that's already in the captured DOM will display and dismiss correctly (see Interactions above). But an alert that only appears *after* submitting a real create/update form can't be triggered here - there's no backend. If pixel-perfect before/after states matter, capture the page again right after triggering that alert in the real app, and re-run this script.

## Cleanup

- `<script>` tags removed: 12
- Browser-extension injected tags removed: 1
- Debug toolbar / var-dump blocks removed: 3
- Livewire/Alpine attributes stripped: 1
- Turbo/CSRF/Livewire-wiring attributes stripped (dead weight for slicing): 11
- Stale Chart.js-computed `style` cleared off `<canvas>` (recomputed on load): 0
- Preload/prefetch links removed: 9
- Dead/extension `<style>` blocks removed: 2
- HTML comments stripped: 3
- Captured `<link rel=stylesheet>` dropped (replaced by the QUANTUM vendor bundle above): 4
- Captured `<script src>` dropped: 4 (0 of those kept - see Charts/Dropdowns above)
- Images re-pointed to the local capture's asset folder: 2
- Favicon swapped for the capture's own logo (browsers don't save the real favicon file)

## Classes found in this page vs. the local QUANTUM copy

- Matched known QUANTUM classes: **181**
- `sym-*` icon classes referenced: **0**
- Bootstrap-style utility classes: **3**
- `qn-*` classes NOT found in local QUANTUM copy (possible drift): **1**
- Other/unclassified (likely app-specific, one-off): **4**

### ⚠️ Possible design-system drift

These look like QUANTUM component classes (`qn-` prefix) but weren't found in any local QUANTUM checkout (`QUANTUM/quantum`, `QUANTUM/quantum-monorepo`, or `QUANTUM/quantum-ai/source/quantum-v3.4`). Either every local copy is behind the live app, or these were built ad-hoc and should be proposed back to QUANTUM as a `[Suggestion]` issue (see `QUANTUM/quantum/README.md` - use `/label ~"suggestion" ~"component"`).

- `qn-header` (1x)

### Other / app-specific classes (review manually)

- `box-switch` (3x)
- `gf-app` (1x)
- `give-freely-root` (1x)
- `truncate-2` (1x)

## Colors

Raw hex values with **no** matching QUANTUM token (review with the design team before reusing):

- `#5d88f6`
- `#29d`
