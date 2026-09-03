# Mockup ↔ QUANTUM sync

> Cari panduan langkah-demi-langkah yang tidak teknis (untuk UI Designer/PM)?
> Lihat [`TUTORIAL.md`](TUTORIAL.md). Dokumen ini menjelaskan cara kerja &
> alasan teknis di baliknya, untuk yang mengembangkan/merawat alur ini.

Alur untuk mengubah hasil "Save outerHTML" dari halaman produk (SEVIMA Platform)
menjadi mockup statis yang bersih, dirender dari CSS capture aslinya sendiri
(ground truth, dijamin identik produksi) - lihat "Kenapa begini" di bawah
untuk alasannya.

Output-nya mengikuti pola versioning yang sama dengan project adik
[`tracer-study`](../../Tracer%20Study/tracer-study): dijelaskan lengkap di
[README.md root](../README.md) (kenapa `v1/`, pola `<base href="/v1/">`,
cara deploy ke Vercel). Ringkasan yang relevan untuk alur mockup-sync ini:

## Struktur folder

Semua halaman untuk versi desain yang sedang berjalan (`v1` saat ini — lihat
`CURRENT_VERSION` di `build_mockup.py`) ditulis **flat** ke `v1/` di root
project, bukan dikelompokkan per modul — `v1/kerjasama-daftar.html`,
`v1/kerjasama-detail.html`, dst semuanya sibling file, berbagi satu
`v1/assets/` (dideduplikasi otomatis):

```
simkerma_ui/
  v1/
    index.html                  <- dashboard/home versi ini (lihat HOME_PAGE_ID)
    index.manifest.md
    kerjasama-daftar.html       <- mockup bersih, auto-generated (jangan edit manual)
    kerjasama-daftar.manifest.md
    kerjasama-detail.html, kerjasama-create.html, dst.
    assets/
      captured/*.css            <- CSS produksi asli hasil capture - SUMBER RENDER UTAMA
      vendors/quantum-v2.2.1-202310260001/   <- bundle QUANTUM ter-vendor, dipakai HANYA kalau
        assets/release/qn-202310260001.css     capture-nya tidak ada folder `_files` (fallback
        assets/fonts/, assets/images/, dst.     terakhir - lihat "Kenapa begini" soal batasannya)
      vendors/local-assets/     <- font/pattern QUANTUM tambahan (quantum-symbols, dst)
      chart.js, chart-settings.js, chartjs-plugin-datalabels.min.js
      mockup-interactions.js
      css/main.css              <- override manual (opsional, mulai kosong)
  mockups/
    raw/<nama-capture>/         <- intake mentah, tetap per-capture (bukan per-modul/versi)
      <Nama Halaman>.html
      <Nama Halaman>_files/
    route-map/v1.json           <- auto-generated: peta "halaman ini = route apa", per versi
    tokens/
      design-tokens.json        <- auto-generated: semua --qn-* variable dari QUANTUM
      component-classes.json    <- auto-generated: semua class yang dikenal QUANTUM
    scripts/
      extract_tokens.py         <- scan QUANTUM/ -> update tokens/*.json
      build_mockup.py           <- raw HTML -> mockup bersih + manifest, ke v1/
```

Contoh nyata: `v1/kerjasama-daftar.html`, `v1/kerjasama-detail.html`,
`v1/kerjasama-create.html`, dst — semuanya sibling file langsung di `v1/`,
saling link pakai nama file biasa (`kerjasama-detail.html`), bukan
`../kerjasama/detail.html` atau path bersarang lain. `module/page` yang kamu
ketik ke `build_mockup.py` (mis. `kerjasama/daftar`) menentukan nama file
ini lewat `output_stem()` — lihat [SKILL.md](../.claude/skills/mockup-sync/SKILL.md)
untuk aturan lengkapnya.

`QUANTUM/` sendiri tidak pernah diubah oleh alur ini — dia tetap murni sebagai
sumber kebenaran (source of truth) untuk komponen dan token.

