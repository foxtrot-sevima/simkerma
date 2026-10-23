/*
 * Build halaman desain tiket FOX-1230/1231/1232:
 *  - v1/pengaturan-status-kerjasama.html : Pengaturan Status Kerjasama (di bawah menu Pengaturan)
 *  - v1/komponen-notifikasi.html         : lembar komponen Reminder + badge counter Validasi Kerjasama
 * Lonceng dan badge counter dipasang ke semua halaman oleh add_notifikasi.js; menu Pengaturan oleh add_penugasan_nav.js.
 *
 * Usage:
 *   node mockups/scripts/add_notifikasi.js
 *   node mockups/scripts/build_fox1230_1232.js
 *   node mockups/scripts/add_notifikasi.js     (ulang agar halaman baru ikut dipatch)
 */
const fs = require('fs');
const path = require('path');
const pengaturan = require('./lib_pengaturan');

const V1 = path.resolve(__dirname, '..', '..', 'v1');
const read = (f) => fs.readFileSync(path.join(V1, f), 'utf8');
const replaceMain = (html, file) => html.replace(/<main class="qn-main[\s\S]*?<\/main>/, () => fs.readFileSync(path.join(__dirname, file), 'utf8'));

// --- Pengaturan Status Kerjasama (chrome ber-sidebar: unit-kerja-detail.html) ---
{
    let h = read('unit-kerja-detail.html');
    h = h.replace('data-mockup-page-id="unit-kerja/detail"', 'data-mockup-page-id="status-kerjasama/pengaturan"');
    h = h.replace('<title>SEVIMA Platform - Detail Unit Kerja</title>', '<title>SEVIMA Platform - Pengaturan Status Kerjasama</title>');
    h = h.replace(/href="unit-kerja-detail\.html"/g, 'href="pengaturan-status-kerjasama.html"');
    // menu Pengaturan (navbar + sidebar) - lihat lib_pengaturan.js
    h = pengaturan.activateNav(h, 'pengaturan-status-kerjasama.html');
    h = h.replace(/<aside class="qn-sidebar[\s\S]*?<\/aside>/, () => pengaturan.sidebar('pengaturan-status-kerjasama.html'));
    fs.writeFileSync(path.join(V1, 'pengaturan-status-kerjasama.html'), replaceMain(h, 'pengaturan_status_main.html'));
    console.log('wrote v1/pengaturan-status-kerjasama.html');
}

// --- Lembar komponen (chrome tanpa sidebar: mitra.html) ---
{
    let h = read('mitra.html');
    h = h.replace('data-mockup-page-id="mitra/index"', 'data-mockup-page-id="komponen/notifikasi"');
    h = h.replace('<title>SEVIMA Platform - Daftar Mitra</title>', '<title>SEVIMA Platform - Komponen Reminder & Badge Counter</title>');
    h = h.replace('class="nav-link text-primary active" href="mitra.html"', 'class="nav-link" href="mitra.html"');
    fs.writeFileSync(path.join(V1, 'komponen-notifikasi.html'), replaceMain(h, 'komponen_notifikasi_main.html'));
    console.log('wrote v1/komponen-notifikasi.html');
}
