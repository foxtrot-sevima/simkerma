"""
Turn a raw "Save As > Webpage, Complete" outerHTML capture into a clean,
static mockup that is wired to the QUANTUM design system, plus a manifest
report showing which QUANTUM tokens/components were used (and what wasn't
found in the local QUANTUM copy).

Output follows the same versioned-folder convention as the sibling
`tracer-study` project: every page for the current design iteration
(`CURRENT_VERSION`, e.g. "v1") is written flat into `<version>/` at the repo
root - `v1/index.html`, `v1/kerjasama-daftar.html`, etc. - alongside a single
self-contained `v1/assets/` (vendored QUANTUM CSS/JS/fonts, chart scripts,
archived capture CSS). Each page gets a `<base href="/v1/">` tag so plain
relative asset/link paths resolve correctly once deployed (or previewed)
from the repo root - no `vercel.json` or rewrite rules needed, the folder
IS the URL. `module`/`page` (the CLI target, e.g. "kerjasama/daftar") is
still used to key `mockups/route-map/<version>.json` and to pick the output
filename (see `output_stem()`) - it just no longer determines a folder.

There's nothing to `npm install` here - QUANTUM is a private package
(`@quantum/web`, hosted on SEVIMA's internal GitLab, not any registry this
environment can reach) - vendoring a local copy is the only offline-friendly
option. The page's own captured production CSS (`assets/captured/`) is the
PRIMARY rendering CSS whenever a `_files` capture folder is available -
ground truth, guaranteed to match production. The vendored bundle
(`QUANTUM_VENDOR_SRC`) is only a last-resort fallback for a page with no
capture at all: it was tried as the primary source once (matching
tracer-study's own choice) and reverted after checking directly that it
shares almost no class-level CSS with this app's actual production markup
(~9% of classes matched vs ~94% for captured CSS) - a different, unrelated
generation of the design system, not a "slightly stale" one. tracer-study's
own bundle matches because its mockups were authored directly against that
same era; this app's captures are current production.

Usage:
    python mockups/scripts/build_mockup.py <path-to-raw-html> [module[/page]]

    <path-to-raw-html>  Absolute path, or a path relative to mockups/raw/
    [module[/page]]     Route-map key + filename source: <version>/<output_stem(module, page)>.html
                         - "kerjasama/daftar" -> v1/kerjasama-daftar.html
                         - "kerjasama/index" -> v1/index.html (this version's home/dashboard - see HOME_PAGE_ID)
                         - "login" (no slash) -> v1/login.html
                         Defaults to a slugified version of the html filename
                         (as a single-segment module, page "index").

Example:
    python mockups/scripts/build_mockup.py "raw/kerjasama-daftar/Daftar Kerjasama.html" kerjasama/daftar

To start a new version (v2, v3, ...): bump CURRENT_VERSION below, add a row
to the root README.md, and re-run the build for each page against the new
version - see "Menambah Versi Baru" in the root README.md.
"""
import json
import os
import re
import shutil
import sys
from collections import Counter
from pathlib import Path
from urllib.parse import urlparse

from bs4 import BeautifulSoup, Comment

ROOT = Path(__file__).resolve().parents[2]
MOCKUPS = ROOT / "mockups"
TOKENS_DIR = MOCKUPS / "tokens"

# The current design iteration - every page is written flat into this folder
# at the repo root (see module docstring). Bump this (and add a new root
# README.md row) to start a new version instead of overwriting v1.
CURRENT_VERSION = "v1"
VERSION_DIR = ROOT / CURRENT_VERSION
ROUTE_MAP_PATH = MOCKUPS / "route-map" / f"{CURRENT_VERSION}.json"

# "module/page" that doubles as this version's home page - the one page that
# maps to bare "index.html" instead of "<module>.html"/"<module>-<page>.html"
# (see output_stem()). Currently the kerjasama dashboard, since it's this
# app's actual landing screen (captured from /v2/kerjasama/dashboard).
HOME_PAGE_ID = "kerjasama/index"

# The pre-built QUANTUM release bundle vendored into every version's own
# assets/vendors/<name>/ folder, exactly like tracer-study - checked to be
# the newest pre-built CSS+JS bundle available across every local QUANTUM
# checkout (QUANTUM/quantum, QUANTUM/quantum-monorepo, QUANTUM/quantum-ai
# only have older releases; QUANTUM/quantum-monorepo would need a build step
# to produce anything newer, which isn't available offline here).
QUANTUM_VENDOR_NAME = "quantum-v2.2.1-202310260001"
QUANTUM_VENDOR_SRC = ROOT / "QUANTUM" / "pwa-laravel" / "public" / "vendors" / QUANTUM_VENDOR_NAME

# Separate from the versioned vendor bundle above: quantum-symbols font and
# header/sidebar pattern files referenced by a page's own inline <style>
# block (copied verbatim from the capture, present regardless of which
# stylesheet renders the rest of the page) under a hashed/versioned filename
# the browser capture never saved. These come from a newer QUANTUM source
# tree than QUANTUM_VENDOR_SRC, so they're kept in their own
# assets/vendors/local-assets/ folder rather than nested under the bundle's
# version name.
QUANTUM_V34 = ROOT / "QUANTUM" / "quantum-ai" / "source" / "quantum-v3.4"

# Assets production references by a hashed/versioned filename that the browser
# capture never saved (e.g. Vite build output). Matched by prefix+suffix so
# the hash doesn't matter, then copied from this *local, first-party* source
# instead of ever touching the network. Everything here must stay offline.
KNOWN_LOCAL_ASSETS = [
    ("quantum-symbols", ".woff2", QUANTUM_V34 / "quantum-symbols" / "font" / "fonts" / "quantum-symbols.woff2"),
    ("quantum-symbols", ".woff", QUANTUM_V34 / "quantum-symbols" / "font" / "fonts" / "quantum-symbols.woff"),
    ("sevima-header", ".webp", QUANTUM_V34 / "quantum-web" / "assets" / "patterns" / "sevima-header.webp"),
    ("sevima-sidebar", ".svg", QUANTUM_V34 / "quantum-web" / "assets" / "patterns" / "sevima-sidebar.svg"),
]

# External <script src> the capture saved under a hashed/generic filename -
# functional and fully self-contained (verified: no further imports), so
# they're restored under a clean local name instead of being dropped like
# the rest of the capture's scripts.
FUNCTIONAL_SCRIPTS = [
    ("chart.umd.js.download", "chart.js"),
    ("chartjs-plugin-datalabels.min.js.download", "chartjs-plugin-datalabels.min.js"),
    ("chart-settings.js.download", "chart-settings.js"),
]
# Inline <script> is only kept if its content matches one of these - avoids
# hand-picking index positions, which shift between captures.
FUNCTIONAL_INLINE_SCRIPT_SIGNATURES = ("Chart.register(ChartDataLabels)",)

