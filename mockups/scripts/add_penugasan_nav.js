/*
 * Daftarkan menu "Pengaturan > Penugasan Pegawai" (dropdown level atas, setelah
 * Laporan) di navbar semua halaman v1/. Menu dibuat sebagai grup "Pengaturan"
 * supaya ke depan pengaturan lain bisa ditambahkan di bawahnya. Membuang sisa
 * iterasi sebelumnya (link level atas, item di Data Referensi). Idempotent.
 * Jalankan SEBELUM build_penugasan_role.js.
 *
 * Usage: node mockups/scripts/add_penugasan_nav.js
 */
const fs = require('fs');
const path = require('path');

const V1 = path.resolve(__dirname, '..', '..', 'v1');
const OLD_PENGATURAN = /\s*<li class="nav-item dropdown">\s*<a[^>]*>\s*Pengaturan\s*<\/a>[\s\S]*?<\/ul>\s*<\/li>/;
const OLD_TOP = /\s*<li class="nav-item">\s*<a[^>]*href="penugasan-role\.html">Penugasan (?:Role|Kerjasama|Pegawai)<\/a>\s*<\/li>/;
const OLD_DROPDOWN = /\s*<li><a class="dropdown-item[^"]*" href="penugasan-role\.html">Penugasan (?:Role|Kerjasama|Pegawai)<\/a><\/li>/;
const OLD_SIDEBAR = /\s*<li class="nav-item">\s*<a class="nav-link[^"]*" href="penugasan-role\.html">[\s\S]*?<\/li>/;
const LAPORAN_END = /(<li class="nav-item dropdown">\s*<a[^>]*>\s*Laporan\s*<\/a>[\s\S]*?<\/ul>\s*<\/li>)/;
const MITRA_END = /(<li class="nav-item">\s*<a[^>]*href="mitra\.html">Mitra<\/a>\s*<\/li>)/;
const VALIDASI = '<li class="nav-item">\n<a aria-current="page" class="nav-link" data-mockup-unresolved="/v2/kerjasama/validasi-kerjasama" href="#">Validasi Kerjasama</a>\n</li>';
const MENU = `<li class="nav-item dropdown">
<a aria-expanded="false" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="penugasan-role.html" role="button">
                                    Pengaturan
                                </a>
<ul class="dropdown-menu">
<li><a class="dropdown-item" href="penugasan-role.html">Penugasan Pegawai</a></li>
<li><a class="dropdown-item" href="pengaturan-status-kerjasama.html">Pengaturan Status Kerjasama</a></li>
</ul>
</li>`;

// Halaman di bawah menu Pengaturan dibangun sendiri (penanda aktif), jadi dilewati di sini.
const SKIP = (n) => n.startsWith('penugasan-role') || n.startsWith('pengaturan-status') || n.includes(' ');
for (const f of fs.readdirSync(V1).filter((n) => n.endsWith('.html') && !SKIP(n))) {
    const p = path.join(V1, f);
    const orig = fs.readFileSync(p, 'utf8');
    let s = orig.replace(OLD_PENGATURAN, '').replace(OLD_TOP, '').replace(OLD_DROPDOWN, '');
    s = s.replace(/<aside[\s\S]*?<\/aside>/, (a) => a.replace(OLD_SIDEBAR, ''));
    if (!s.includes('href="#">Validasi Kerjasama')) s = s.replace(MITRA_END, (m) => m + '\n' + VALIDASI);
    s = s.replace(LAPORAN_END, (m) => m + '\n' + MENU);
    if (s !== orig) { fs.writeFileSync(p, s); console.log('patched', f); }
}
