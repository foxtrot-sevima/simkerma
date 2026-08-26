# Pemetaan Pertanyaan Core vs Optional (Draft Seed Data)

Dokumen ini adalah lanjutan dari [Konsep Pertanyaan Core-Optional-Specific untuk Template Quisioner](Konsep%20Pertanyaan%20Core-Optional-Specific%20untuk%20Template%20Quisioner.md) — mencoba menjawab pertanyaan konkret: **pertanyaan mana saja yang sebaiknya Core, mana yang Optional**, supaya bisa jadi draf seed data untuk bank pertanyaan.

> ⚠️ **Status: Draft awal, belum final.** Bagian yang bersumber dari tabel riset KEMDIKTI vs KEMENKES sudah terverifikasi (ada di riset kamu). Bagian IKU PTN, BAN-PT, dan LAM di dokumen ini masih berdasarkan pengetahuan umum tentang pola instrumen akreditasi yang lazim dipublikasikan — **perlu divalidasi ke dokumen resmi terbaru** sebelum dipakai sebagai seed data produksi.

## 1. Metodologi Pemetaan

**Koreksi model dari draft sebelumnya:** Core tidak boleh berbeda-beda tergantung regulator institusi. Sesuai definisi Schomburg (slide 22), Core harus *"fixed for the whole project"* — sama untuk **semua** institusi, titik. Kalau sebuah pertanyaan cuma wajib untuk institusi yang lapor ke regulator tertentu (mis. wajib untuk Kemdikbud, tidak untuk Kemenkes), itu **bukan Core** — itu tetap **Optional**, meskipun secara default bisa dinyalakan otomatis untuk institusi yang relevan. Jadi hanya ada **dua tier**, bukan tier bercabang per regulator:

- ✅ **Core** — satu set kecil yang berlaku sama untuk *semua* institusi tanpa syarat, terkunci di semua template.
- 🔘 **Optional** — semua pertanyaan lain, ada di satu bank yang sama untuk semua institusi. Admin toggle sendiri; regulator (Kemdikbud/Kemenkes/IKU PTN/dst) hanya jadi **tag/label** untuk memudahkan filter dan rekomendasi "aktifkan semua yang relevan untuk X" di bank Optional — bukan penentu tier.

Konsekuensi ke template: karena template memang **satu**, tidak ada lagi kolom "Kemdikbud" / "Kemenkes" yang membedakan tier — kolom itu diganti jadi kolom **"Relevan untuk"** yang sifatnya informatif saja.

## 2. Survei Lulusan — Pemetaan dari Tabel Riset KEMDIKTI vs KEMENKES

Sumber: [Perbandingan Pertanyaan yang di ajukan oleh KEMDIKTI & KEMENKES](Perbandingan%20Pertanyaan%20yang%20di%20ajukan%20oleh%20KEMDIK%2039de039bd7dc80329d24f58dae0d674e.md)

