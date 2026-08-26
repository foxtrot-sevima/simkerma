# Bank Soal & Logic Interaktif — Prototype KarirLink v2.1/a

Dokumentasi lengkap dari 2 file prototype yang ditemukan lewat pencarian "STR" sebelumnya:

- **Bank soal (sisi Admin):** `Tracer Study/v2.1/a/kuesioner-builder.html`
- **Wizard interaktif (sisi Responden):** `Tracer Study/v2.1/a/tracer-study-form.html`

> ⚠️ Kedua file ini adalah **mockup statis terpisah**, belum terhubung end-to-end — wizard responden (`tracer-study-form.html`) berisi pertanyaan yang di-hardcode, **tidak** menarik secara dinamis dari konfigurasi Optional/regulatorTags yang ada di bank soal admin. Jadi pertanyaan bertag `kemenkes`/`ikuptn`/`banpt`/`lam` yang ada di bank soal (bagian 1) **belum muncul** di wizard responden manapun (bagian 2) — baru sebatas tersedia untuk admin pilih di builder, belum ada contoh render-nya ke responden.

## 1. Seluruh Bank Soal (dari `kuesioner-builder.html`)

### Section 1 — Informasi Pribadi (Core, terkunci, tidak bisa dihapus)

| ID | Pertanyaan | Tipe | Wajib |
|---|---|---|---|
| 1 | Alamat Email | text | Ya |
| 2 | Nomor HP | text | Ya |
| 3 | NIK/No. KTP | text | Ya |
| 4 | NPWP | text | Tidak |

### Section 2 — Informasi Umum (campur Core + Optional)

| ID | Tier | Tag Regulator | Pertanyaan | Tipe | Opsi Jawaban | Wajib | Aktif Default |
|---|---|---|---|---|---|---|---|
| 5 | Core | — | Status Anda saat ini? | checkbox (multi-select) | Bekerja (full time/part time) · Wiraswasta (Wirausaha) · Melanjutkan pendidikan · Tidak kerja, tetapi sedang mencari kerja · Belum memungkinkan bekerja | Ya | — |
| 6 | Core | — | Dari status yang dipilih, mana status utama Anda? *(kalau memilih lebih dari satu)* | radio | *(placeholder statis di builder: "Sesuai status yang dicentang di atas"; opsi sebenarnya di-generate dinamis — lihat bagian 2)* | Ya | — |
| 7 | Optional | `kemdikbud` | Sumber dana apa yang Anda gunakan untuk membiayai kuliah? | radio | Biaya Sendiri/Keluarga · Beasiswa ADIK · BIDIKMISI · PPA | Ya | Nonaktif |
| 8 | Optional | `kemdikbud` | Kapan Anda mulai mencari pekerjaan? | text | — | Tidak | Nonaktif |
| 9 | Optional | `kemdikbud` | Bagaimana cara Anda mencari pekerjaan? | text | — | Tidak | Nonaktif |
| 10 | Optional | `kemdikbud` | Berapa perusahaan yang sudah Anda lamar? | number | — | Tidak | Nonaktif |
| 11 | Optional | `kemenkes` | Apakah Anda bekerja di fasilitas kesehatan? | radio | Ya · Tidak | Tidak | Nonaktif |
| **12** | **Optional** | **`kemenkes`** | **Status STR (Surat Tanda Registrasi) Anda saat ini?** | radio | Aktif · Dalam proses perpanjangan · Belum memiliki | Tidak | Nonaktif |
| 13 | Optional | `kemenkes` | Apakah bidang kerja Anda sesuai dengan kompetensi tenaga kesehatan yang dimiliki? | radio | Sesuai · Tidak sesuai | Tidak | Nonaktif |
| 14 | Optional | `ikuptn` | Berapa lama waktu tunggu Anda mendapatkan pekerjaan pertama? (bulan) | number | — | Tidak | Nonaktif |
| 15 | Optional | `banpt` | Seberapa besar pekerjaan Anda sesuai dengan bidang pendidikan? | scale (1-5) | — | Tidak | Nonaktif |
| 16 | Optional | `banpt`, `lam` | Saran perbaikan untuk program studi/kurikulum | textarea | — | Tidak | Nonaktif |
| 17 | Optional | `lam` | Bagaimana Anda menilai kesiapan kerja lulusan program studi ini secara umum? | scale (1-5) | — | Tidak | Nonaktif |
| 18 | Core | — | Berapa tempat kerja yang Anda jalani saat ini? | number | — | Ya | — |
| 19 | Core | — | Tingkat kompetensi yang dikuasai saat lulus | scale (1-5) | — | Ya | — |

