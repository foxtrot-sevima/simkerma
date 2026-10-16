/*
 * Build v1/penugasan-role.html - halaman Admin Kerjasama untuk menugaskan
 * pegawai fakultas/prodi sebagai Validator Kerjasama (opsional) dan
 * PIC Kerjasama (wajib, min. 1 per unit). Hierarki: Admin Kerjasama >
 * Validator Kerjasama > PIC Kerjasama.
 *
 * Pola UI mengikuti /spmi/surat-tugas-auditor/create ("Silakan petakan unit
 * kerja dan auditor yang bertugas"): daftar per unit + form inline.
 *
 * Menu: navbar "Pengaturan" > "Penugasan Role", dengan sidebar "Pengaturan"
 * (siap ditambah pengaturan lain). Chrome dipinjam dari
 * v1/unit-kerja-detail.html (halaman ber-sidebar); yang diganti: penanda
 * menu aktif, sidebar, dan <main> (penugasan_role_main.html).
 *
 * Usage:
 *   node mockups/scripts/add_penugasan_nav.js
 *   node mockups/scripts/build_penugasan_role.js
 */
const fs = require('fs');
const path = require('path');

const V1 = path.resolve(__dirname, '..', '..', 'v1');
let html = fs.readFileSync(path.join(V1, 'unit-kerja-detail.html'), 'utf8');

html = html.replace('data-mockup-page-id="unit-kerja/detail"', 'data-mockup-page-id="kerjasama/penugasan-role"');
html = html.replace('<title>SEVIMA Platform - Detail Unit Kerja</title>', '<title>SEVIMA Platform - Penugasan Role Kerjasama</title>');
html = html.replace(/href="unit-kerja-detail\.html"/g, 'href="penugasan-role.html"');

// Navbar: matikan Data Referensi (aktif di halaman sumber), aktifkan Pengaturan.
html = html.replace('nav-link dropdown-toggle active text-primary" data-bs-toggle="dropdown" href="unit-kerja.html"', 'nav-link dropdown-toggle" data-bs-toggle="dropdown" href="unit-kerja.html"');
html = html.replace('<a class="dropdown-item active" href="unit-kerja.html">Unit Kerja</a>', '<a class="dropdown-item" href="unit-kerja.html">Unit Kerja</a>');
html = html.replace('class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="penugasan-role.html"', 'class="nav-link dropdown-toggle active text-primary" data-bs-toggle="dropdown" href="penugasan-role.html"');
html = html.replace('<a class="dropdown-item" href="penugasan-role.html">Penugasan Role</a>', '<a class="dropdown-item active" href="penugasan-role.html">Penugasan Role</a>');

const sidebar = `<aside class="qn-sidebar offcanvas offcanvas-start position-fixed overflow-x-hidden overflow-y-auto start-0 bg-white border-end" data-bs-scroll="false" id="sidebar" tabindex="-1">
<div class="offcanvas-body">
<div class="d-flex flex-column pb-5">
<ul class="nav nav-pills flex-column gap-2" style="--bs-nav-link-color: var(--bs-body-color);">
<li class="nav-item-title">
                            Pengaturan
                        </li>
<li class="nav-item">
<a class="nav-link bg-primary-subtle text-primary fw-medium" href="penugasan-role.html">
<div class="d-flex align-items-center">
<span class="align-self-end">
                                        Penugasan Role
                                    </span>
</div>
</a>
</li>
</ul>
</div>
</div>
</aside>`;
html = html.replace(/<aside class="qn-sidebar[\s\S]*?<\/aside>/, () => sidebar);

const main = fs.readFileSync(path.join(__dirname, 'penugasan_role_main.html'), 'utf8');
html = html.replace(/<main class="qn-main[\s\S]*?<\/main>/, () => main);

fs.writeFileSync(path.join(V1, 'penugasan-role.html'), html);
console.log('wrote v1/penugasan-role.html', html.length, 'bytes');
