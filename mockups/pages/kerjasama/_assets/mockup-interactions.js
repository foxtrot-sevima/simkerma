// Local Bootstrap-5-compatible interaction layer for this mockup.
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

    // --- Tooltip (QUANTUM/Bootstrap tooltip component, no Popper needed for
    // a simple fixed-position trigger) --------------------------------------
    // Real Bootstrap tooltips are opt-in JS (`new bootstrap.Tooltip(el)`), which
    // this static capture doesn't ship - so this reimplements just enough:
    // read `title`, move it to `data-bs-original-title` (suppressing the native
    // browser tooltip, same as upstream), and render the same
    // `.tooltip.bs-tooltip-<placement>` / `.tooltip-arrow` / `.tooltip-inner`
    // markup Bootstrap's CSS already styles.
    var activeTooltip = null;

    function tooltipTextOf(trigger) {
        var text = trigger.getAttribute('data-bs-original-title');
        if (text === null) {
            text = trigger.getAttribute('title') || trigger.getAttribute('data-bs-title') || '';
            trigger.setAttribute('data-bs-original-title', text);
            trigger.removeAttribute('title');
        }
        return text;
    }

    function hideTooltip() {
        if (activeTooltip) {
            activeTooltip.remove();
            activeTooltip = null;
        }
    }

    function showTooltip(trigger) {
        hideTooltip();
        var text = tooltipTextOf(trigger);
        if (!text) return;

        var placement = trigger.getAttribute('data-bs-placement') || 'top';
        // Bootstrap 5.2+ renamed the left/right placement classes to start/end
        // (RTL support) while data-bs-placement itself still says left/right.
        var placementClass = { left: 'start', right: 'end' }[placement] || placement;
        var tip = document.createElement('div');
        tip.className = 'tooltip bs-tooltip-' + placementClass + ' show';
        tip.setAttribute('role', 'tooltip');
        tip.style.position = 'fixed';
        tip.style.zIndex = '1080';
        tip.innerHTML = '<div class="tooltip-arrow"></div><div class="tooltip-inner"></div>';
        tip.querySelector('.tooltip-inner').textContent = text;
        document.body.appendChild(tip);

        var rect = trigger.getBoundingClientRect();
        var tipRect = tip.getBoundingClientRect();
        var gap = 8;
        var top, left;
        if (placement === 'bottom') {
            top = rect.bottom + gap;
            left = rect.left + rect.width / 2 - tipRect.width / 2;
        } else if (placement === 'left') {
            top = rect.top + rect.height / 2 - tipRect.height / 2;
            left = rect.left - tipRect.width - gap;
        } else if (placement === 'right') {
            top = rect.top + rect.height / 2 - tipRect.height / 2;
            left = rect.right + gap;
        } else {
            top = rect.top - tipRect.height - gap;
            left = rect.left + rect.width / 2 - tipRect.width / 2;
        }
        left = Math.max(4, Math.min(left, window.innerWidth - tipRect.width - 4));
        tip.style.top = top + 'px';
        tip.style.left = left + 'px';

        // Real Bootstrap tooltips get this from Popper (which sets it inline as
        // part of arrow placement); QUANTUM's CSS only positions the arrow's
        // ::before triangle, not the wrapper div itself, so without this the
        // arrow renders in normal flow (stacked above tooltip-inner) instead of
        // pinned to the box edge pointing at the trigger.
        var arrow = tip.querySelector('.tooltip-arrow');
        if (arrow) {
            arrow.style.position = 'absolute';
            if (placement === 'top' || placement === 'bottom') {
                arrow.style.left = (rect.left + rect.width / 2 - left - arrow.offsetWidth / 2) + 'px';
            } else {
                arrow.style.top = (rect.top + rect.height / 2 - top - arrow.offsetHeight / 2) + 'px';
            }
        }

        activeTooltip = tip;
    }

    document.addEventListener('mouseover', function (event) {
        var trigger = event.target.closest && event.target.closest('[data-bs-toggle="tooltip"]');
        if (!trigger || trigger.contains(event.relatedTarget)) return;
        showTooltip(trigger);
    });

    document.addEventListener('mouseout', function (event) {
        var trigger = event.target.closest && event.target.closest('[data-bs-toggle="tooltip"]');
        if (!trigger || trigger.contains(event.relatedTarget)) return;
        hideTooltip();
    });

    document.addEventListener('focusin', function (event) {
        var trigger = event.target.closest && event.target.closest('[data-bs-toggle="tooltip"]');
        if (trigger) showTooltip(trigger);
    });

    document.addEventListener('focusout', function (event) {
        var trigger = event.target.closest && event.target.closest('[data-bs-toggle="tooltip"]');
        if (trigger) hideTooltip();
    });

    window.addEventListener('scroll', hideTooltip, true);

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