# The real production JS bundle isn't reusable in a static capture (it's an
# ES module importing build chunks the browser never saved, and/or requires
# a live Livewire backend). Bootstrap 5's own CSS already defines every state
# class these components need (.show, .active, .fade, .modal-backdrop, ...) -
# confirmed present in the captured stylesheet - so a small vanilla
# re-implementation of Bootstrap's data-api toggle contracts reproduces
# identical visual behavior for every standard component the prototype might
# use (navbar toggler, filter panels, modals, tabs), not just one page's
# specific widgets. This file is mockup scaffolding only - the real project
# already ships full Bootstrap JS, don't copy this file into it.
INTERACTIONS_JS = """// Local Bootstrap-5-compatible interaction layer for this mockup.
// Covers every standard data-bs-* component so prototypes "just work" without
// needing the production JS bundle (which isn't reusable from a static
// capture). Mockup scaffolding only - do not copy into the real project,
// which already has the full Bootstrap JS bundle.
(function () {
    function targetOf(trigger) {
        var sel = trigger.getAttribute('data-bs-target') || trigger.getAttribute('href');
        if (!sel || sel === '#') return null;
        try { return document.querySelector(sel); } catch (e) { return null; }
    }

    // --- Dropdown ---------------------------------------------------------
    function closeDropdowns(except) {
        document.querySelectorAll('.dropdown-menu.show').forEach(function (menu) {
            if (menu !== except) menu.classList.remove('show');
        });
        document.querySelectorAll('[data-bs-toggle="dropdown"].show').forEach(function (toggle) {
            if (toggle.parentElement.querySelector('.dropdown-menu') !== except) {
                toggle.classList.remove('show');
                toggle.setAttribute('aria-expanded', 'false');
            }
        });
    }

    function handleDropdown(toggle, event) {
        event.preventDefault();
        var menu = toggle.parentElement.querySelector('.dropdown-menu');
        var willOpen = menu && !menu.classList.contains('show');
        closeDropdowns();
        if (menu && willOpen) {
            menu.classList.add('show');
            toggle.classList.add('show');
            toggle.setAttribute('aria-expanded', 'true');
        }
    }

    // --- Collapse (navbar toggler, filter panels, accordions) --------------
    function handleCollapse(trigger, event) {
        event.preventDefault();
        var target = targetOf(trigger);
        if (!target) return;
        var isShown = target.classList.toggle('show');
        trigger.classList.toggle('collapsed', !isShown);
        trigger.setAttribute('aria-expanded', String(isShown));
        // Accordions: siblings in the same accordion collapse when one opens.
        var accordion = target.closest('.accordion');
        if (accordion && isShown) {
            accordion.querySelectorAll('.accordion-collapse.show').forEach(function (other) {
                if (other !== target) {
                    other.classList.remove('show');
                    var otherTrigger = accordion.querySelector('[data-bs-target="#' + other.id + '"]');
                    if (otherTrigger) {
                        otherTrigger.classList.add('collapsed');
                        otherTrigger.setAttribute('aria-expanded', 'false');
                    }
                }
            });
        }
    }

    // --- Modal / Offcanvas (share the same show/hide/backdrop shape) -------
    function showOverlay(el, kind) {
        el.classList.add('show');
        el.style.display = kind === 'modal' ? 'block' : '';
        el.setAttribute('aria-modal', 'true');
        el.removeAttribute('aria-hidden');
        document.body.classList.add(kind === 'modal' ? 'modal-open' : 'offcanvas-backdrop-open');
        var backdrop = document.createElement('div');
        backdrop.className = (kind === 'modal' ? 'modal-backdrop' : 'offcanvas-backdrop') + ' fade show';
        backdrop.dataset.mockupBackdropFor = el.id;
        document.body.appendChild(backdrop);
    }

    function hideOverlay(el, kind) {
        el.classList.remove('show');
        if (kind === 'modal') el.style.display = 'none';
        el.setAttribute('aria-hidden', 'true');
        el.removeAttribute('aria-modal');
        document.body.classList.remove(kind === 'modal' ? 'modal-open' : 'offcanvas-backdrop-open');
        document.querySelectorAll('[data-mockup-backdrop-for="' + el.id + '"]').forEach(function (b) { b.remove(); });
    }

    function overlayKindOf(el) {
        return el.classList.contains('offcanvas') ? 'offcanvas' : 'modal';
    }

    // --- Tabs / pills --------------------------------------------------------
    function handleTab(trigger, event) {
        event.preventDefault();
        var pane = targetOf(trigger);
        var navGroup = trigger.closest('.nav, .list-group');
        if (navGroup) {
            navGroup.querySelectorAll('.active').forEach(function (a) { a.classList.remove('active'); });
        }
        trigger.classList.add('active');
        trigger.setAttribute('aria-selected', 'true');
        if (pane) {
            var paneGroup = pane.closest('.tab-content');
            if (paneGroup) {
                paneGroup.querySelectorAll('.tab-pane.show.active').forEach(function (p) {
                    p.classList.remove('show', 'active');
                });
            }
            pane.classList.add('show', 'active');
        }
    }

    // --- Destructive actions (delete/hapus) --------------------------------
    // No backend to actually delete anything, but reusing the real app's own
    // delete-confirmation modal (same title/wording/buttons, already in the
    // capture) - then actually removing the row(s) on confirm - looks and
    // behaves like production instead of a generic browser confirm() popup.
    var pendingDeleteRow = null;

    function handleConfirm(trigger, event) {
        event.preventDefault();
        var message = trigger.getAttribute('data-mockup-confirm');
        if (!window.confirm(message)) return;
        var row = trigger.closest('tr, .card, li.list-group-item, .list-group-item');
        if (row) row.remove();
    }

    function handleBulkDelete(trigger, event) {
        event.preventDefault();
        var hasChecked = !!document.querySelector('tbody input[type="checkbox"]:checked');
        var targetSel = trigger.getAttribute(
            hasChecked ? 'data-mockup-bulk-delete-confirm' : 'data-mockup-bulk-delete-empty'
        );
        var modal = targetSel && document.querySelector(targetSel);
        if (modal) showOverlay(modal, 'modal');
    }

    function handleDeleteConfirmClick(trigger, event) {
        event.preventDefault();
        var kind = trigger.getAttribute('data-mockup-delete-confirm');
        var modal = trigger.closest('.modal');
        if (modal) hideOverlay(modal, 'modal');
        if (kind === 'row' && pendingDeleteRow) {
            pendingDeleteRow.remove();
        } else if (kind === 'bulk') {
            document.querySelectorAll('tbody input[type="checkbox"]:checked').forEach(function (cb) {
                var row = cb.closest('tr');
                if (row) row.remove();
            });
        }
        pendingDeleteRow = null;
    }

    document.addEventListener('click', function (event) {
        // Remember which row asked for the shared row-delete modal, before
        // the generic data-bs-toggle="modal" handling below opens it.
        var rowTrigger = event.target.closest('[data-mockup-delete-row-trigger]');
        if (rowTrigger) pendingDeleteRow = rowTrigger.closest('tr');

        var bulkTrigger = event.target.closest('[data-mockup-bulk-delete]');
        if (bulkTrigger) return handleBulkDelete(bulkTrigger, event);

        var deleteConfirm = event.target.closest('[data-mockup-delete-confirm]');
        if (deleteConfirm) return handleDeleteConfirmClick(deleteConfirm, event);

        var confirmTrigger = event.target.closest('[data-mockup-confirm]');
        if (confirmTrigger) return handleConfirm(confirmTrigger, event);

        var toggle = event.target.closest('[data-bs-toggle]');
        var dismiss = event.target.closest('[data-bs-dismiss]');

        if (toggle) {
            var kind = toggle.getAttribute('data-bs-toggle');
            if (kind === 'dropdown') return handleDropdown(toggle, event);
            if (kind === 'collapse') return handleCollapse(toggle, event);
            if (kind === 'tab' || kind === 'pill') return handleTab(toggle, event);
            if (kind === 'modal' || kind === 'offcanvas') {
                event.preventDefault();
                var el = targetOf(toggle);
                if (el) showOverlay(el, kind);
                return;
            }
        }

        if (dismiss) {
            var what = dismiss.getAttribute('data-bs-dismiss');
            if (what === 'alert') {
                event.preventDefault();
                var alertEl = dismiss.closest('.alert');
                if (alertEl) alertEl.remove();
                return;
            }
            if (what === 'modal' || what === 'offcanvas') {
                event.preventDefault();
                var overlay = dismiss.closest('.modal, .offcanvas');
                if (overlay) hideOverlay(overlay, overlayKindOf(overlay));
                return;
            }
        }

        // Backdrop click closes the modal/offcanvas it belongs to.
        if (event.target.dataset && event.target.dataset.mockupBackdropFor) {
            var owned = document.getElementById(event.target.dataset.mockupBackdropFor);
            if (owned) hideOverlay(owned, overlayKindOf(owned));
            return;
        }

        if (!event.target.closest('.dropdown-menu')) closeDropdowns();
    });

    // Flash-message alerts triggered by a real create/update request can't
    // fire in a static mockup (there's no backend) - but if the capture
    // included one already rendered (e.g. captured right after a save), its
    // dismiss button above already works. See manifest.md for a note on this.
})();
"""