### Kenapa tidak `npm install` QUANTUM saja?

QUANTUM (`@quantum/web`) adalah package **privat**, di-host di GitLab
internal SEVIMA (`gitlab.sevima.com`), bukan di npm registry publik maupun
registry privat yang bisa diakses dari sini — jadi `npm install @quantum/web`
tidak akan berhasil di lingkungan mockup ini. Solusinya tetap menyalin
langsung dari checkout lokal `QUANTUM/` — spesifiknya
`QUANTUM/pwa-laravel/public/vendors/quantum-v2.2.1-202310260001/`, bundle
pre-built terbaru yang tersedia di semua checkout QUANTUM lokal — tapi
cukup **satu kali per versi**, bukan satu kali per halaman — itulah fungsi
folder `v1/assets/vendors/`. Kalau nanti QUANTUM memang dipasang sebagai
dependency asli di project produksi (bukan di flow mockup ini), `npm install
@quantum/web` tetap valid asalkan `.npmrc` project sudah dikonfigurasi ke
registry internal SEVIMA tersebut.

## Alur kerja

1. **Save outerHTML** halaman apa pun dari SEVIMA Platform lewat DevTools
   ("Save as... Webpage, Complete" atau Elements panel > Copy outerHTML lalu
   simpan sebagai `.html`). Taruh file (+ folder `_files` kalau ada) di
   `mockups/raw/<nama-capture>/` (masih per-capture, bebas apapun namanya).
2. Jalankan (atau minta Claude jalankan lewat skill `/mockup-sync`), dengan
   argumen kedua berbentuk `<modul>/<halaman>`:
   ```
   python mockups/scripts/build_mockup.py raw/<nama-capture>/<nama-file>.html kerjasama/daftar
   ```
   Kalau argumen kedua cuma satu kata tanpa `/` (misalnya `login`), itu
   dianggap modul dengan satu halaman saja, ditulis sebagai `v1/login.html`.

   **Penting:** modul ditentukan oleh URL asli halaman itu, bukan oleh nama
   yang "kelihatan pas". Contoh nyata dari project ini: halaman yang secara
   visual terlihat seperti "dashboard" ternyata di-capture dari
   `/v2/kerjasama/dashboard` — jadi dia bagian dari modul **kerjasama**
   (ditulis sebagai `v1/index.html`, karena itu dashboard/home versi ini —
   lihat `HOME_PAGE_ID`). Sebelum menentukan nama modul, cek komentar
   `saved from url=(...)` di baris pertama file capture-nya untuk tahu route
   aslinya. Script juga otomatis membandingkan ini — kalau modul yang dipakai
   tidak cocok dengan segmen URL-nya, `manifest.md` akan menampilkan
   peringatan di bagian paling atas.