| No | Pertanyaan | Kategori | Tier | Relevan untuk (tag, bukan penentu tier) | Time Reference |
|---|---|---|---|---|---|
| 1 | Jelaskan status Anda saat ini? (Bekerja full/part time; Belum memungkinkan bekerja; Wiraswasta; Melanjutkan Pendidikan; Tidak kerja tapi sedang mencari kerja) | Status transisi kerja (gate question) | **Core** — dasar klasifikasi semua institusi, jadi gate percabangan section lain | Kemdikbud, Kemenkes | after_study / at_present |
| 2 | Sebutkan sumber dana pembiayaan kuliah? (bukan saat Studi Lanjut) | Sosiodemografi | Optional | Kemdikbud | before_study |
| 3 | Tingkat kompetensi yang dikuasai saat lulus (A) vs tingkat kompetensi yang dibutuhkan pekerjaan saat ini (B) | Kompetensi | **Core** | Kemdikbud, Kemenkes | after_study vs at_present |
| 4 | Seberapa besar penekanan metode pembelajaran tertentu dilaksanakan di prodi | Proses pembelajaran | **Core** | Kemdikbud, Kemenkes | during_study |
| 5 | Kapan mulai mencari pekerjaan (di luar kerja sambilan) | Proses pencarian kerja | Optional | Kemdikbud | after_study |
| 6 | Bagaimana cara mencari pekerjaan tersebut | Proses pencarian kerja | Optional | Kemdikbud | after_study |
| 7 | Jumlah perusahaan/instansi yang dilamar sebelum pekerjaan pertama | Proses pencarian kerja | Optional | Kemdikbud | after_study |
| 8 | Jumlah perusahaan/instansi yang merespons lamaran | Proses pencarian kerja | Optional | Kemdikbud | after_study |
| 9 | Jumlah perusahaan/instansi yang mengundang wawancara | Proses pencarian kerja | Optional | Kemdikbud | after_study |
| 10 | Apakah aktif mencari pekerjaan dalam 4 minggu terakhir | Status pencarian kerja (definisi standar ILO/BPS) | Optional | Kemdikbud | at_present |
| 11 | Jika pekerjaan saat ini tidak sesuai pendidikan, kenapa diambil (multi-jawaban) | Kesesuaian kerja | Optional, dengan `depends_on` = pertanyaan No.1 (hanya tampil jika status bekerja tapi tidak sesuai) | Kemdikbud | at_present |

**Pola yang terlihat:** hanya 3 dari 11 pertanyaan (No. 1, 3, 4) yang Core — dijawab semua responden di semua institusi tanpa syarat. 8 sisanya masuk satu bank Optional yang sama; tag "Kemdikbud" di kolom terakhir cuma dipakai UI admin untuk menyarankan "aktifkan grup ini kalau institusi Anda lapor ke Kemdikbud" — bukan mengunci pertanyaan itu jadi Core untuk sebagian institusi.

## 3. Gap yang Teridentifikasi (Belum Tercakup Tabel Riset)

Beberapa pertanyaan yang lazim jadi indikator utama IKU PTN & instrumen BAN-PT/LAM tapi **tidak** muncul di tabel riset yang sudah dikumpulkan — kemungkinan karena tabel riset belum mencakup seluruh instrumen, bukan berarti tidak dibutuhkan:

| Indikator yang diduga dibutuhkan | Alasan | Status |
|---|---|---|
| Besaran penghasilan/gaji pertama | Komponen utama definisi "pekerjaan layak" di IKU PTN #1 | ⚠️ Perlu verifikasi ke dokumen resmi |
| Lama waktu tunggu mendapat pekerjaan pertama (dalam bulan, sejak lulus) | Indikator objektif keberhasilan transisi kerja (lih. Schomburg slide 19) | ⚠️ Perlu verifikasi |
| Skala/jenis instansi tempat bekerja (nasional/multinasional/BUMN/startup, dsb) | Sering diminta BAN-PT/LAM untuk profil lulusan | ⚠️ Perlu verifikasi |
| Provinsi/lokasi tempat bekerja | Relevan untuk pemetaan sebaran lulusan | ⚠️ Perlu verifikasi |

**Rekomendasi:** sebelum dijadikan Core, cek ke dokumen resmi Buku Panduan Tracer Study Kemdikbud (indikator IKU 1) dan instrumen LAM yang relevan dengan rumpun ilmu institusi.

## 4. Optional Enrichment — dari Kerangka Schomburg (Subjective Indicators)

Tidak diwajibkan regulator manapun, tapi menurut Schomburg (slide 19) penting untuk konsep *multidimensional professional success* — cocok jadi Optional bawaan platform (bukan Specific institusi), karena redaksinya bisa distandarkan agar tetap bisa dibandingkan antar-institusi yang mengaktifkannya:

| Pertanyaan (draf) | Kategori | Tier |
|---|---|---|
| Seberapa besar pekerjaan Anda saat ini sesuai dengan bidang pendidikan Anda? (persepsi, skala Likert) | Professional success — subjektif | 🔘 Optional (enrichment) |
| Seberapa besar kompetensi yang Anda peroleh selama kuliah dimanfaatkan dalam pekerjaan? | Professional success — subjektif | 🔘 Optional (enrichment) |
| Bagaimana Anda menilai status pekerjaan Anda saat ini (penghasilan, prospek karier)? | Professional success — subjektif | 🔘 Optional (enrichment) |
| Seberapa besar otonomi/kebebasan Anda dalam menjalankan pekerjaan? | Professional success — subjektif | 🔘 Optional (enrichment) |
| Seberapa puas Anda dengan pekerjaan Anda saat ini secara keseluruhan? | Professional success — subjektif | 🔘 Optional (enrichment) |

## 5. Draft untuk Survei Pengguna Lulusan (Employer Survey)

Audiens berbeda dari lulusan (lih. bagian 8.2 dokumen konsep) — dipakai untuk Template "Pengguna Lulusan" yang biasanya dikaitkan ke instrumen kepuasan pengguna lulusan BAN-PT/LAM. Pola 7-item berikut sudah umum dipublikasikan di berbagai panduan akreditasi (skala 4 poin: Sangat Baik / Baik / Cukup / Kurang):

| No | Aspek yang Dinilai | Tier |
|---|---|---|
| 1 | Etika | ✅ Core (dugaan — perlu verifikasi ke instrumen LAM terkait) |
| 2 | Keahlian pada bidang ilmu (kompetensi utama) | ✅ Core (dugaan) |
| 3 | Kemampuan berbahasa asing | ✅ Core (dugaan) |
| 4 | Penggunaan teknologi informasi | ✅ Core (dugaan) |
| 5 | Kemampuan berkomunikasi | ✅ Core (dugaan) |
| 6 | Kemampuan kerja sama tim | ✅ Core (dugaan) |
| 7 | Kemampuan pengembangan diri | ✅ Core (dugaan) |

> ⚠️ Tiap LAM (LAM Teknik, LAMEMBA, LAM Kesehatan, dst) berpotensi punya varian item atau bobot berbeda — bagian ini **wajib dicek ulang** ke dokumen instrumen resmi LAM yang relevan dengan rumpun ilmu institusi sebelum dijadikan Core secara default.

## 6. Ringkasan Tier (Sementara)

**Survei Lulusan** — satu bank, dua tier:

| Tier | Jumlah Item | Isi |
|---|---|---|
| **Core** (berlaku untuk semua institusi, tanpa syarat) | 3 | Status saat ini, Kompetensi A/B, Metode pembelajaran |
| **Optional** — tag: Kemdikbud | 8 | Sumber dana, proses cari kerja (6 item), alasan kerja tidak sesuai |
| **Optional** — tag: perlu verifikasi (gap bagian 3) | 4 | Gaji, waktu tunggu, skala instansi, lokasi kerja |
| **Optional** — tag: enrichment (Schomburg) | 5 | Indikator subjektif keberhasilan kerja |

**Survei Pengguna Lulusan** — audiens berbeda, jadi bank pertanyaan terpisah dari Survei Lulusan (bukan berarti tier terpisah lagi *di dalam* bank ini):

| Tier | Jumlah Item | Isi |
|---|---|---|
| **Core (dugaan, perlu verifikasi ke LAM terkait)** | 7 | 7 aspek kompetensi versi BAN-PT/LAM |

Total Optional untuk Survei Lulusan: 17 item (8 + 4 + 5), semua ada di satu bank yang sama, dibedakan hanya lewat tag filter — bukan tier terpisah.

## 7. Bagaimana Specific Question Berinteraksi dengan Core & Optional (Panduan, Bukan Seed Data)

