/*
 * Pasang elemen tiket FOX-1230/1231/1232 ke chrome semua halaman v1/ (idempotent):
 *  1. Ikon lonceng + dropdown notifikasi di header (kerangka; isi dirender assets/notifikasi.js)
 *  2. Badge counter angka pada menu "Validasi Kerjasama" di navbar
 *  3. <script src="assets/notifikasi.js"> setelah mockup-interactions.js
 *  4. Membersihkan item "Pengaturan Status Kerjasama" yang sempat ditaruh di Data Referensi
 * Jalankan SETELAH build_*.js (halaman hasil build ikut dipatch) dan boleh diulang.
 *
 * Usage: node mockups/scripts/add_notifikasi.js
 */
const fs = require('fs');
const path = require('path');

const V1 = path.resolve(__dirname, '..', '..', 'v1');

const BELL = `<div class="dropdown" id="qn-notif">
<button aria-expanded="false" aria-label="Notifikasi" class="btn btn-light p-2 py-1 bg-transparent text-white border-0 position-relative" data-bs-toggle="dropdown" type="button">
<i class="sym sym-bell-02 fs-5"></i>
<span class="badge rounded-pill text-bg-danger position-absolute top-0 start-100 translate-middle qn-bell-badge" data-qn-notif-badge>3</span>
</button>
<div class="dropdown-menu dropdown-menu-end p-0 overflow-hidden" id="qn-notif-menu"></div>
</div>
`;
const HEADER_RIGHT = /(<div class="ms-auto d-flex align-items-center gap-1">\s*)(<div class="d-none d-md-flex align-items-center gap-1">)/;
const COUNTER = '>Validasi Kerjasama<span class="badge rounded-pill text-bg-danger qn-counter" data-qn-counter>3</span></a>';
const SCRIPT_AFTER = '<script src="assets/mockup-interactions.js"></script>';
// Pengaturan Status Kerjasama kini berada di menu Pengaturan (dibuat add_penugasan_nav.js), bukan Data Referensi.
// Bersihkan sisa iterasi sebelumnya: item yang menempel tepat setelah "Unit Kerja" di dropdown & sidebar Data Referensi.
const DUP_VALIDASI = /\s*<li class="nav-item">\s*<a[^>]*href="#">Validasi Kerjasama<\/a>\s*<\/li>/;
const OLD_DD = /(<li><a class="dropdown-item[^"]*" href="unit-kerja\.html">Unit Kerja<\/a><\/li>)\s*<li><a class="dropdown-item[^"]*" href="pengaturan-status-kerjasama\.html">Pengaturan Status Kerjasama<\/a><\/li>/;
const OLD_SIDE = /(<li class="nav-item">\s*<a class="nav-link[^"]*" href="unit-kerja\.html">[\s\S]*?<\/li>)\s*<li class="nav-item">\s*<a class="nav-link[^"]*" href="pengaturan-status-kerjasama\.html">[\s\S]*?<\/li>/;

for (const f of fs.readdirSync(V1).filter((n) => n.endsWith('.html') && !n.includes(' '))) {
    const p = path.join(V1, f);
    const orig = fs.readFileSync(p, 'utf8');
    let s = orig;
    if (!s.includes('id="qn-notif"')) s = s.replace(HEADER_RIGHT, (m, a, b) => a + BELL + b);
    if (!s.includes('data-qn-counter')) s = s.replace('>Validasi Kerjasama</a>', COUNTER);
    if (!s.includes('assets/notifikasi.js')) s = s.replace(SCRIPT_AFTER, SCRIPT_AFTER + '<script src="assets/notifikasi.js"></script>');
    // Hapus duplikat item Validasi Kerjasama tanpa badge (sisa bug sisip ganda) bila versi ber-badge sudah ada.
    if (s.includes('data-qn-counter')) s = s.replace(DUP_VALIDASI, '');
    s = s.replace(OLD_DD, '$1');
    s = s.replace(/<aside[\s\S]*?<\/aside>/, (aside) => aside.replace(OLD_SIDE, '$1'));
    if (s !== orig) { fs.writeFileSync(p, s); console.log('patched', f); }
}