3. Buka `v1/<halaman>.html` di browser (lewat local server, lihat "Preview
   Lokal" di README.md root — bukan double-click, karena `<base href="/v1/">`)
   untuk lihat hasilnya, dan baca `v1/<halaman>.manifest.md` untuk laporan:
   - **Interactions** — dropdown, collapse (navbar toggler/filter/accordion),
     modal, offcanvas, tab, alert-dismiss apa saja yang terdeteksi di halaman
     ini dan sudah otomatis dibuat berfungsi (lihat bagian "Semua interaksi
     UI ikut aktif" di bawah),
   - komponen/class QUANTUM apa saja yang terdeteksi dipakai,
   - class ber-prefix `qn-` yang TIDAK ditemukan di `QUANTUM/` lokal (indikasi
     drift — mockup punya komponen yang belum terdokumentasi di design system),
   - warna hex hardcode yang sebetulnya sudah ada token QUANTUM-nya (harus
     diganti `var(--token)`), dan warna yang benar-benar belum ada tokennya.

Setiap kali `QUANTUM/` di-update (misalnya pull versi baru), jalankan ulang:
```
python mockups/scripts/extract_tokens.py
```
supaya `tokens/*.json` — dan karenanya semua laporan drift di atas — tetap
akurat terhadap versi QUANTUM terbaru.

## Navigasi antar-mockup (dinamis - otomatis makin lengkap)

Kalau kamu punya lebih dari satu mockup untuk satu modul (misalnya: daftar,
detail, form create, halaman sukses), navbar dan tombol-tombol di dalamnya
**benar-benar berpindah ke mockup lain yang sesuai** — bukan cuma diam di
`#`. Ini otomatis, tidak perlu dikonfigurasi manual:

1. Setiap capture yang dibuat lewat "Save As... Webpage, Complete" menyimpan
   komentar `saved from url=(...)https://.../path/asli` di baris pertama.
   `build_mockup.py` membaca path itu dan mencatatnya ke
   `mockups/route-map/v1.json` sebagai "halaman ini mewakili route apa".
2. Semua `<a href>`/`<form action>` yang mengarah ke domain
   testing/production dicek path-nya terhadap `route-map.json`. Kalau sudah
   ada mockup untuk path itu (persis sama, atau pola yang sama — misalnya
   `/kerjasama/45` dan `/kerjasama/78` dianggap route yang sama, cuma beda
   id), link itu ditulis ulang jadi link relatif ke mockup tersebut. Kalau
   belum ada, link itu ditulis `#` sambil disimpan alamat aslinya (atribut
   `data-mockup-unresolved`) — **bukan dibuang**.
3. **Setiap kali mockup baru dibuild**, script otomatis menyisir ULANG semua
   mockup lama yang masih punya `data-mockup-unresolved` dan mengecek lagi
   apakah sekarang sudah ada mockup yang cocok. Jadi urutan build tidak
   penting — build "daftar" duluan lalu "detail" belakangan, atau
   sebaliknya, hasil akhirnya sama: begitu dua-duanya ada, link "Detail" di
   halaman daftar otomatis nyambung ke halaman detail, tanpa perlu
   membangun ulang halaman daftar secara manual.
4. Kalau ada beberapa capture untuk route yang sama persis (contoh nyata:
   halaman detail, halaman "berhasil dibuat", dan halaman "berhasil diubah"
   di app ini semuanya route `/kerjasama/{id}` yang sama, cuma beda status
   flash message), link dari halaman LAIN (misal tombol "Detail" di daftar)
   akan diarahkan ke versi yang **bukan** `*-success` — supaya user yang
   klik "Detail" mendarat di tampilan detail biasa, bukan di layar "berhasil
   diubah" yang sifatnya sementara.
5. Manifest tiap halaman punya bagian **"Internal navigation"** yang
   menyebutkan persis link mana yang sudah tersambung, dan path apa yang
   masih menunggu (`data-mockup-unresolved`) — jadi kelihatan jelas halaman
   apa yang perlu di-capture berikutnya supaya alur makin lengkap.

**Tombol hapus/delete** memakai modal konfirmasi ASLI dari hasil capture, bukan
dialog `confirm()` bawaan browser. `build_mockup.py` mendeteksi modal yang
judulnya mengandung "Hapus" dan isinya mengandung kata "yakin"/"dikembalikan"
(pola yang dipakai QUANTUM untuk semua konfirmasi hapus), lalu:
- ikon tong sampah (`sym-trash*`) di tiap baris tabel disambungkan ke modal
  konfirmasi per-baris yang sudah ada di capture (judul, isi teks, tombol
  "Batal"/"Hapus" — semuanya persis seperti aplikasi asli, cuma di-buka pakai
  script lokal, bukan bundle JS produksi yang tidak bisa dipakai ulang),
- tombol hapus massal (bulk, di luar baris tabel) disambungkan ke modal
  konfirmasi bulk-nya sendiri, dan otomatis menampilkan modal "belum pilih
  data" dulu kalau tidak ada checkbox yang dicentang — persis alur aslinya,
- begitu tombol "Hapus" di dalam modal diklik, modal tertutup dan baris
  (atau semua baris yang dicentang, untuk hapus massal) hilang dari tampilan
  — mensimulasikan hasil delete tanpa benar-benar terhubung ke server.
Kalau suatu tombol hapus tidak punya modal yang cocok di capture-nya (atau
cuma pakai `wire:confirm="..."` dari Livewire 3), baru fallback ke dialog
`confirm()` bawaan browser dengan pesan konfirmasinya.

## Kenapa begini

- **CSS asli hasil capture selalu diprioritaskan sebagai sumber render.**
  Kalau folder `_files` hasil "Save Complete" ikut disertakan, script
  menyalin persis stylesheet yang tadinya dipakai halaman itu
  (`v1/assets/captured/*.css`) — ini yang paling akurat karena itu betul-betul
  CSS yang merender halaman waktu di-capture. **Sempat dicoba sebaliknya**
  (bundle QUANTUM ter-vendor sebagai CSS utama, persis seperti tracer-study)
  lalu dibatalkan setelah dicek langsung: bundle
  `quantum-v2.2.1-202310260001` (Oktober 2023 — sudah dikonfirmasi yang
  terbaru yang tersedia pre-built di semua checkout QUANTUM lokal) ternyata
  cuma cocok dengan **~9% class** yang benar-benar dipakai halaman produksi
  saat ini, dibanding **~94%** kalau pakai CSS capture — beda generasi design
  system yang tidak nyambung, bukan sekadar "agak basi". (tracer-study
  cocok pakai bundle itu karena mockup-nya memang dibuat langsung di era
  QUANTUM 2023 itu; capture di project ini dari produksi yang jauh lebih
  baru.) Kalau capture tidak menyertakan folder `_files` (mockup baru yang
  dibangun dari nol), baru fallback ke bundle vendor tersebut sebagai
  pendekatan terakhir — manifest akan menandai ini jelas-jelas sebagai
  kemungkinan tampil rusak/polos, bukan cuma "sedikit beda".
- File CSS hasil capture kadang mereferensikan file font/gambar ber-hash
  (`/build/assets/quantum-symbols-xxxx.woff`, pattern header/sidebar) yang
  **tidak ikut** ke-save browser. Script TIDAK mengarahkannya ke server
  testing/production — semua harus lokal. Sebagai gantinya, script mencari
  aset first-party yang cocok di `QUANTUM/quantum-ai/source/quantum-v3.4/`
  (source font `quantum-symbols` dan pattern `sevima-header`/`sevima-sidebar`
  ternyata ada di sana, persis
  nama filenya) dan menyalinnya ke `v1/assets/vendors/local-assets/`. Kalau
  suatu url `/...` atau `https://...` tidak ada padanan lokalnya, url itu
  diganti `none` (bukan dibiarkan menunjuk ke domain luar) — icon/pattern itu
  akan tampil kosong, dicatat di manifest.
- **Tidak ada satu pun `href`/`action`/`url()` yang mengarah ke domain
  testing/production.** Semua `<a href="https://...">` dan
  `<form action="https://...">` diproses lewat pencocokan route (lihat
  "Navigasi antar-mockup" di atas) — yang cocok dengan mockup lain ditautkan
  ke situ, sisanya jadi `#` sambil menyimpan alamat aslinya supaya bisa
  tersambung otomatis begitu mockup tujuannya dibuat.
- **Semua interaksi UI ikut aktif, bukan cuma dropdown — otomatis untuk halaman
  apa pun.** Bundle JS produksi aslinya adalah ES module yang meng-import
  chunk yang tidak ikut ter-save browser, dan sebagian butuh backend Livewire
  hidup — jadi tidak bisa dipakai apa adanya di mockup statis. Sebagai
  gantinya, `mockup-interactions.js` adalah re-implementasi vanilla-JS kecil
  yang meniru **semua** kontrak `data-bs-*` standar Bootstrap 5 sekaligus:
  dropdown, collapse (dipakai navbar-toggler mobile, panel filter, accordion),
  modal, offcanvas, tab/pill, dan dismiss alert. Script `build_mockup.py`
  mendeteksi otomatis mana saja yang benar-benar dipakai tiap halaman (lihat
  bagian "Interactions" di manifest) — jadi kalau prototype berikutnya punya
  panel filter (biasanya `collapse` atau `offcanvas`) atau tab, itu ikut aktif
  tanpa perlu kode tambahan, karena semuanya pakai class state (`.show`,
  `.active`, dst.) yang sama persis dengan yang sudah didefinisikan CSS
  Bootstrap asli di `captured/*.css` — tampilan & posisinya identik dengan
  production.
  Chart.js + plugin datalabels + chart-settings asli (file JS yang di-save
  browser) disalin lokal, dan script inline yang benar-benar berisi data
  chart (`Chart.register(ChartDataLabels)` dst, dengan angka aslinya) tetap
  dipertahankan persis — jadi grafik dirender ulang oleh Chart.js dari data
  asli, bukan cuma screenshot.
  **Batasan yang jujur**: alert/toast yang baru muncul SETELAH create/update
  sungguhan tidak bisa dipicu di mockup statis (tidak ada backend). Kalau
  butuh state itu persis, capture ulang halaman tepat setelah aksi itu terjadi
  di aplikasi asli, lalu jalankan ulang script.
- Semua stylesheet/script hasil vendoring disalin **ke dalam `v1/assets/`
  versi itu sendiri** (bukan ditautkan lintas folder ke `QUANTUM/`) — supaya
  versi ini self-contained persis seperti tracer-study (tidak bergantung ke
  luar folder versinya, cuma butuh `<base href="/v1/">` + server lokal, lihat
  README.md root). Halaman berikutnya di versi yang sama otomatis memakai
  ulang salinan yang sudah ada (dicek dulu apakah filenya sudah ada sebelum
  menyalin) — tidak ada duplikasi per halaman.
- **Noise dibuang otomatis**: atribut Livewire/Alpine, atribut wiring
  Turbo/CSRF (`data-turbo-eval`, `data-csrf`, dst — tidak ada gunanya di
  mockup statis dan cuma mengotori markup kalau di-slicing), debug toolbar
  Symfony (`sf-dump`, `phpdebugbar`), elemen suntikan ekstensi browser
  (`plasmo-csui`, dll), `style` bawaan Chart.js di `<canvas>` yang sudah basi
  (di-generate ulang saat load), komentar HTML, dan script lain yang bukan
  chart/interaksi (Livewire runtime, ES module yang rusak, dsb).

## Markup siap "slicing" ke project

Tujuan `index.html` hasil generate bukan cuma untuk preview visual, tapi juga
supaya strukturnya bisa langsung dicopy-paste jadi Blade/komponen di project
nyata:

- Class & struktur DOM dipertahankan 1:1 dari capture asli (tidak diubah,
  tidak disederhanakan) — jadi copy-paste satu blok (misalnya satu `.card`
  atau satu dropdown) akan langsung cocok dengan CSS QUANTUM/Bootstrap yang
  sudah dipakai di project.
- Atribut yang cuma relevan untuk runtime Livewire/Turbo/debug sudah dibuang
  (lihat "Noise dibuang otomatis" di atas) — yang tersisa adalah markup polos
  plus `data-bs-*` standar Bootstrap, yang di project nyata tinggal disambung
  lagi ke `wire:` masing-masing kalau perlu.
- `mockup-interactions.js` **jangan ikut di-copy ke project** — itu cuma
  pengganti sementara karena project asli sudah punya bundle JS Bootstrap
  penuh. File ini ditandai jelas di komentar headernya ("mockup scaffolding
  only").