Berbeda dari bagian 2–5 (yang berisi seed data bank bersama), bagian ini **bukan daftar pertanyaan baku** — Specific question ditulis bebas oleh masing-masing institusi. Yang didokumentasikan di sini adalah **pola pemakaiannya**, mengikuti alur dinamis Core→Optional→Specific yang dijelaskan di [Konsep bagian 1.1, 2.1, dan 7.4-7.5](Konsep%20Pertanyaan%20Core-Optional-Specific%20untuk%20Template%20Quisioner.md).

### 7.1 Prinsip Penyisipan

- Specific question **tidak otomatis ditumpuk di akhir** kuisioner — admin menyisipkannya di posisi manapun, termasuk di antara pertanyaan Core (lihat urutan contoh "Andi" di Konsep 7.4.1: Core → Specific → Optional×6 → Specific → Core → Core).
- Specific question boleh punya `depends_on` yang merujuk ke pertanyaan **Core atau Optional** dari bagian 2–5 dokumen ini — bukan cuma sesama Specific.
- `variable_code` Specific selalu diberi prefix scope institusi (mis. `UNVX_...`) supaya tidak pernah tercampur dengan `variable_code` bank bersama di tabel bagian 2 & 4.

### 7.2 Contoh Pola (Ilustratif, Bukan Wajib Diikuti)

| Contoh Specific Question | `depends_on` (merujuk bank bersama) | Kategori Penempatan |
|---|---|---|
| "Apakah Anda tertarik bergabung dengan Ikatan Alumni [Institusi]?" | Tidak ada (selalu muncul setelah gate Q1) | Disisipkan awal, dekat Core Q1 |
| "Apakah info lowongan tersebut Anda dapat dari Career Center [Institusi]?" | Q7 (Jumlah lamaran, Optional) > 0 | Disisipkan setelah grup Optional "Proses Pencarian Kerja" |
| "Seberapa besar peran [nama mata kuliah unggulan institusi] terhadap pekerjaan Anda saat ini?" | Q3 (Kompetensi A/B, Core) — mis. hanya muncul kalau nilai kompetensi tertentu rendah | Disisipkan dekat Core Q3/Q4 |
| "Bersediakah Anda menjadi narasumber webinar karier untuk mahasiswa [Institusi]?" | Tidak ada | Biasanya di akhir, tapi tetap opsional posisinya |

Pola di atas menegaskan: **Specific paling berguna ketika dikaitkan (`depends_on`) ke jawaban Core/Optional**, bukan berdiri sendiri — karena begitu institusi mengaitkannya ke jawaban tertentu, pertanyaan spesifik itu jadi terasa relevan/personal buat responden, bukan sekadar tempelan generik di akhir formulir.

## 8. Langkah Verifikasi Selanjutnya

- [ ] Validasi ke dokumen resmi terbaru Buku Panduan Tracer Study Kemdikbud, khususnya definisi indikator IKU 1 (gaji, waktu tunggu).
- [ ] Validasi ke instrumen resmi LAM yang relevan (bisa berbeda per rumpun ilmu) untuk 7-item Pengguna Lulusan di bagian 5.
- [ ] Lengkapi tabel riset KEMDIKTI vs KEMENKES kalau ternyata ada pertanyaan lain di luar yang sudah dicatat (tabel riset saat ini kemungkinan baru mencakup sebagian instrumen).
- [ ] Diskusi dengan tim produk: apakah gap di bagian 3 (gaji, waktu tunggu, dst) sudah tersedia sebagai field lain di KarirLink yang belum masuk kuisioner.
- [ ] Setelah tervalidasi, konversi tabel-tabel di atas jadi seed data aktual (`variable_code`, `answer_type`, `tier`, `regulator_tags`) sesuai skema di dokumen konsep bagian 6.1.
- [ ] Kumpulkan contoh Specific question nyata dari beberapa institusi pilot untuk memperkaya pola di bagian 7.2 (saat ini masih ilustratif).