CSS_URL_RE = re.compile(r"url\(\s*(['\"]?)(?!data:)([^'\")]+)\1\s*\)")


def find_known_local_asset(basename):
    for prefix, suffix, path in KNOWN_LOCAL_ASSETS:
        if basename.startswith(prefix) and basename.endswith(suffix) and path.exists():
            return path
    return None


def localize_css_urls(css_text, out_dir):
    """Resolve every url() in a CSS blob to something local: a known
    first-party QUANTUM asset if we have one, otherwise `none` - never left
    pointing at an external domain."""
    stats = Counter()
    vendor_dir = out_dir / "assets" / "vendors" / "local-assets"

    def _sub(m):
        raw_url = m.group(2)
        basename = raw_url.split("#")[0].split("?")[0].split("/")[-1]
        local_src = find_known_local_asset(basename)
        if local_src:
            dest = vendor_dir / basename
            if not dest.exists():
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(local_src, dest)
            stats["local_assets_matched"] += 1
            return f"url({Path(os.path.relpath(dest, out_dir)).as_posix()})"
        if raw_url.startswith("http://") or raw_url.startswith("https://") or raw_url.startswith("/"):
            stats["external_urls_dropped"] += 1
            return "none"
        return m.group(0)  # same-directory relative ref - leave alone, harmless if missing

    return CSS_URL_RE.sub(_sub, css_text), stats


# Chrome/Edge stamp 'saved from url=(NNN)https://host/path' as the first HTML
# comment in a 'Webpage, Complete' capture - this is the only record of which
# real app route a given mockup corresponds to, which is what makes
# cross-page navigation (navbar, "Tambah", row actions -> the right mockup)
# possible instead of dead-ending every internal link at '#'.
CAPTURE_URL_RE = re.compile(r"saved from url=\(\d+\)(https?://[^\s\"'<>]+)")
ID_SEGMENT_RE = re.compile(
    r"^\d+$|^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
)


def extract_capture_path(raw_html_text):
    """Pull the path (no domain, no query string) this capture was saved
    from, e.g. '/v2/kerjasama/45'. None if the capture has no such comment
    (e.g. hand-built, or saved via 'Copy outerHTML' which drops it)."""
    m = CAPTURE_URL_RE.search(raw_html_text)
    if not m:
        return None
    return urlparse(m.group(1)).path or "/"


def path_pattern(path):
    """Normalize a path so different records of the same route (different
    ids) match: '/v2/kerjasama/45' and '/v2/kerjasama/78' both become
    '/v2/kerjasama/{id}'."""
    segments = [s for s in path.split("/")]
    return "/".join("{id}" if ID_SEGMENT_RE.match(s) else s for s in segments)


def load_route_map():
    if ROUTE_MAP_PATH.exists():
        return load_json(ROUTE_MAP_PATH)
    return {}


def save_route_map(route_map):
    ROUTE_MAP_PATH.parent.mkdir(parents=True, exist_ok=True)
    ROUTE_MAP_PATH.write_text(
        json.dumps(route_map, indent=2, ensure_ascii=False, sort_keys=True), encoding="utf-8")


def _pick_canonical(candidates, self_id=None):
    """Same route, several captures (e.g. a detail page captured plain, and
    again right after a create/edit shows a flash banner on that same URL).
    Preference order: (1) the page currently being linked FROM, if its own
    route matches - a nav tab/breadcrumb pointing at "itself" should stay on
    itself, not jump to a sibling capture of the same URL; (2) the
    plain/canonical capture, so "Detail" from a list doesn't land on a
    fleeting "berhasil diubah" state; (3) a *-success capture only as a last
    resort, if it's the only mockup that route has."""
    if not candidates:
        return None
    if self_id in candidates:
        return self_id
    preferred = [c for c in candidates if "success" not in c]
    return (preferred or candidates)[0]


def resolve_route(path, route_map, self_id=None):
    """Exact path match wins; otherwise fall back to pattern match (handles
    '/kerjasama/45' finding a mockup captured from '/kerjasama/78'). Returns
    the matching page_id ('module/page'), or None."""
    if not path:
        return None
    pattern = path_pattern(path)
    exact_matches, pattern_matches = [], []
    for pid, info in route_map.items():
        if info.get("path") == path:
            exact_matches.append(pid)
        elif info.get("pattern") == pattern:
            pattern_matches.append(pid)
    return (_pick_canonical(exact_matches, self_id)
            or _pick_canonical(pattern_matches, self_id))


NOISE_CLASS_PREFIXES = ("sf-dump", "sf-toolbar", "phpdebugbar", "plasmo-csui")
NOISE_CLASS_TOKENS = {"sf-js-enabled"}
NOISE_TAGS = ("plasmo-csui",)
# Framework-glue attributes with no meaning in a static mockup - Laravel
# Turbo/Turbolinks navigation hints, Livewire wiring, CSRF plumbing. Stripped
# so the markup a developer copies back into the real project isn't cluttered
# with attributes that only make sense wired to a live backend.
NOISE_ATTR_PREFIXES = ("data-turbo", "data-navigate-track")
NOISE_ATTR_NAMES = {"data-csrf", "data-update-uri", "data-turbolinks-eval"}
# Inline <style> blocks with no matching elements left after cleanup (debug
# toolbar CSS, browser-extension overlay CSS) - dropped by content signature.
NOISE_STYLE_SIGNATURES = ("phpdebugbar", "sf-dump", "plasmo", "give-freely", "gf-app")
# First hyphen-segment (or whole class, for bare words) of known Bootstrap-family
# utility/component classes. Covers responsive infixes like `pb-md-0`, `gap-lg-3`.
BOOTSTRAP_UTILITY_PREFIXES = {
    "d", "col", "row", "g", "gx", "gy", "text", "bg", "btn", "nav", "dropdown",
    "badge", "align", "justify", "gap", "rounded", "border", "shadow", "fs", "fw",
    "w", "h", "flex", "sticky", "container", "p", "pt", "pb", "ps", "pe", "px", "py",
    "m", "mt", "mb", "ms", "me", "mx", "my", "vr", "small", "link", "card", "modal",
    "breadcrumb", "fade", "active", "img", "object", "z", "opacity", "overflow",
    "position", "top", "start", "end", "bottom", "ratio", "order", "float",
    "clearfix", "visually", "list", "table", "form", "input", "collapse", "offcanvas",
    "tab", "toast", "spinner", "pagination", "progress", "tooltip", "popover",
    "navbar", "lh", "align-items", "justify-content",
}
HEX_COLOR_RE = re.compile(r"#[0-9a-fA-F]{3,8}\b")


def slugify(name):
    s = re.sub(r"[^a-zA-Z0-9]+", "-", name).strip("-").lower()
    return s or "page"


def parse_target(raw_path, arg=None):
    """'kerjasama/daftar' -> ('kerjasama', 'daftar'); 'dashboard' -> ('dashboard',
    'index'); no arg -> module from the raw filename, page 'index'."""
    parts = [p for p in (arg or raw_path.stem).replace("\\", "/").split("/") if p]
    if len(parts) == 1:
        return slugify(parts[0]), "index"
    return slugify(parts[0]), slugify("-".join(parts[1:]))


def page_id(module, page):
    return f"{module}/{page}"


