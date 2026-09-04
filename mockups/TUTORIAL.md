# Tutorial: Ubah Tampilan Aplikasi Jadi Mockup Bersih

Panduan ini untuk **Engineer** yang ingin mengambil
tampilan halaman SEVIMA Platform yang sudah jadi (di staging/testing), lalu
mengubahnya jadi file mockup yang rapi, ringan, dan siap dipakai untuk:

- referensi desain (semua tombol, dropdown, chart-nya beneran bisa diklik/jalan,
  bukan cuma gambar diam),
- bahan diskusi dengan tim engineering,
- cek apakah tampilan itu sudah pakai komponen standar QUANTUM atau belum
  (kalau belum, itu tandanya perlu didaftarkan ke tim design system).

Tidak perlu bisa coding. Semua proses "berat" (bersihkan kode, sambungkan ke
QUANTUM, dst.) dikerjakan otomatis oleh Claude — tugas kamu cuma 3 langkah:
**ambil tampilan halaman → simpan → minta Claude proses.**

---

## Yang perlu disiapkan

1. Browser Chrome atau Edge.
2. Akses ke halaman SEVIMA Platform yang mau dijadikan mockup (biasanya di
   environment testing/staging).
3. Project ini (`simkerma_ui`) sudah terbuka di Claude Code.

---

## Langkah 1 — Ambil tampilan halaman dari browser

Ada dua cara. **Pakai Cara A kalau bisa** — hasilnya paling akurat karena ikut
menyimpan gaya visual (CSS) dan grafik (JavaScript) asli halaman itu.

### Cara A (disarankan): "Save As... Webpage, Complete"

1. Buka halaman yang mau di-mockup-kan, tunggu sampai selesai loading penuh
   (semua chart/data sudah tampil).
2. Tekan `Ctrl + S` (Windows) di browser.
3. Di kotak "Save As", pastikan bagian **"Save as type"** dipilih
   **"Webpage, Complete"** (bukan "Webpage, HTML Only").
4. Simpan dengan nama yang jelas, misalnya `Dashboard Kerjasama.html`.
5. Browser akan membuat **dua item**: file `.html` dan satu folder
   `..._files` di sebelahnya. **Keduanya wajib disimpan bersamaan**, jangan
   dipisah atau folder-nya dihapus.

### Cara B (alternatif, kalau Cara A tidak bisa dilakukan)

1. Buka halaman yang mau di-mockup-kan.
2. Klik kanan di area kosong halaman → **Inspect** (atau tekan `F12`).
3. Di panel yang terbuka (tab **Elements**), scroll ke paling atas sampai
   ketemu baris `<html ...>` paling luar.
4. Klik kanan baris itu → **Copy** → **Copy outerHTML**.
5. Buka Notepad (atau editor teks apa saja), tempel (`Ctrl+V`), lalu simpan
   sebagai file `.html`, misalnya `Dashboard Kerjasama.html`.

> **Bedanya apa?** Cara B lebih cepat tapi tidak menyertakan file CSS/JS
> aslinya, jadi hasil mockup-nya nanti dibuat mendekati (pakai referensi dari
> QUANTUM) — bisa jadi ada sedikit beda warna/posisi dibanding aslinya. Cara A
> menyertakan semuanya, jadi hasilnya dijamin identik dengan yang kamu lihat
> di browser.

---

## Langkah 2 — Simpan file ke folder project

Pindahkan file (dan folder `..._files` kalau ada, dari Cara A) ke folder:

```
mockups/raw/<nama-halaman>/
```

Ganti `<nama-halaman>` dengan nama singkat tanpa spasi, contoh: `dashboard`,
`list-mitra`, `form-kegiatan`. Jadi hasil akhirnya kira-kira:

```
mockups/raw/list-mitra/Data Mitra.html
mockups/raw/list-mitra/Data Mitra_files/       <- kalau pakai Cara A
```

Kalau kamu tidak yakin caranya, **cukup taruh file-nya di mana saja lalu
bilang ke Claude** — minta tolong dipindahkan (lihat prompt di Langkah 3).

---

## Langkah 3 — Minta Claude memprosesnya

Di Claude Code, ketik salah satu prompt berikut (tinggal sesuaikan nama
file/halamannya):

