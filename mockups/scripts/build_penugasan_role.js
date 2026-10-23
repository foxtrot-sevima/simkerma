/*
 * Build v1/penugasan-role.html - halaman Admin Kerjasama untuk menugaskan
 * pegawai fakultas/prodi sebagai Validator Kerjasama (opsional) dan
 * PIC Kerjasama (wajib, min. 1 per unit). Hierarki: Admin Kerjasama >
 * Validator Kerjasama > PIC Kerjasama.
 *
 * Pola UI mengikuti /spmi/surat-tugas-auditor/create ("Silakan petakan unit
 * kerja dan auditor yang bertugas"): daftar per unit + form inline.
 *
 * Menu: navbar "Pengaturan" > "Penugasan Pegawai", dengan sidebar "Pengaturan"
 * (siap ditambah pengaturan lain). Chrome dipinjam dari
 * v1/unit-kerja-detail.html (halaman ber-sidebar); yang diganti: penanda
 * menu aktif, sidebar, dan <main> (penugasan_role_main.html).
 *
 * Usage:
 *   node mockups/scripts/add_penugasan_nav.js
 *   node mockups/scripts/build_penugasan_role.js
 */
const fs = require('fs');
const pengaturan = require('./lib_pengaturan');
const path = require('path');

const V1 = path.resolve(__dirname, '..', '..', 'v1');
let html = fs.readFileSync(path.join(V1, 'unit-kerja-detail.html'), 'utf8');

html = html.replace('data-mockup-page-id="unit-kerja/detail"', 'data-mockup-page-id="kerjasama/penugasan-role"');
html = html.replace('<title>SEVIMA Platform - Detail Unit Kerja</title>', '<title>SEVIMA Platform - Penugasan Pegawai</title>');
html = html.replace(/href="unit-kerja-detail\.html"/g, 'href="penugasan-role.html"');

// Navbar + sidebar menu Pengaturan (lihat lib_pengaturan.js).
html = pengaturan.activateNav(html, 'penugasan-role.html');
html = html.replace(/<aside class="qn-sidebar[\s\S]*?<\/aside>/, () => pengaturan.sidebar('penugasan-role.html'));

const main = fs.readFileSync(path.join(__dirname, 'penugasan_role_main.html'), 'utf8');
html = html.replace(/<main class="qn-main[\s\S]*?<\/main>/, () => main);

fs.writeFileSync(path.join(V1, 'penugasan-role.html'), html);
console.log('wrote v1/penugasan-role.html', html.length, 'bytes');