def output_stem(module, page):
    """Flat filename (no extension) a given module/page target writes to
    inside VERSION_DIR - "kerjasama/daftar" -> "kerjasama-daftar" (module's
    sub-page), "kerjasama/index" -> "index" (this version's home page, see
    HOME_PAGE_ID), any other "<module>/index" -> "<module>" (that module's
    own main/list page, bare-named like tracer-study's "alumni.html")."""
    if page_id(module, page) == HOME_PAGE_ID:
        return "index"
    if page == "index":
        return module
    return f"{module}-{page}"


API_VERSION_SEGMENTS = {"v1", "v2", "v3", "api"}


def suggest_module(capture_path):
    """The real app groups pages by URL, not by what a human decides to call
    them - '/v2/kerjasama/dashboard' belongs to the *kerjasama* module even
    though the page itself is a "dashboard". Used only to sanity-check the
    module the build was actually asked to use (never overrides it), so a
    page doesn't accidentally end up isolated in its own module folder
    just because of what it happened to be named."""
    if not capture_path:
        return None
    segments = [s for s in capture_path.split("/") if s]
    while segments and segments[0].lower() in API_VERSION_SEGMENTS:
        segments = segments[1:]
    return slugify(segments[0]) if segments else None


def relative_link(target_module, target_page):
    """href from any page to another - every page lives flat in the same
    VERSION_DIR now, so this is just that target's own filename."""
    return f"{output_stem(target_module, target_page)}.html"


def load_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def find_capture_assets_dir(raw_html_path):
    """Browser 'Save Complete' saves a sibling '<name>_files' folder."""
    candidate = raw_html_path.parent / f"{raw_html_path.stem}_files"
    return candidate if candidate.exists() else None


# The real app already ships a "Hapus X? Data tidak dapat dikembalikan"
# confirmation modal in the markup - reuse THAT verbatim (title, wording,
# button labels, animation) instead of a generic browser confirm(), so the
# delete flow looks and feels identical to production.
DELETE_MODAL_TITLE_RE = re.compile(r"hapus", re.I)
DELETE_MODAL_BODY_RE = re.compile(r"yakin|dikembalikan", re.I)
BULK_MODAL_ID_HINTS = ("many", "checked", "bulk", "all")
NO_SELECTION_TITLE_RE = re.compile(r"pilih.*terlebih dahulu|centang.*terlebih dahulu", re.I)


def find_confirm_button(modal):
    """The footer button that actually performs the delete - i.e. not the
    Cancel/close one (those carry data-bs-dismiss)."""
    footer = modal.find(class_="modal-footer")
    if not footer:
        return None
    for btn in footer.find_all(["button", "a"]):
        if not btn.has_attr("data-bs-dismiss"):
            return btn
    return None


def classify_delete_modals(soup):
    """Find, among all modals already in the capture: the per-row delete
    confirmation, the bulk (checked-rows) delete confirmation, and the
    "you didn't select anything" warning - by title/body wording rather than
    hardcoded ids, so this works on any page using the same QUANTUM pattern,
    not just this one."""
    row_modal = bulk_modal = empty_modal = None
    for modal in soup.find_all("div"):
        classes = modal.get("class") or []
        if "modal" not in classes:
            continue
        title_el = modal.find(class_="modal-title")
        body_el = modal.find(class_="modal-body")
        title = title_el.get_text(strip=True).lower() if title_el else ""
        body = body_el.get_text(strip=True).lower() if body_el else ""
        modal_id = (modal.get("id") or "").lower()
        if DELETE_MODAL_TITLE_RE.search(title) and DELETE_MODAL_BODY_RE.search(body):
            if any(hint in modal_id for hint in BULK_MODAL_ID_HINTS) and "row" not in modal_id:
                bulk_modal = bulk_modal or modal
            else:
                row_modal = row_modal or modal
        elif NO_SELECTION_TITLE_RE.search(title):
            empty_modal = empty_modal or modal
    return row_modal, bulk_modal, empty_modal


def wire_delete_modals(soup):
    """Point every trash-icon trigger at the real delete-confirmation modal
    already in the capture (row-level or bulk), and tag that modal's actual
    "Hapus" button so mockup-interactions.js knows to remove the row(s) and
    close the modal when it's clicked. Falls back to a plain confirm() only
    for a trigger with no matching modal in the document at all."""
    stats = Counter()
    row_modal, bulk_modal, empty_modal = classify_delete_modals(soup)

    if row_modal is not None:
        btn = find_confirm_button(row_modal)
        if btn is not None:
            btn["data-mockup-delete-confirm"] = "row"
    if bulk_modal is not None:
        btn = find_confirm_button(bulk_modal)
        if btn is not None:
            btn["data-mockup-delete-confirm"] = "bulk"

    for icon in soup.find_all(class_=lambda c: c and "trash" in c):
        trigger = icon.find_parent(["a", "button"])
        if not trigger or trigger.has_attr("data-mockup-confirm") or trigger.has_attr("data-bs-toggle"):
            continue
        row = trigger.find_parent("tr")
        if row is not None and row_modal is not None:
            trigger["data-bs-toggle"] = "modal"
            trigger["data-bs-target"] = f"#{row_modal['id']}"
            trigger["data-mockup-delete-row-trigger"] = "1"
            stats["destructive_confirms_wired"] += 1
        elif row is None and (bulk_modal is not None or empty_modal is not None):
            trigger["data-mockup-bulk-delete"] = "1"
            if bulk_modal is not None:
                trigger["data-mockup-bulk-delete-confirm"] = f"#{bulk_modal['id']}"
            if empty_modal is not None:
                trigger["data-mockup-bulk-delete-empty"] = f"#{empty_modal['id']}"
            stats["destructive_confirms_wired"] += 1
        else:
            trigger["data-mockup-confirm"] = "Yakin ingin menghapus data ini? (mockup - tidak tersambung ke server)"
            stats["destructive_confirms_wired"] += 1

    return stats


def strip_noise(soup):
    stats = Counter()
    kept_inline_scripts = []

    for tag in soup.find_all("script", src=False):
        content = tag.string or tag.get_text() or ""
        if any(sig in content for sig in FUNCTIONAL_INLINE_SCRIPT_SIGNATURES):
            kept_inline_scripts.append(content)
            stats["functional_inline_scripts_kept"] += 1
        else:
            stats["script_tags_removed"] += 1
        tag.decompose()

    for tag in soup.find_all(NOISE_TAGS):
        tag.decompose()
        stats["extension_tags_removed"] += 1

    for tag in soup.find_all(True):
        if tag.attrs is None:
            continue  # already removed as a child of a decomposed ancestor
        classes = tag.get("class") or []
        tag_id = tag.get("id") or ""
        if any(c.startswith(NOISE_CLASS_PREFIXES) for c in classes) or tag_id.startswith(NOISE_CLASS_PREFIXES):
            tag.decompose()
            stats["debug_toolbar_blocks_removed"] += 1

    for tag in soup.find_all(True):
        if tag.attrs is None:
            continue
        # Livewire 3's confirm-before-destructive-action API - the attribute
        # value IS the confirmation message. Capture it before stripping so a
        # delete/destroy button still asks before "deleting" (removing the
        # row locally) instead of silently doing nothing.
        if tag.has_attr("wire:confirm") and not tag.has_attr("data-mockup-confirm"):
            tag["data-mockup-confirm"] = tag["wire:confirm"]
            stats["destructive_confirms_wired"] += 1
        wire_attrs = [a for a in tag.attrs if a.startswith("wire:") or a in ("x-data", "x-init")]
        for a in wire_attrs:
            del tag[a]
            stats["livewire_alpine_attrs_removed"] += 1
        noise_attrs = [a for a in tag.attrs
                       if a.startswith(NOISE_ATTR_PREFIXES) or a in NOISE_ATTR_NAMES]
        for a in noise_attrs:
            del tag[a]
            stats["framework_glue_attrs_removed"] += 1

    stats.update(wire_delete_modals(soup))

    for tag in soup.find_all("canvas"):
        if tag.has_attr("style"):
            del tag["style"]  # Chart.js recomputes this on init - stale capture-time values otherwise
            stats["chart_canvas_styles_cleared"] += 1

    for tag in soup.find_all("link", rel=lambda r: r in ("preload", "modulepreload", "dns-prefetch", "preconnect")):
        tag.decompose()
        stats["preload_links_removed"] += 1

    for tag in soup.find_all("style"):
        text = (tag.string or "").lower()
        if any(sig in text for sig in NOISE_STYLE_SIGNATURES):
            tag.decompose()
            stats["noise_style_blocks_removed"] += 1

    if soup.title and soup.title.string:
        soup.title.string.replace_with(soup.title.get_text(strip=True))

    for comment in soup.find_all(string=lambda t: isinstance(t, Comment)):
        comment.extract()
        stats["comments_removed"] += 1

    return stats, kept_inline_scripts