**Kalau file sudah ada di `mockups/raw/...`:** sebutkan `<modul>/<halaman>`
(kalau halaman ini bagian dari modul yang sama dengan mockup lain yang sudah
pernah dibuat, pakai nama modul yang sama supaya dikelompokkan jadi satu):

```
/mockup-sync raw/list-mitra/Data Mitra.html mitra/daftar
```

**Kalau belum yakin sudah taruh di folder yang benar (paling gampang, cukup ini):**

```
Tolong buatkan mockup dari file "Data Mitra.html" yang baru aku save,
pakai alur mockup-sync yang sudah ada.
```

Claude akan otomatis:

1. Merapikan file (buang kode yang tidak perlu: debug tools, tracker, dsb).
2. Menyambungkan tampilan ke QUANTUM sehingga warna/font/komponennya tetap
   konsisten dengan design system resmi.
3. Membuat semua yang bisa diklik **beneran berfungsi**: dropdown, menu
   navbar, panel filter, modal (pop-up), tab, chart dengan data asli, tombol
   tutup pada notifikasi/alert, dan tombol **hapus** — memakai pop-up
   konfirmasi yang **sama persis** dengan aplikasi asli (judul "Hapus ...",
   teks peringatannya, tombol "Batal"/"Hapus"), lalu barisnya hilang dari
   tampilan kalau tombol "Hapus" di pop-up itu diklik.
4. **Menyambungkan tombol navigasi ke mockup lain kalau sudah ada** — misalnya
   tombol "Tambah Kerjasama" di halaman daftar akan benar-benar membuka
   mockup halaman form create (bukan cuma diam), dan tombol "Detail" di
   setiap baris tabel akan membuka mockup halaman detail yang sesuai. Ini
   otomatis nyambung sendiri begitu kedua halaman itu sudah pernah diproses
   — **urutan mana yang diproses duluan tidak masalah**.
5. Menulis laporan (`manifest.md`) yang menjelaskan apa saja yang ditemukan
   dan diproses.

Tunggu sampai Claude bilang selesai (biasanya beberapa detik).

> **Tips:** kalau satu modul punya beberapa halaman terkait (daftar, detail,
> form tambah, form edit, halaman sukses, dst), proses **semuanya** satu per
> satu dengan Langkah 1-3 di atas (nama folder beda-beda). Setelah semuanya
> diproses, buka halaman daftar-nya — tombol "Tambah", "Detail", "Edit" di
> situ akan langsung membuka mockup halaman masing-masing, persis seperti
> aplikasi asli. Kalau baru sebagian halaman yang diproses, tombol yang
> tujuannya belum ada mockup-nya akan diam dulu (belum error, cuma menunggu)
> — nanti otomatis aktif begitu halaman tujuannya menyusul diproses.

---

## Langkah 4 — Lihat hasilnya

Hasilnya ada di folder `v1/` (langsung di root project — semua halaman
untuk versi mockup yang sedang berjalan dikumpulkan flat di sini, jadi kalau
modulnya "kerjasama" akan muncul `kerjasama.html` (daftar/list-nya),
`kerjasama-detail.html`, `kerjasama-create.html`, dst sebagai file sibling,
bukan folder terpisah per modul/halaman):

| File | Isinya |
|---|---|
| `<halaman>.html` | Mockup-nya (misal `kerjasama.html`). **Tidak bisa** dibuka dengan double-click biasa — lihat catatan "Cara buka" di bawah. |
| `<halaman>.manifest.md` | Laporan singkat untuk halaman itu, dalam bahasa yang mudah dibaca — lihat panduan di bawah. |
| `assets/` | File CSS/JS/font QUANTUM yang dipakai bersama oleh semua halaman versi ini — tidak perlu dibuka manual. |

**Cara buka**: setiap halaman butuh sebuah local server (tidak bisa
double-click file-nya langsung) — termudah pakai extension **Live Preview**
di VS Code (sudah otomatis diarahkan ke `v1/index.html`), atau minta tim
engineering menjalankan `npx serve .` dari root project lalu buka
`http://localhost:<port>/v1/<halaman>.html`. Detail lengkapnya ada di
`README.md` root project.

### Cara baca `manifest.md`

File ini akan berisi beberapa bagian. Berikut artinya dalam bahasa awam:

- **"Rendering CSS source"** — kalau tulisannya `captured`, artinya tampilan
  mockup dijamin identik dengan aplikasi asli. Kalau tulisannya
  `QUANTUM vendor fallback`, artinya file CSS asli tidak ikut tersimpan
  (biasanya karena pakai Cara B di Langkah 1), jadi mockup terpaksa pakai
  CSS QUANTUM cadangan yang ternyata beda generasi design system dari
  aplikasi produksi saat ini — tampilannya kemungkinan besar terlihat rusak
  atau tidak ter-style sama sekali (bukan cuma "sedikit beda"). Kalau ini
  terjadi, sebaiknya ulangi Langkah 1 pakai Cara A ("Webpage, Complete")
  supaya CSS asli ikut tersimpan.
- **"Internal navigation"** — daftar tombol/link yang berhasil disambungkan
  ke mockup halaman lain (contoh: "Tambah" -> mockup form create), dan
  daftar link yang masih menunggu (belum ada mockup tujuannya). Kalau ada
  path yang menurutmu penting di daftar "masih menunggu" itu, itu artinya
  tinggal capture halaman tersebut (ulangi Langkah 1-3) — begitu selesai,
  link ini otomatis ikut tersambung, tanpa perlu proses ulang halaman yang
  sudah ada.
- **"Interactions"** — daftar tombol/menu/panel yang berhasil dibuat
  berfungsi (dropdown, filter, modal/pop-up, tab, tombol hapus, dst),
  lengkap dengan jumlahnya. Kalau ada bagian yang menurutmu seharusnya bisa
  diklik tapi tidak muncul di sini, kabari — kemungkinan itu dibuat dengan
  cara yang tidak umum dan perlu dicek manual.
- **"Possible design-system drift"** — ini bagian penting untuk Engineer.
  Artinya: ada elemen tampilan yang **terlihat seperti** komponen resmi
  QUANTUM, tapi **belum tercatat** di buku panduan design system. Ini sinyal
  bagus untuk diangkat ke tim QUANTUM — supaya komponen itu resmi
  didokumentasikan dan bisa dipakai ulang dengan konsisten di halaman lain.
- **"Colors"** — daftar warna yang dipakai di halaman itu. Kalau ada catatan
  "sudah ada token QUANTUM-nya", berarti warna itu sebenarnya sudah standar
  (cuma ditulis manual, bukan masalah besar). Kalau tertulis "tidak ada
  padanan", berarti itu warna baru yang belum ada di palet resmi — perlu
  didiskusikan apakah memang disengaja atau salah pakai warna.
- **"Create/update flash alerts"** — catatan bahwa notifikasi sukses (misal
  "Data berhasil disimpan") yang baru muncul setelah submit form **tidak
  bisa dicoba** di mockup ini, karena mockup tidak tersambung ke server
  sungguhan. Kalau butuh melihat tampilan notifikasi itu, minta tim
  engineering trigger dulu di environment testing, capture ulang persis
  setelah notifikasinya muncul, lalu ulangi Langkah 1-3.

---

## Hal yang perlu diingat

- **Bukan aplikasi sungguhan.** Mockup ini tidak tersambung ke database/API
  — data yang tampil adalah data pada saat halaman itu di-capture, tidak
  akan berubah walau kamu klik "simpan"/"submit". Tombol hapus memang
  membuat barisnya hilang dari layar (untuk simulasi), tapi kalau halaman
  di-refresh, datanya akan muncul lagi seperti semula.
- **Chart-nya beneran jalan** (bisa hover, animasi muncul), tapi datanya
  tetap data pada saat capture, bukan data real-time.
- **Satu file = satu halaman**, dan nama filenya mengikuti modulnya (mis.
  `kerjasama.html` untuk daftar/list-nya, `kerjasama-detail.html` untuk
  sub-halamannya) walau semuanya sibling file di `v1/`, bukan folder
  terpisah. Kalau mau buat mockup untuk beberapa
  halaman modul yang sama (misal: daftar, detail, form tambah kerjasama),
  ulangi Langkah 1-3 untuk tiap halaman dengan `<modul>` yang **sama** dan
  `<halaman>` yang beda-beda (`kerjasama/daftar`, `kerjasama/detail`,
  `kerjasama/create`).