### Section 3-8 — Placeholder Kosong (belum ada soal terpasang)

Bagian ini ada namanya di builder tapi **belum diisi pertanyaan apapun** — admin perlu menambah dari Bank Soal Optional (bagian 1.2) atau menulis Specific sendiri:

- Bekerja
- Wiraswasta
- Melanjutkan Pendidikan
- Belum Bekerja
- Tingkat Kompetensi
- Rencana Karier Lanjutan

### 1.2 — Bank Soal Optional (belum ditambahkan ke section manapun / `bankPool`)

| ID | Tag Regulator | Pertanyaan | Tipe | Opsi Jawaban |
|---|---|---|---|---|
| 101 | `kemdikbud` | Berapa yang merespons lamaran Anda? | number | — |
| 102 | `kemdikbud` | Berapa yang mengundang wawancara? | number | — |
| 103 | `kemdikbud` | Jika pekerjaan tidak sesuai pendidikan, mengapa Anda mengambilnya? | textarea | — |
| 104 | `kemenkes` | Apakah Anda memiliki sertifikat kompetensi/profesi di bidang kesehatan? | radio | Ya · Tidak |
| 105 | `banpt`, `lam` | Seberapa besar otonomi/kebebasan dalam pekerjaan Anda saat ini? | scale (1-5) | — |
| 106 | `banpt`, `lam` | Seberapa puas Anda dengan pekerjaan saat ini secara keseluruhan? | scale (1-5) | — |

**Label regulator yang dipakai di builder:** `kemdikbud` → Kemdikbud · `kemenkes` → Kemenkes · `ikuptn` → IKU PTN · `banpt` → BAN-PT · `lam` → LAM.

**Total pertanyaan di seluruh bank soal (termasuk bankPool):** 25 item (ID 1-19 + 101-106).

### 1.3 Status Cakupan — Seluruh Pertanyaan KEMDIKTI vs Bank Soal Prototype

Mencocokkan **semua 32 baris** di [Komparasi §1a Tabel A](Komparasi%20Kuesioner%20KEMDIKTI%20(Kemdiktisaintek)%20vs%20KEMENKES.md) terhadap bank soal + wizard prototype ini, supaya tidak ada satupun pertanyaan KEMDIKTI yang diam-diam hilang dari dokumentasi:

| Tabel A No. | Pertanyaan | Status di Prototype |
|---|---|---|
| 1 | Jelaskan status Anda saat ini? | ✅ Ada — `id 5` (Core, checkbox multi-select; live site pakai single-select radio) |
| 2 | Sebutkan sumber dana pembiayaan kuliah | ✅ Ada — `id 7` (Optional/kemdikbud, 4 opsi) **dan** wizard `Q6` (7 opsi) — opsi tidak sinkron, lihat bagian 3 |
| 3 | Kompetensi dikuasai saat lulus (bagian A) | ⚠️ Ada tapi disederhanakan — `id 19` "Tingkat kompetensi yang dikuasai saat lulus" (1 scale gabungan, tidak dipecah per aspek) |
| 4 | Kompetensi dibutuhkan pekerjaan saat ini (bagian B) | ❌ Belum ada field terpisah di bank soal manapun |
| 5 | Penekanan metode pembelajaran di prodi | ❌ Belum ada sama sekali di prototype |
| 6 | Kapan mulai mencari pekerjaan | ✅ Ada — `id 8` (Optional/kemdikbud) |
| 7 | Bagaimana cara mencari pekerjaan | ✅ Ada — `id 9` (Optional/kemdikbud) |
| 8 | Jumlah perusahaan dilamar | ✅ Ada — `id 10` (Optional/kemdikbud) |
| 9 | Jumlah yang merespons lamaran | ✅ Ada — `id 101` (bankPool/kemdikbud) |
| 10 | Jumlah yang mengundang wawancara | ✅ Ada — `id 102` (bankPool/kemdikbud) |
| 11 | Aktif mencari kerja 4 minggu terakhir | ⚠️ Ada versi berbeda — wizard `Q9` (Core, 5 opsi granular), tapi **tidak** ada sebagai Optional/kemdikbud terpisah di builder sesuai redaksi asli |
| 12 | Alasan kerja tidak sesuai pendidikan | ✅ Ada — `id 103` (bankPool/kemdikbud) |
| 13 | *(live site)* Dalam berapa bulan dapat pekerjaan pertama | ⚠️ Ada versi digabung — wizard `Q7`+`Q8` ("pekerjaan/pendidikan sebelum lulus" + waktu tunggu), tidak spesifik per-pekerjaan |
| 14 | *(live site)* Pendapatan per bulan (take home pay) | ✅ Ada — field `Gaji` di kartu repeatable pekerjaan |
| 15 | *(live site)* Lokasi tempat bekerja | ❌ Belum ada field lokasi di kartu pekerjaan |
| 16 | *(live site)* Jenis perusahaan/instansi tempat bekerja | ❌ Belum ada (kartu pekerjaan tidak punya field kategori instansi) |
| 17 | *(live site)* Nama perusahaan/kantor | ✅ Ada — field `Instansi/Perusahaan` di kartu repeatable |
| 18 | *(live site)* Tingkat tempat kerja | ❌ Belum ada |
| 19 | *(live site)* Keeratan bidang studi dgn pekerjaan | ⚠️ Ada, tapi cuma bertag `banpt` bukan `kemdikbud` — `id 15` builder "Seberapa besar pekerjaan Anda sesuai dengan bidang pendidikan?" (scale) |
| 20 | *(live site)* Tingkat pendidikan tersesuai utk pekerjaan | ❌ Belum ada |
| 21 | *(live site)* Belum memungkinkan bekerja — tanpa lanjutan | ✅ Konsisten — `block-none` di wizard tidak menampilkan field tambahan |
| 22 | *(live site)* Bulan mulai wiraswasta | ❌ Belum ada di `block-usaha` |
| 23 | *(live site)* Pendapatan wiraswasta per bulan | ⚠️ Kemungkinan numpang di field `Gaji` kartu pekerjaan (karena `block-pekerjaan` ikut tampil saat wiraswasta dicentang), tapi tidak eksplisit dipisah dari status "bekerja" |
| 24-25 | *(live site)* Lokasi usaha (Provinsi/Kota-Kabupaten) | ❌ Belum ada di `block-usaha` (cuma ada field `Bidang Usaha`) |
| 26 | *(live site)* Posisi/jabatan saat wiraswasta | ❌ Belum ada — opsi `Status Kerja` di kartu pekerjaan cuma Full-time/Part-time/Kontrak/Freelance, **tidak ada opsi "Pemilik Usaha"** |
| 27 | *(live site)* Tingkat tempat kerja (wiraswasta) | ❌ Belum ada |
| 28 | *(live site)* Sumber biaya studi lanjut | ❌ Belum ada di `block-studi` (cuma ada field `Jenjang Studi Lanjut`) |
| 29 | *(live site)* Nama Perguruan Tinggi studi lanjut | ❌ Belum ada |
| 30 | *(live site)* Program Studi lanjut | ❌ Belum ada |
| 31 | *(live site)* Tanggal Masuk studi lanjut | ❌ Belum ada |
| 32 | *(live site)* Tidak kerja tapi sedang mencari kerja — tanpa lanjutan | ✅ Konsisten — `block-none` juga mencakup status ini |