def vendor_quantum_css(out_dir):
    """Copy the vendored QUANTUM release bundle (QUANTUM_VENDOR_SRC) into
    out_dir/assets/vendors/<QUANTUM_VENDOR_NAME>/, preserving its own
    internal folder layout (assets/release/*.css, assets/fonts/*, etc. -
    same relative paths tracer-study uses) and rewriting the CSS's url()s to
    match. This is the PRIMARY rendering stylesheet for every page (matching
    tracer-study), not a fallback. Regenerated on first call, then reused -
    shared by every page in this version, copied once. The bundle's .js is
    copied alongside for structural parity with tracer-study but not wired
    into a <script> tag: it predates the ES-module production bundle and
    could plausibly be loaded directly, but mixing it with
    `mockup-interactions.js` risks double-handling the same data-bs-*
    events, which wasn't part of this migration's scope.
    """
    stats = Counter()
    vendor_root = out_dir / "assets" / "vendors" / QUANTUM_VENDOR_NAME
    release_src_dir = QUANTUM_VENDOR_SRC / "assets" / "release"
    src_css = next(iter(sorted(release_src_dir.glob("qn-*.css"))), None) if release_src_dir.exists() else None
    if src_css is None:
        return None, stats

    out_css = vendor_root / "assets" / "release" / src_css.name
    href = Path(os.path.relpath(out_css, out_dir)).as_posix()
    if out_css.exists():
        return href, stats  # already vendored for this version

    for js_src in release_src_dir.glob("qn-*.js"):
        js_dest = vendor_root / "assets" / "release" / js_src.name
        js_dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(js_src, js_dest)

    text = src_css.read_text(encoding="utf-8", errors="ignore")
    replacements = {}

    for m in CSS_URL_RE.finditer(text):
        full_match, raw_url = m.group(0), m.group(2)
        if full_match in replacements:
            continue
        clean_url = raw_url.split("#")[0].split("?")[0]
        if clean_url.startswith("/"):
            src = QUANTUM_VENDOR_SRC / clean_url.lstrip("/")
            mirror_rel = Path(clean_url.lstrip("/"))
        else:
            src = (src_css.parent / clean_url).resolve()
            try:
                mirror_rel = src.relative_to(QUANTUM_VENDOR_SRC.resolve())
            except ValueError:
                mirror_rel = Path("external") / src.name
        if not src.exists():
            stats["assets_not_found"] += 1
            continue
        dest = vendor_root / mirror_rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
        stats["assets_copied"] += 1
        replacements[full_match] = f"url({Path(os.path.relpath(dest, out_dir)).as_posix()})"

    for old, new in replacements.items():
        text = text.replace(old, new)

    out_css.parent.mkdir(parents=True, exist_ok=True)
    out_css.write_text(text, encoding="utf-8")
    return href, stats


def vendor_captured_stylesheets(soup, out_dir, capture_assets_dir):
    """The browser capture's own CSS is the ground truth for how the page
    actually looked in production - it's the PRIMARY rendering CSS
    (rewrite_head_assets links these hrefs), preferred over the vendored
    QUANTUM bundle whenever a capture is available. This was tried the other
    way round once (vendor bundle as primary, matching tracer-study's own
    choice) and reverted: `QUANTUM_VENDOR_SRC` (quantum-v2.2.1-202310260001,
    Oct 2023) turned out to share almost no class-level CSS with this app's
    actual production markup (~9% of classes on a real page had any matching
    selector, vs ~94% for the captured CSS) - a different, unrelated
    generation of the design system, not just "a bit stale". tracer-study's
    own bundle matches because its mockups were authored directly against
    that same 2023 era; this app's captures are current production, so
    captured CSS is what's actually reliable here. Drop the original <link
    rel=stylesheet> tags and copy any that exist in the capture's asset
    folder into out_dir/assets/captured/ (shared by every page in this
    version - skipped once a filename's already vendored, the normal case
    since it's the same app CSS bundle for every page), returning the new
    hrefs in original order (dedup by filename)."""
    stats = Counter()
    seen, ordered_filenames = set(), []
    for tag in soup.find_all("link", rel="stylesheet"):
        fname = tag.get("href", "").split("/")[-1]
        if fname and fname not in seen:
            seen.add(fname)
            ordered_filenames.append(fname)
        tag.decompose()
        stats["captured_stylesheets_dropped"] += 1

    hrefs = []
    if capture_assets_dir is not None:
        dest_dir = out_dir / "assets" / "captured"
        for fname in ordered_filenames:
            src = capture_assets_dir / fname
            if not src.exists():
                continue
            # Some captures save a stylesheet at an extensionless URL (e.g. a
            # dynamic route) - force a .css name so MIME sniffing still
            # treats it as a stylesheet.
            out_name = fname if fname.lower().endswith(".css") else f"{fname}.css"
            dest = dest_dir / out_name
            href = f"assets/captured/{out_name}"
            if dest.exists():
                hrefs.append(href)  # already vendored by an earlier page in this version
                continue
            dest.parent.mkdir(parents=True, exist_ok=True)
            text = src.read_text(encoding="utf-8", errors="ignore")
            text, url_stats = localize_css_urls(text, out_dir)
            stats.update(url_stats)
            dest.write_text(text, encoding="utf-8")
            hrefs.append(href)
            stats["captured_stylesheets_vendored"] += 1

    return hrefs, stats


def ensure_head(soup):
    head = soup.head
    if head is None:
        # Some captures have no explicit <head> (lxml won't synthesize one)
        # - create one and place it first, browsers tolerate this.
        head = soup.new_tag("head")
        if soup.html:
            soup.html.insert(0, head)
        else:
            soup.insert(0, head)
    # Every relative path on the page (assets, sibling-page links) is plain
    # (e.g. "assets/css/main.css", "kerjasama-daftar.html") and resolves
    # against this <base>, exactly like tracer-study's "<base href=/vX/>"
    # convention - no per-path "../" or leading "/" needed, and it stays
    # correct whether previewed locally or deployed to /{CURRENT_VERSION}/.
    if head.find("base") is None:
        head.insert(0, soup.new_tag("base", href=f"/{CURRENT_VERSION}/"))
    return head