- **Modul ditentukan dari alamat asli halamannya, bukan dari kelihatannya
  seperti apa.** Contoh nyata: halaman yang tampilannya seperti "dashboard"
  di project ini ternyata alamat aslinya `.../kerjasama/dashboard` — jadi dia
  tetap bagian dari modul **kerjasama** (`kerjasama/index`, ditulis sebagai
  `v1/index.html` karena itu dashboard/home versi ini), bukan modul
  "dashboard" sendiri. Kalau ragu, cek dulu ke Claude "ini halaman bagian
  dari modul apa?" sebelum menentukan nama modulnya — salah kelompok berarti
  nama filenya jadi tidak konsisten dan tombol navigasinya bisa salah
  sambung.
- **Boleh diulang kapan saja.** Kalau ada perubahan di aplikasi asli, capture
  ulang halamannya dan minta Claude proses lagi dengan `<modul>/<halaman>`
  yang sama — hasil lama akan digantikan otomatis dengan yang baru.
- **Untuk tim engineering**: markup di dalam tiap `<halaman>.html` sengaja
  dibuat identik dengan aplikasi asli (class & strukturnya tidak diubah),
  jadi bisa langsung dijadikan referensi/di-copy ke Blade kalau memang
  dibutuhkan — tidak perlu desain ulang dari nol.
- **Tidak perlu `npm install` apapun.** QUANTUM adalah design system privat
  SEVIMA (bukan package publik), jadi semua file CSS/JS/font-nya disalin
  langsung dari folder `QUANTUM/` yang sudah ada di project ini — sekali per
  versi mockup, dipakai bersama semua halamannya (folder `v1/assets/`), bukan
  disalin ulang tiap halaman.

---

## Kalau ada masalah

| Gejala | Kemungkinan penyebab & solusi |
|---|---|
| Tampilan mockup berantakan/tidak ada gaya sama sekali | Kemungkinan pakai Cara B (Copy outerHTML) tanpa folder `_files`. Ulangi Langkah 1 pakai Cara A ("Save As... Webpage, Complete"). |
| Ada ikon yang tidak muncul (kotak kosong) | Font ikon-nya tidak ketemu padanan lokalnya. Ini akan tercatat di `manifest.md`, cukup laporkan ke Claude untuk dicek. |
| Dropdown/filter/modal tidak bisa diklik | Cek bagian "Interactions" di `manifest.md` — kalau memang tidak terdeteksi di sana, kemungkinan elemen itu dibuat dengan cara non-standar dan perlu penanganan khusus. Laporkan ke Claude dengan menyebutkan elemen mana yang dimaksud. |
| Butuh mockup dari banyak halaman sekaligus | Bisa diminta satu per satu dengan prompt yang sama, atau bilang ke Claude "aku mau proses beberapa halaman ini sekaligus" sambil menyebutkan nama-nama filenya. |
| Tombol "Tambah"/"Detail"/"Edit" tidak membuka halaman lain | Cek bagian "Internal navigation" di `manifest.md` — kalau path tujuannya masih di daftar "menunggu", berarti halaman tujuannya belum di-capture/diproses. Proses halaman itu (Langkah 1-3), lalu link-nya otomatis aktif tanpa perlu mengulang halaman yang pertama. |
| File hasil "Copy outerHTML" (Cara B) tidak bisa dihubungkan ke halaman lain | Cara B tidak menyimpan alamat asli halaman, jadi Claude tidak tahu itu route apa. Kalau butuh navigasi antar-halaman, wajib pakai Cara A. |

---

## Ringkasan cepat (cheat-sheet)

1. `Ctrl+S` di halaman yang mau di-mockup-kan → pilih **Webpage, Complete**.
2. Pindahkan file + folder `_files` ke `mockups/raw/<nama-capture>/`.
3. Ketik ke Claude: `/mockup-sync raw/<nama-capture>/<nama-file>.html <modul>/<halaman>`
   (contoh: `kerjasama/daftar` — pakai nama modul yang sama untuk halaman
   satu grup supaya saling terhubung dan berbagi file QUANTUM).
4. Buka `v1/<halaman>.html` (lewat local server / Live Preview, lihat "Cara
   buka" di Langkah 4) untuk lihat hasilnya.
5. Baca `v1/<halaman>.manifest.md` untuk laporannya.