/*
 * Chrome bersama halaman di bawah menu "Pengaturan": sidebar Pengaturan + penanda menu aktif di navbar.
 * Dipakai build_penugasan_role.js dan build_fox1230_1232.js. Tambah pengaturan baru cukup di ITEMS
 * (dan di MENU add_penugasan_nav.js agar muncul di dropdown navbar semua halaman).
 */
const ITEMS = [
    { href: 'penugasan-role.html', label: 'Penugasan Pegawai' },
    { href: 'pengaturan-status-kerjasama.html', label: 'Pengaturan Status Kerjasama' },
];
const ACTIVE = 'bg-primary-subtle text-primary fw-medium';

function sidebar(activeHref) {
    const li = (it) => `<li class="nav-item">
<a class="nav-link${it.href === activeHref ? ' ' + ACTIVE : ''}" href="${it.href}">
<div class="d-flex align-items-center">
<span class="align-self-end">
                                        ${it.label}
                                    </span>
</div>
</a>
</li>`;
    return `<aside class="qn-sidebar offcanvas offcanvas-start position-fixed overflow-x-hidden overflow-y-auto start-0 bg-white border-end" data-bs-scroll="false" id="sidebar" tabindex="-1">
<div class="offcanvas-body">
<div class="d-flex flex-column pb-5">
<ul class="nav nav-pills flex-column gap-2" style="--bs-nav-link-color: var(--bs-body-color);">
<li class="nav-item-title">
                            Pengaturan
                        </li>
${ITEMS.map(li).join('\n')}
</ul>
</div>
</div>
</aside>`;
}

// html sumber = unit-kerja-detail.html (Data Referensi aktif). Matikan itu, aktifkan menu Pengaturan + item halaman ini.
function activateNav(html, activeHref) {
    html = html.replace('nav-link dropdown-toggle active text-primary" data-bs-toggle="dropdown" href="unit-kerja.html"', 'nav-link dropdown-toggle" data-bs-toggle="dropdown" href="unit-kerja.html"');
    html = html.replace('<a class="dropdown-item active" href="unit-kerja.html">Unit Kerja</a>', '<a class="dropdown-item" href="unit-kerja.html">Unit Kerja</a>');
    html = html.replace('class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="penugasan-role.html"', 'class="nav-link dropdown-toggle active text-primary" data-bs-toggle="dropdown" href="penugasan-role.html"');
    html = html.replace(`<a class="dropdown-item" href="${activeHref}">`, `<a class="dropdown-item active" href="${activeHref}">`);
    return html;
}

module.exports = { sidebar, activateNav };