def restore_functional_scripts(soup, out_dir, capture_assets_dir, kept_inline_scripts):
    """Drop every captured <script src> except the Chart.js stack (verified
    self-contained, no further imports) - copy those locally under a clean
    name into out_dir/assets (shared across every page in this version,
    copied once), keep the tag, and re-append the chart-init inline script
    (with its real data, always page-specific) plus our own interaction
    layer at the end of body."""
    stats = Counter()
    js_dir = out_dir / "assets"

    kept_names = []
    for tag in soup.find_all("script", src=True):
        fname = tag["src"].split("/")[-1]
        match = next((clean for raw, clean in FUNCTIONAL_SCRIPTS if raw == fname), None)
        if match and capture_assets_dir is not None and (capture_assets_dir / fname).exists():
            dest = js_dir / match
            if not dest.exists():
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(capture_assets_dir / fname, dest)
            if match not in kept_names:
                kept_names.append(match)
                stats["functional_scripts_vendored"] += 1
        tag.decompose()
        stats["captured_scripts_dropped"] += 1

    body = soup.body
    if body is None:
        return stats
    for name in kept_names:
        body.append(soup.new_tag("script", src=f"assets/{name}"))
    for content in kept_inline_scripts:
        tag = soup.new_tag("script")
        tag.string = content
        body.append(tag)

    interactions_path = js_dir / "mockup-interactions.js"
    if not interactions_path.exists():
        interactions_path.parent.mkdir(parents=True, exist_ok=True)
        interactions_path.write_text(INTERACTIONS_JS, encoding="utf-8")
    body.append(soup.new_tag("script", src="assets/mockup-interactions.js"))
    stats["functional_scripts_vendored"] += 1 if kept_inline_scripts else 0

    return stats


def localize_inline_styles(soup, out_dir):
    """Same treatment as vendored CSS files, but for <style> blocks left
    inline in <head> (e.g. the .qn-header-pattern/.qn-sidebar background
    images) - resolve to a local QUANTUM asset or drop to `none`."""
    stats = Counter()
    for tag in soup.find_all("style"):
        text = tag.string or tag.get_text() or ""
        if "url(" not in text:
            continue
        new_text, url_stats = localize_css_urls(text, out_dir)
        stats.update(url_stats)
        if new_text != text:
            tag.string = new_text
    return stats


def resolve_internal_links(soup, module, page, route_map):
    """Every <a href>/<form action> pointing at an external http(s) origin
    (navbar tabs, "Tambah"/Edit/Detail buttons, logout, etc.) either becomes
    a real link to a sibling mockup (if one's been built for that route) or
    gets neutralized to '#' with the original path kept on
    data-mockup-unresolved so relink_existing_mockups() can wire it up the
    moment a matching mockup does get built - that's what makes this dynamic
    instead of a one-shot dead end."""
    stats = Counter()
    pending_paths = set()
    self_id = page_id(module, page)

    def handle(tag, attr):
        url = tag[attr]
        if not (url.startswith("http://") or url.startswith("https://")):
            return
        path = urlparse(url).path or "/"
        target = resolve_route(path, route_map, self_id=self_id)
        if target:
            target_module, target_page = target.split("/", 1)
            tag[attr] = relative_link(target_module, target_page)
            stats["internal_links_resolved"] += 1
        else:
            tag[attr] = "#"
            tag["data-mockup-unresolved"] = path
            stats["internal_links_pending"] += 1
            pending_paths.add(path)

    for tag in soup.find_all("a", href=True):
        handle(tag, "href")
    for tag in soup.find_all("form", action=True):
        handle(tag, "action")
    return stats, sorted(pending_paths)


def relink_existing_mockups(route_map, just_built_id):
    """Run after every build: sweep all OTHER previously-generated mockups
    (flat *.html files in VERSION_DIR) for links that couldn't be resolved at
    the time (data-mockup-unresolved) and re-check them against the
    now-current route map. This is what makes the whole set self-healing as
    new pages get added - build the "detail" page today and every earlier
    mockup's dead "Detail" button starts working without re-running anything
    for those pages. Each generated page carries its own "module/page" id in
    a `data-mockup-page-id` attribute on <html> (see main()), so this can
    identify itself without needing a per-module folder to read the name from."""
    stats = Counter()
    if not VERSION_DIR.exists():
        return stats

    for html_path in sorted(VERSION_DIR.glob("*.html")):
        html = html_path.read_text(encoding="utf-8", errors="ignore")
        if "data-mockup-unresolved" not in html:
            continue

        soup = BeautifulSoup(html, "lxml")
        self_id = soup.html.get("data-mockup-page-id") if soup.html else None
        if self_id == just_built_id:
            continue
        changed = False
        for tag in soup.find_all(attrs={"data-mockup-unresolved": True}):
            path = tag["data-mockup-unresolved"]
            target = resolve_route(path, route_map, self_id=self_id)
            if not target:
                continue
            target_module, target_page = target.split("/", 1)
            attr = "href" if tag.has_attr("href") else "action"
            tag[attr] = relative_link(target_module, target_page)
            del tag["data-mockup-unresolved"]
            changed = True
            stats["links_relinked"] += 1

        if changed:
            html_path.write_text(str(soup), encoding="utf-8")
            stats["pages_updated"] += 1

    return stats


def rewrite_head_assets(soup, out_dir, capture_assets_dir):
    stats = Counter()

    captured_hrefs, captured_stats = vendor_captured_stylesheets(soup, out_dir, capture_assets_dir)
    stats.update(captured_stats)

    head = ensure_head(soup)
    if captured_hrefs:
        # Ground-truth CSS from the real page - use it as-is, don't also mix
        # in the vendor bundle to avoid cascade conflicts (see
        # vendor_captured_stylesheets' docstring for why this is primary).
        for href in captured_hrefs:
            head.append(soup.new_tag("link", rel="stylesheet", href=href))
        stats["render_css_source"] = f"captured ({len(captured_hrefs)} file(s))"
    else:
        # No capture available (e.g. a mockup built from scratch) - fall
        # back to the vendored QUANTUM bundle, same folder convention as
        # tracer-study (assets/vendors/<name>/...), best effort only.
        vendored_href, vendor_stats = vendor_quantum_css(out_dir)
        stats.update(vendor_stats)
        if vendored_href:
            head.append(soup.new_tag("link", rel="stylesheet", href=vendored_href))
            stats["render_css_source"] = (
                f"QUANTUM vendor fallback ({vendored_href}) - Oct-2023 release, "
                f"no capture to verify against, may not match this app's current classes at all"
            )

    # Optional hand-authored override CSS for this version, layered on top -
    # same role as tracer-study's assets/css/main.css. Only linked if it's
    # actually been created (starts out absent; add it if/when a visual gap
    # needs patching).
    overrides_path = VERSION_DIR / "assets" / "css" / "main.css"
    if overrides_path.exists():
        head.append(soup.new_tag("link", rel="stylesheet", href="assets/css/main.css"))

    if capture_assets_dir is not None:
        rel_assets = Path(
            os.path.relpath(capture_assets_dir, out_dir)
        ).as_posix()
        for tag in soup.find_all(["img"], src=True):
            fname = tag["src"].split("/")[-1]
            if (capture_assets_dir / fname).exists():
                tag["src"] = f"{rel_assets}/{fname}"
                stats["images_repointed_to_capture"] += 1

        # Favicon is almost never saved by "Save Complete" (it's fetched by
        # the browser chrome, not the page) - fall back to the capture's own
        # logo rather than leave it pointing at the live/testing domain.
        fallback_logo = next(
            (f for f in ("logo-sevimaplatform-small.png", "logo-sevima-platform.png")
             if (capture_assets_dir / f).exists()),
            None,
        )
        for tag in soup.find_all("link", rel="icon"):
            fname = tag.get("href", "").split("/")[-1]
            if fname and (capture_assets_dir / fname).exists():
                tag["href"] = f"{rel_assets}/{fname}"
            elif fallback_logo:
                tag["href"] = f"{rel_assets}/{fallback_logo}"
                stats["favicon_replaced_with_local_logo"] += 1

    return stats


INTERACTION_LABELS = {
    "dropdown": "Dropdowns (navbar menus, filter pickers, etc.)",
    "collapse": "Collapse panels (navbar toggler, accordions, filter drawers)",
    "modal": "Modals",
    "offcanvas": "Offcanvas panels",
    "tab": "Tabs", "pill": "Pills",
    "destructive-confirm": "Delete/hapus buttons (real confirmation modal from the capture, then row removed)",
}


