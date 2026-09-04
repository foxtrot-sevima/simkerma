// Keeps --qn-header-height in sync with the real .qn-header's rendered
// height - production sets this via JS the static capture never saved (see
// build_mockup.py for why it matters: without it, the offcanvas .qn-sidebar
// renders hidden behind the sticky header, not just "slightly off").
// Mockup scaffolding only - do not copy into the real project.
(function () {
    function sync() {
        var header = document.querySelector('.qn-header');
        if (header) {
            document.documentElement.style.setProperty('--qn-header-height', header.offsetHeight + 'px');
        }
    }
    sync();
    window.addEventListener('load', sync);
    window.addEventListener('resize', sync);
})();
