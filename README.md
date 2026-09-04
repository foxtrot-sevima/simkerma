# Setup Versi Mockup (v1, v2, dst.)

## Tujuan

Tiap versi mockup punya folder sendiri, diakses lewat URL sederhana:

```text
simkerma.vercel.app/v1/index.html              (Dashboard - halaman utama)
simkerma.vercel.app/v1/kerjasama.html
simkerma.vercel.app/v1/kerjasama-detail.html
```

Polanya: **tidak ada rewrite, tidak ada folder nested** - folder versi (`v1/`,
`v2/`, dst.) langsung berisi semua halaman HTML dan `assets/`-nya di level
yang sama. Karena struktur fisik sudah 1:1 dengan URL yang diakses, tidak
perlu `vercel.json` atau konfigurasi tambahan apa pun. Pola ini persis sama
dengan project adik [`tracer-study`](https://github.com/foxtrot-sevima/tracer-study).

---

## Struktur Project

```text
simkerma_ui/
├── index.html            <- redirect otomatis ke /v1/index.html (baru ada 1 versi)
├── v1/
│   ├── index.html        (Dashboard - halaman utama/landing versi ini)
│   ├── kerjasama.html
│   ├── kerjasama-detail.html
│   ├── ...html lainnya
│   └── assets/
│       ├── captured/                             (CSS produksi asli hasil capture - SUMBER RENDER UTAMA)
│       ├── vendors/quantum-v2.2.1-202310260001/  (bundle QUANTUM ter-vendor - dipakai HANYA sebagai fallback
│       │                                           terakhir kalau suatu halaman tidak punya capture CSS-nya)
│       ├── vendors/local-assets/                 (font/pattern QUANTUM tambahan - quantum-symbols, dll.)
│       ├── css/main.css                          (override manual, opsional)
│       └── chart.js, mockup-interactions.js,
│           set-header-height.js, dll.            (scaffolding mockup)
├── mockups/               <- tooling AI (skill mockup-sync): intake capture mentah,
│                              token registry, script build - lihat mockups/README.md
├── QUANTUM/                <- checkout lokal design system QUANTUM (read-only, sumber vendor)
└── docs/                   <- dokumen produk/riset (PRD, regulasi, dll.)
```

Setiap halaman di `v1/` dihasilkan (bukan ditulis tangan) oleh skill AI
`/mockup-sync` (lihat [`mockups/README.md`](mockups/README.md) dan
[`.claude/skills/mockup-sync/SKILL.md`](.claude/skills/mockup-sync/SKILL.md))
dari capture outerHTML halaman SEVIMA Platform - skill ini tetap ada dan
tetap dipakai, cuma hasil build-nya sekarang ditulis ke `v1/` mengikuti pola
di dokumen ini, bukan ke `mockups/pages/<modul>/` seperti sebelumnya.

---

## Aturan Path Asset: `<base>` + Path Relatif

Tiap halaman punya `<base>` tag di awal `<head>`, sesuai prefix foldernya:

```html
<head>
    <base href="/v1/">
    ...
</head>
```

Dengan `<base>` terpasang, semua path relatif di halaman itu (asset maupun
link antar halaman) otomatis di-resolve dari `/v1/` - jadi cukup tulis biasa,
tanpa awalan apa pun:

```html
<link rel="stylesheet" href="assets/captured/app-1960aad9.css">
<script src="assets/mockup-interactions.js"></script>
<img src="assets/vendors/local-assets/sevima-header.webp">
<a href="kerjasama.html">Kerjasama</a>
```

Karena folder `v1/` **memang** folder yang diakses lewat URL `/v1/`, path
relatif ini valid persis, di produksi maupun lokal - tidak ada mismatch
antara lokasi file asli dan URL yang terlihat.

---

## Preview Lokal

Karena tidak ada rewrite yang perlu ditiru, preview lokal otomatis identik
dengan produksi - cukup buka lewat local server mana pun (bukan `file://`
double-click, karena `<base href="/v1/">` adalah path absolut yang butuh
sebuah origin/server).

Termudah: pakai extension **Live Preview** di VS Code. `.vscode/settings.json`
di project ini sudah diarahkan supaya langsung membuka halaman v1:

```json
{
    "livePreview.defaultPreviewPath": "/v1/index.html"
}
```

Alternatif tanpa VS Code: jalankan static server apa pun dari root project,
mis. `npx serve .`, lalu buka `http://localhost:<port>/v1/index.html`.

---

## Menambah Versi Baru (v2, v3, dst.)

1. Buat folder versi baru dengan pola yang sama - semua HTML + `assets/`
   langsung di root folder versi (bukan nested):
   ```text
   v2/
   ├── index.html
   ├── ...
   └── assets/
   ```
2. Tambahkan `<base href="/v2/">` di awal `<head>` tiap halaman.
3. Tulis semua path asset & link antar halaman relatif biasa (`assets/...`,
   `kerjasama.html`, dll.) - tidak perlu awalan `./`, `../`, atau path
   absolut.
4. Kalau versi baru ini dibangun lewat skill `/mockup-sync`: ubah
   `CURRENT_VERSION` di [`mockups/scripts/build_mockup.py`](mockups/scripts/build_mockup.py)
   ke `"v2"`, lalu re-run build untuk tiap halaman yang perlu masuk versi
   ini - lihat [`mockups/README.md`](mockups/README.md).
5. Setelah ada 2+ versi, pertimbangkan mengubah `index.html` root dari
   sekadar redirect menjadi halaman perbandingan versi (lihat contoh di
   `tracer-study/index.html`, yang membandingkan `v2.1/b` vs `v3/b`).

Tidak perlu menyentuh `vercel.json` (project ini tidak memakainya) - Vercel
otomatis serve `v2/index.html` di URL `/v2/index.html` karena strukturnya
memang sudah cocok.

---

## Deploy ke Vercel

Struktur di atas sudah "siap Vercel" tanpa konfigurasi tambahan - langkah
satu-kali yang masih manual (di luar jangkauan tooling di repo ini):

1. Buka [vercel.com](https://vercel.com) → **Add New... → Project** → Import
   repo Git ini (`foxtrot-sevima/simkerma`).
2. Framework preset: **Other** (static, tidak ada build step). Build
   command & output directory dikosongkan saja - Vercel serve isi repo apa
   adanya dari root.
3. Deploy. URL yang dihasilkan otomatis mengikuti struktur folder seperti
   dijelaskan di atas (`<url>/v1/index.html`, dst.).

---

## Troubleshooting

- **CSS/JS/gambar tidak muncul (404)** → pastikan halaman itu punya
  `<base href="/vX/">` di awal `<head>`, dan path assetnya ditulis relatif
  tanpa `./` atau `../`.
- **Buka file HTML langsung (`file://`, double-click) → asset tidak kebaca**
  → ini diharapkan, karena `<base>` berupa path absolut yang butuh sebuah
  server/origin. Pakai Live Preview atau `npx serve` (lihat bagian Preview
  Lokal).
- **Setelah deploy, perlu cek ulang** → jalankan preview Vercel dan buka tab
  Network di browser untuk memastikan tidak ada request 404 ke asset.
- **Tampilan tidak sesuai / terlihat polos tanpa styling sama sekali** → cek
  `v1/<halaman>.manifest.md`, baris "Rendering CSS source". Kalau isinya
  `captured (...)`, harusnya identik produksi - laporkan sebagai bug kalau
  tetap polos (lihat poin CSS/JS 404 di atas dulu). Kalau isinya
  `QUANTUM vendor fallback (...)`, itu **wajar terlihat rusak/tidak
  ter-style** - bundle itu (rilis Oktober 2023) ternyata beda generasi
  desain system dari markup produksi saat ini (class-nya banyak tidak
  cocok, sudah dicek langsung), cuma dipakai kalau capture CSS-nya memang
  tidak ada. Solusinya: capture ulang halaman itu pakai "Save As... Webpage,
  Complete" (bukan "Copy outerHTML") supaya folder `_files`-nya ikut, lalu
  build ulang - itu akan otomatis pindah ke CSS capture asli yang cocok.
- **Ada bagian yang seharusnya ada (sidebar, panel) tapi tidak kelihatan
  sama sekali** → jangan buru-buru simpulkan markup-nya hilang - cek dulu
  apakah `v1/assets/set-header-height.js` ke-load (lihat tab Network). CSS
  produksi banyak yang posisinya bergantung ke `var(--qn-header-height, 0)`
  (mis. sidebar offcanvas yang seharusnya menempel di bawah header) - kalau
  variabel ini tidak ke-set, elemen itu diam-diam menempel di `top:0` dan
  ketutup total di belakang header yang sticky, tanpa error apa pun yang
  kelihatan di console. `set-header-height.js` menambal ini dengan mengukur
  tinggi `.qn-header` asli - kalau skrip ini sudah ada tapi tetap tidak
  membantu, baru itu bug beneran yang perlu ditelusuri lebih lanjut.