def detect_interactions(soup):
    """What data-bs-* components does this page actually use? Drives the
    manifest's Interactions section so it's obvious what got wired up versus
    what simply isn't present on this particular page."""
    counts = Counter()
    for tag in soup.find_all(attrs={"data-bs-toggle": True}):
        counts[tag["data-bs-toggle"]] += 1
    alert_dismiss = len(soup.find_all(attrs={"data-bs-dismiss": "alert"}))
    if alert_dismiss:
        counts["alert-dismiss"] = alert_dismiss
    destructive = (
        len(soup.find_all(attrs={"data-mockup-confirm": True}))
        + len(soup.find_all(attrs={"data-mockup-delete-row-trigger": True}))
        + len(soup.find_all(attrs={"data-mockup-bulk-delete": True}))
    )
    if destructive:
        counts["destructive-confirm"] = destructive
    return counts


def classify_classes(soup, known_classes):
    counter = Counter()
    for tag in soup.find_all(True):
        if tag.attrs is None:
            continue
        for c in tag.get("class") or []:
            counter[c] += 1

    matched, sym_icons, bootstrap_utility, qn_drift, other = [], [], [], [], []
    for cls, count in counter.items():
        if cls in NOISE_CLASS_TOKENS:
            continue
        prefix = cls.split("-")[0]
        if cls in known_classes:
            matched.append((cls, count))
        elif cls == "sym" or cls.startswith("sym-"):
            sym_icons.append((cls, count))
        elif cls.startswith("qn-") or cls.startswith("qn_"):
            qn_drift.append((cls, count))
        elif prefix in BOOTSTRAP_UTILITY_PREFIXES:
            bootstrap_utility.append((cls, count))
        else:
            other.append((cls, count))

    for bucket in (matched, sym_icons, bootstrap_utility, qn_drift, other):
        bucket.sort(key=lambda x: (-x[1], x[0]))

    return {
        "matched_quantum": matched,
        "sym_icons": sym_icons,
        "bootstrap_utility": bootstrap_utility,
        "qn_drift": qn_drift,
        "other_unclassified": other,
    }


def find_colors(soup, reverse_lookup):
    mapped, unmapped = [], []
    seen = set()
    texts = [tag["style"] for tag in soup.find_all(style=True)]
    texts += [t.string or "" for t in soup.find_all("style")]
    for text in texts:
        for hexval in HEX_COLOR_RE.findall(text or ""):
            key = hexval.lower()
            if key in seen:
                continue
            seen.add(key)
            token = reverse_lookup.get(key)
            (mapped if token else unmapped).append((hexval, token))
    return mapped, unmapped