**Ringkasan:** dari 32 pertanyaan KEMDIKTI, **12 penuh ada**, **5 ada tapi beda bentuk/redaksi**, **15 belum ada sama sekali** di prototype — mayoritas yang hilang ada di cabang Wiraswasta (5/6 field) dan Melanjutkan Pendidikan (4/4 field), karena `block-usaha` dan `block-studi` di wizard baru berisi 1 field masing-masing, jauh lebih sederhana dari redaksi live site Kemdiktisaintek.

### 1.4 Status Cakupan — Seluruh Pertanyaan KEMENKES vs Bank Soal Prototype

Mencocokkan **semua 9 baris** di [Komparasi §1a Tabel B](Komparasi%20Kuesioner%20KEMDIKTI%20(Kemdiktisaintek)%20vs%20KEMENKES.md):

| Tabel B No. | Pertanyaan | Status di Prototype |
|---|---|---|
| 1 | Apakah Anda saat ini sedang melanjutkan studi? *(dugaan)* | ⚠️ Konsepnya tercakup di `id 5` (Status Anda saat ini, opsi "Melanjutkan pendidikan"), tapi tidak sebagai pertanyaan Ya/Tidak terpisah |
| 2 | Apakah Anda saat ini sedang bekerja? *(dugaan)* | ⚠️ Sama — tercakup sebagai salah satu opsi `id 5`, bukan pertanyaan Ya/Tidak sendiri |
| 3 | Kompetensi dikuasai saat lulus (bagian A) | ⚠️ Sama seperti Tabel A No. 3 — `id 19`, digabung jadi 1 scale |
| 4 | Kompetensi dibutuhkan pekerjaan saat ini (bagian B) | ❌ Belum ada, sama seperti Tabel A No. 4 |
| 5 | Penekanan metode pembelajaran di prodi | ❌ Belum ada, sama seperti Tabel A No. 5 |
| 6 | Apakah Anda bekerja di fasilitas kesehatan? | ✅ Ada — `id 11` (Optional/kemenkes) |
| 7 | **Status STR (Surat Tanda Registrasi) Anda saat ini?** | ✅ Ada — `id 12` (Optional/kemenkes) |
| 8 | Apakah bidang kerja sesuai kompetensi tenaga kesehatan? | ✅ Ada — `id 13` (Optional/kemenkes) |
| 9 | Apakah punya sertifikat kompetensi/profesi bidang kesehatan? | ✅ Ada — `id 104` (bankPool/kemenkes) |

**Ringkasan:** dari 9 pertanyaan KEMENKES, **4 penuh ada** (semuanya yang ditemukan lewat penelusuran STR), **2 tercakup implisit lewat status gate**, **3 belum ada** (kompetensi bagian B, metode pembelajaran, dan status melanjutkan-studi/bekerja sbg pertanyaan Ya/Tidak terpisah — sama persis dengan 3 gap yang juga berlaku di sisi Kemdikti).

## 2. Logic Interaktif Nyata (dari `tracer-study-form.html` — wizard 2 halaman)

Wizard ini adalah **contoh render statis** dengan Q1-9 hardcode (bukan hasil generate dinamis dari bank soal admin) — beberapa redaksi/opsi sedikit berbeda dari bank soal builder (dicatat di bagian 3).

### Halaman 1 — Informasi Pribadi + Informasi Umum

| No | Pertanyaan | Cara Menjawab | Opsi | Logic Interaktif |
|---|---|---|---|---|
| 1 | Alamat Email | text, **readonly** (sudah terisi otomatis) | — | Tidak bisa diedit responden |
| 2 | Nomor HP | text input | — | Wajib |
| 3 | NIK/No. KTP | text input, maks 16 digit, numeric | — | Wajib |
| 4 | NPWP | text input | — | Opsional |
| 5 | Status Anda saat ini? | **checkbox, multi-select** | Bekerja (full time/part time) · Wiraswasta (Wirausaha) · Melanjutkan pendidikan · Tidak kerja tetapi sedang mencari kerja · Belum memungkinkan bekerja | Tiap centang memanggil `handleStatusChange()` → memicu Q5a **dan** merekalkulasi blok halaman 2 (`recomputeTransisiKerja()`) |
| 5a | Dari status yang Anda pilih, mana status utama Anda? | radio, **hanya muncul kalau Q5 dicentang >1** | *Opsi di-generate dinamis* = persis status-status yang dicentang di Q5 (kalau centang "Bekerja" + "Melanjutkan pendidikan", opsi radio-nya cuma 2 itu) | `display:none` default; construct via `updateStatusUtama()`. Kalau responden uncheck sampai cuma 1 status tersisa, blok ini otomatis disembunyikan lagi & pilihan dikosongkan |
| 6 | Sumber dana apa yang Anda gunakan untuk membiayai kuliah? | radio, single-select | Biaya Sendiri/Keluarga · Beasiswa ADIK · Beasiswa BIDIKMISI · Beasiswa PPA · Beasiswa AFIRMASI · Beasiswa Perusahaan/Swasta · Lainnya | 7 opsi (lebih banyak dari bank soal builder yang cuma 4 — lihat bagian 3) |
| 7 | Apakah Anda mendapatkan pekerjaan pertama / melanjutkan pendidikan sebelum lulus? | radio, single-select | Ya · Tidak | Memanggil `applyQ7Logic(value)` |
| 8 | Dalam berapa bulan Anda mendapatkan pekerjaan pertama/melanjutkan studi setelah lulus? | number input (0-120) | — | **Conditional**: hanya muncul kalau Q7 = **"Tidak"**. Kalau Q7 diubah ke "Ya", field ini disembunyikan lagi & value dikosongkan otomatis |
| 9 | Apakah Anda aktif mencari pekerjaan dalam 4 minggu terakhir? | radio, single-select | Tidak · Tidak, tapi saya sedang menunggu hasil lamaran kerja · Ya, saya akan mulai bekerja dalam 2 minggu ke depan · Ya, tapi saya belum pasti akan bekerja dalam 2 minggu ke depan · Lainnya | 5 opsi granular (vs live site Kemdiktisaintek yang cuma implisit Ya/Tidak — lihat [Komparasi §2](Komparasi%20Kuesioner%20KEMDIKTI%20(Kemdiktisaintek)%20vs%20KEMENKES.md)) |

### Halaman 2 — Transisi Kerja (isinya 100% bergantung jawaban Q5 di halaman 1)

Fungsi `recomputeTransisiKerja()` menentukan blok mana yang tampil, dievaluasi ulang setiap kali Q5 berubah:

| Blok | Kondisi Tampil | Isi |
|---|---|---|
| `block-pekerjaan` | Q5 mengandung **"bekerja"** ATAU **"wiraswasta"** | 1) "Berapa tempat kerja yang Anda jalani saat ini?" (number, sinkron otomatis dgn jumlah kartu pekerjaan lewat `syncJobCount()`)<br>2) **Grup repeatable** "Detail Pekerjaan" — tombol "+ Tambah Pekerjaan Lain" menambah kartu baru; tiap kartu (`Pekerjaan #1`, `#2`, dst) berisi 4 field: Instansi/Perusahaan (text), Bidang Kerja (text), Status Kerja (dropdown: Full-time/Part-time/Kontrak/Freelance), Gaji (number, prefix "Rp") |
| `block-studi` | Q5 mengandung **"melanjutkan_pendidikan"** | "Jenjang Studi Lanjut" — dropdown: S1 · S2 · S3 · Profesi |
| `block-usaha` | Q5 mengandung **"wiraswasta"** | "Bidang Usaha" — text input (cth. Kuliner, Fashion, Jasa Konsultan) |
| `block-none` | Q5 **tidak** mengandung bekerja/wiraswasta/studi (artinya cuma "mencari_kerja" dan/atau "belum_bekerja" yang dicentang) | Pesan statis: *"Tidak ada pertanyaan lanjutan untuk status yang Anda pilih di halaman sebelumnya."* — **tidak ada field tambahan sama sekali** |