def render_manifest(slug, raw_path, out_html, cleanup_stats, head_stats, classes, colors, interactions,
                     pending_paths, relink_stats):
    mapped_colors, unmapped_colors = colors
    lines = []
    lines.append(f"# Mockup sync report - {slug}")
    lines.append("")
    if head_stats.get("module_warning"):
        lines.append(f"> ⚠️ **{head_stats['module_warning']}**")
        lines.append("")
    lines.append(f"- Source capture: `{raw_path.relative_to(ROOT).as_posix()}`")
    lines.append(f"- Generated mockup: `{out_html.relative_to(ROOT).as_posix()}`")
    lines.append(f"- Rendering CSS source: **{head_stats.get('render_css_source', 'NONE FOUND')}**")
    if "captured" in head_stats.get("render_css_source", ""):
        lines.append("  (this page's own captured stylesheet was used, so visuals should match production exactly)")
    elif head_stats.get("assets_copied") is not None:
        lines.append(f"  ({head_stats.get('assets_copied', 0)} fonts/icons copied from the vendor bundle, "
                      f"{head_stats.get('assets_not_found', 0)} referenced but not found - this bundle is a Oct-2023 "
                      f"release that shares very little class-level CSS with current production, so expect it to "
                      f"look substantially unstyled, not just \"slightly off\" - capture this page properly (Save "
                      f"Complete) instead of relying on this fallback if at all possible)")
    lines.append(f"- Everything is local now - {head_stats.get('local_assets_matched', 0)} font/pattern url()s "
                  f"resolved to first-party QUANTUM files (`quantum-symbols`, header/sidebar patterns), "
                  f"{head_stats.get('external_urls_dropped', 0)} unresolvable external url()s dropped to `none`.")
    lines.append("")

    lines.append("## Internal navigation")
    lines.append("")
    lines.append(f"- Links pointing to other app pages that already have a mockup built: "
                  f"**{head_stats.get('internal_links_resolved', 0)}** - rewritten to open that mockup directly "
                  f"(navbar tabs, \"Tambah\"/Edit/Detail buttons, etc. actually navigate, same as production).")
    if pending_paths:
        lines.append(f"- Links with no matching mockup yet: **{head_stats.get('internal_links_pending', 0)}** - "
                      f"left as `#` for now. Capture one of these pages next and re-run the build (any slug) to "
                      f"wire them up automatically, on this page AND every other mockup that links to it:")
        lines.append("")
        for path in pending_paths:
            lines.append(f"  - `{path}`")
    else:
        lines.append("- No pending links - every internal link on this page already has a matching mockup.")
    if relink_stats.get("pages_updated"):
        lines.append("")
        lines.append(f"- Building this page also fixed **{relink_stats['links_relinked']}** previously-dead link(s) "
                      f"across **{relink_stats['pages_updated']}** earlier mockup(s) that were waiting for this "
                      f"route to exist.")
    lines.append("")

    lines.append("## Interactions")
    lines.append("")
    if interactions:
        lines.append("Detected on this page and wired up via `mockup-interactions.js` "
                      "(a small local Bootstrap-5-compatible re-implementation - the real production JS bundle "
                      "isn't reusable from a static capture, but the CSS state classes it drives are the same "
                      "ones already in the captured stylesheet, so behavior matches production):")
        lines.append("")
        for kind, count in sorted(interactions.items()):
            label = INTERACTION_LABELS.get(kind, kind)
            lines.append(f"- {label}: **{count}** trigger(s)")
    else:
        lines.append("No `data-bs-toggle`/`data-bs-dismiss` components detected on this page.")
    lines.append("")
    lines.append(f"Charts: {head_stats.get('functional_scripts_vendored', 0)} functional script(s) vendored "
                  f"locally (Chart.js + datalabels plugin + chart-settings) and the real inline chart-init "
                  f"script (with its actual data) was preserved - charts render for real, not a static image.")
    lines.append("")
    lines.append("**Create/update flash alerts**: a `.alert` that's already in the captured DOM will display and "
                  "dismiss correctly (see Interactions above). But an alert that only appears *after* submitting a "
                  "real create/update form can't be triggered here - there's no backend. If pixel-perfect "
                  "before/after states matter, capture the page again right after triggering that alert in the "
                  "real app, and re-run this script.")
    lines.append("")

    lines.append("## Cleanup")
    lines.append("")
    for key, label in [
        ("script_tags_removed", "`<script>` tags removed"),
        ("extension_tags_removed", "Browser-extension injected tags removed"),
        ("debug_toolbar_blocks_removed", "Debug toolbar / var-dump blocks removed"),
        ("livewire_alpine_attrs_removed", "Livewire/Alpine attributes stripped"),
        ("framework_glue_attrs_removed", "Turbo/CSRF/Livewire-wiring attributes stripped (dead weight for slicing)"),
        ("chart_canvas_styles_cleared", "Stale Chart.js-computed `style` cleared off `<canvas>` (recomputed on load)"),
        ("preload_links_removed", "Preload/prefetch links removed"),
        ("noise_style_blocks_removed", "Dead/extension `<style>` blocks removed"),
        ("comments_removed", "HTML comments stripped"),
    ]:
        lines.append(f"- {label}: {cleanup_stats.get(key, 0)}")
    lines.append(f"- Captured `<link rel=stylesheet>` dropped (replaced by the QUANTUM vendor bundle above): "
                  f"{head_stats.get('captured_stylesheets_dropped', 0)}")
    lines.append(f"- Captured `<script src>` dropped: {head_stats.get('captured_scripts_dropped', 0)} "
                  f"({head_stats.get('functional_scripts_vendored', 0)} of those kept - see Charts/Dropdowns above)")
    lines.append(f"- Images re-pointed to the local capture's asset folder: "
                  f"{head_stats.get('images_repointed_to_capture', 0)}")
    if head_stats.get("favicon_replaced_with_local_logo"):
        lines.append("- Favicon swapped for the capture's own logo (browsers don't save the real favicon file)")
    lines.append("")

    lines.append("## Classes found in this page vs. the local QUANTUM copy")
    lines.append("")
    lines.append(f"- Matched known QUANTUM classes: **{len(classes['matched_quantum'])}**")
    lines.append(f"- `sym-*` icon classes referenced: **{len(classes['sym_icons'])}**")
    lines.append(f"- Bootstrap-style utility classes: **{len(classes['bootstrap_utility'])}**")
    lines.append(f"- `qn-*` classes NOT found in local QUANTUM copy (possible drift): "
                  f"**{len(classes['qn_drift'])}**")
    lines.append(f"- Other/unclassified (likely app-specific, one-off): **{len(classes['other_unclassified'])}**")
    lines.append("")

    if classes["qn_drift"]:
        lines.append("### ⚠️ Possible design-system drift")
        lines.append("")
        lines.append("These look like QUANTUM component classes (`qn-` prefix) but weren't found in "
                      "any local QUANTUM checkout (`QUANTUM/quantum`, `QUANTUM/quantum-monorepo`, or "
                      "`QUANTUM/quantum-ai/source/quantum-v3.4`). Either every local copy is behind the "
                      "live app, or these were built ad-hoc and should be proposed back to QUANTUM as a "
                      "`[Suggestion]` issue (see `QUANTUM/quantum/README.md` - use "
                      "`/label ~\"suggestion\" ~\"component\"`).")
        lines.append("")
        for cls, count in classes["qn_drift"]:
            lines.append(f"- `{cls}` ({count}x)")
        lines.append("")

    if classes["sym_icons"]:
        lines.append("### Icon classes used (`sym-*`)")
        lines.append("")
        for cls, count in classes["sym_icons"]:
            lines.append(f"- `{cls}` ({count}x)")
        lines.append("")

    if classes["other_unclassified"]:
        lines.append("### Other / app-specific classes (review manually)")
        lines.append("")
        for cls, count in classes["other_unclassified"][:40]:
            lines.append(f"- `{cls}` ({count}x)")
        if len(classes["other_unclassified"]) > 40:
            lines.append(f"- ... and {len(classes['other_unclassified']) - 40} more")
        lines.append("")

    lines.append("## Colors")
    lines.append("")
    if mapped_colors:
        lines.append("Raw hex values that already have a matching QUANTUM token - replace with "
                      "`var(--token-name)` instead of the hardcoded hex:")
        lines.append("")
        for hexval, token in mapped_colors:
            lines.append(f"- `{hexval}` -> `var({token})`")
        lines.append("")
    if unmapped_colors:
        lines.append("Raw hex values with **no** matching QUANTUM token (review with the design team "
                      "before reusing):")
        lines.append("")
        for hexval, _ in unmapped_colors:
            lines.append(f"- `{hexval}`")
        lines.append("")
    if not mapped_colors and not unmapped_colors:
        lines.append("No hardcoded hex colors found in inline styles - good, this page relies on "
                      "QUANTUM classes/tokens only.")
        lines.append("")

    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    raw_arg = Path(sys.argv[1])
    raw_path = raw_arg if raw_arg.is_absolute() else (MOCKUPS / "raw" / raw_arg)
    if not raw_path.exists():
        # allow passing just a filename that lives directly under mockups/raw/**
        matches = list((MOCKUPS / "raw").rglob(raw_arg.name))
        if len(matches) == 1:
            raw_path = matches[0]
        else:
            print(f"Could not resolve raw html file: {sys.argv[1]}")
            sys.exit(1)

    module, page = parse_target(raw_path, sys.argv[2] if len(sys.argv) > 2 else None)
    pid = page_id(module, page)
    out_dir = VERSION_DIR
    out_dir.mkdir(parents=True, exist_ok=True)
    stem = output_stem(module, page)
    out_html = out_dir / f"{stem}.html"
    out_manifest = out_dir / f"{stem}.manifest.md"

    tokens_data = load_json(TOKENS_DIR / "design-tokens.json")
    classes_data = load_json(TOKENS_DIR / "component-classes.json")
    known_classes = set(classes_data["classes"].keys())
    reverse_lookup = tokens_data["reverse_color_lookup"]

    html = raw_path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(html, "lxml")

    route_map = load_route_map()
    capture_path = extract_capture_path(html)
    if capture_path:
        route_map[pid] = {"module": module, "page": page, "path": capture_path,
                           "pattern": path_pattern(capture_path)}
        save_route_map(route_map)
    suggested_module = suggest_module(capture_path)
    module_mismatch = bool(suggested_module and suggested_module != module)
    module_warning = None
    if module_mismatch:
        module_warning = (
            f"Captured URL `{capture_path}` looks like it belongs to module **{suggested_module}**, "
            f"but this page was built as `{module}/{page}`. Rebuild this one as "
            f"`{suggested_module}/{page}` so its filename groups with that module's other pages "
            f"(`{suggested_module}-{page}.html`) instead of a mismatched name."
        )
        print(f"WARNING: {module_warning}")

    cleanup_stats, kept_inline_scripts = strip_noise(soup)
    capture_assets_dir = find_capture_assets_dir(raw_path)
    head_stats = rewrite_head_assets(soup, out_dir, capture_assets_dir)
    head_stats.update(restore_functional_scripts(soup, out_dir, capture_assets_dir, kept_inline_scripts))
    head_stats.update(localize_inline_styles(soup, out_dir))
    link_stats, pending_paths = resolve_internal_links(soup, module, page, route_map)
    head_stats.update(link_stats)
    if module_warning:
        head_stats["module_warning"] = module_warning
    classes = classify_classes(soup, known_classes)
    colors = find_colors(soup, reverse_lookup)
    interactions = detect_interactions(soup)

    if soup.html is not None:
        # Lets relink_existing_mockups() identify a flat *.html file's own
        # module/page without needing a per-module folder to read it from.
        soup.html["data-mockup-page-id"] = pid

    out_html.write_text(str(soup), encoding="utf-8")
    relink_stats = relink_existing_mockups(route_map, just_built_id=pid)
    out_manifest.write_text(
        render_manifest(pid, raw_path, out_html, cleanup_stats, head_stats, classes, colors, interactions,
                         pending_paths, relink_stats),
        encoding="utf-8",
    )

    print(f"Mockup written to {out_html.relative_to(ROOT)}")
    print(f"Manifest written to {out_manifest.relative_to(ROOT)}")
    print(f"Quantum classes matched: {len(classes['matched_quantum'])}, "
          f"drift candidates: {len(classes['qn_drift'])}, "
          f"unclassified: {len(classes['other_unclassified'])}")
    print(f"Internal links resolved: {link_stats.get('internal_links_resolved', 0)}, "
          f"pending: {link_stats.get('internal_links_pending', 0)}, "
          f"older mockups relinked: {relink_stats.get('links_relinked', 0)}")
    if not capture_path:
        print("Note: this capture has no 'saved from url=' comment (probably made via "
              "Copy outerHTML, not Save Complete) - internal navigation can't be wired for it.")


if __name__ == "__main__":
    main()