Catatan penting soal `block-none`: kalau responden pilih **"Wiraswasta" + "Melanjutkan pendidikan"** sekaligus (tanpa "bekerja"), maka `block-usaha` DAN `block-studi` tampil bersamaan, `block-pekerjaan` tetap tampil juga (karena kondisinya OR dengan wiraswasta) — union tiga blok sekaligus, bukan exclusive. Ini konsisten dengan model "union per status" yang pernah dibahas di [Konsep §9.6.1](Konsep-Pertanyaan-Core-Optional-Specific-untuk-Template-Quisioner.md).

### Validasi & Progress

- `validatePage1()` / `validatePage2()`: submit diblokir (toast merah berisi daftar field yang kurang) kalau ada yang wajib belum diisi — termasuk validasi kondisional (mis. Q8 cuma divalidasi wajib kalau Q7="Tidak"; field pekerjaan repeatable cuma divalidasi kalau block-pekerjaan sedang tampil).
- Progress bar & counter "X pertanyaan dijawab" dihitung ulang tiap perubahan (`updateAnsweredCount()`), termasuk cuma menghitung field yang sedang **terlihat** (`isElementVisible`) — field yang disembunyikan karena kondisi tidak terpenuhi tidak ikut dihitung.
- Setelah halaman 2 valid, submit mengarahkan ke `tracer-study-success.html` (halaman selesai) — belum ada pemanggilan API/penyimpanan data nyata (murni mockup front-end, `console.log`/redirect saja).

## 3. Diskrepansi yang Ditemukan

| Temuan | Detail |
|---|---|
| Q6 (sumber dana) beda jumlah opsi | Wizard responden: **7 opsi** (termasuk AFIRMASI, Perusahaan/Swasta). Bank soal admin (ID 7): cuma **4 opsi**. Perlu disamakan salah satu jadi rujukan tunggal. |
| Q9 (aktif cari kerja) beda granularitas | Wizard responden: **5 opsi** nuansa (menunggu hasil, mulai 2 minggu, dst). Live site Kemdiktisaintek (dari [Komparasi §1](Komparasi%20Kuesioner%20KEMDIKTI%20(Kemdiktisaintek)%20vs%20KEMENKES.md)): tidak ada follow-up sama sekali untuk status ini. |
| Pertanyaan `kemenkes`/`ikuptn`/`banpt`/`lam` belum dirender ke wizard manapun | Semua ada di bank soal builder (bagian 1), tapi `tracer-study-form.html` tidak punya satupun instance-nya — termasuk STR. Builder dan wizard belum terhubung dinamis. |
| Status "mencari_kerja"/"belum_bekerja" konsisten tanpa follow-up | Baik di live site Kemdiktisaintek maupun di wizard prototype ini (`block-none`), kedua status ini sama-sama tidak py pertanyaan lanjutan — mengonfirmasi ulang temuan di Komparasi §2, bukan cuma kebetulan satu sumber. |
| Section placeholder builder (Bekerja/Wiraswasta/dst) kosong | Section-section ini ada namanya di data model builder tapi 0 pertanyaan — mengindikasikan pertanyaan cabang (job detail, bidang usaha, jenjang studi) di desain builder **belum dipetakan** ke section-section itu, padahal secara nyata sudah ada & jalan di wizard `tracer-study-form.html` halaman 2. Kemungkinan builder & wizard dikerjakan terpisah dan belum disinkronkan. |
