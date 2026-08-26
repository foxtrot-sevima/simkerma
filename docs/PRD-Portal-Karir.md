# PRD - Portal Karir Karirlink

---

## A. Header Dokumen

| Atribut | Nilai |
|---------|-------|
| **Nama Produk** | Portal Karir - Karirlink |
| **Versi Dokumen** | 1.0 |
| **Tanggal Update** | 26 Mei 2026 |
| **Author / Owner** | Tim Product Sevima |
| **Status** | Draft |

### Changelog

| Versi | Tanggal | Perubahan | Author |
|-------|---------|-----------|--------|
| 1.0 | 26 Mei 2026 | Initial draft - Dokumentasi existing + Fitur Monitoring Lamaran Alumni | Tim Product |

---

## B. Overview Produk

### Problem Statement

Perguruan Tinggi (PT) membutuhkan platform yang menghubungkan alumni dengan dunia kerja. Saat ini:

1. **Tidak ada visibilitas terhadap karir alumni** - PT tidak tahu berapa banyak alumni yang aktif melamar pekerjaan melalui platform
2. **Sulit mengukur efektivitas kerja sama** - PT tidak bisa memonitor apakah perusahaan mitra benar-benar merekrut alumni mereka
3. **Tidak ada data untuk pengambilan keputusan** - PT tidak memiliki insight tentang perusahaan mana yang paling diminati alumni atau posisi apa yang paling banyak dilamar
4. **Komunikasi satu arah** - PT hanya bisa memposting informasi tanpa mengetahui dampaknya terhadap employability alumni

### Tujuan Produk (Goals & Success Metrics)

**Goals:**
1. Menyediakan beranda terpusat bagi Admin PT untuk mengelola aktivitas portal karir
2. Memfasilitasi kerja sama antara PT dan perusahaan mitra
3. Memberikan visibilitas terhadap aktivitas lamaran alumni ke perusahaan di Karirlink
4. Menyediakan data insight untuk pengambilan keputusan terkait career services

**Success Metrics:**

| Metric | Target |
|--------|--------|
| Jumlah PT aktif menggunakan Portal Karir | > 300 PT |
| Jumlah perusahaan mitra per PT | > 10 perusahaan |
| Tingkat engagement alumni di Karirlink | > 40% alumni terdaftar aktif |
| Admin PT mengakses monitoring lamaran | > 3x per minggu |

### Scope

**In Scope:**
- Beranda Portal Karir (profil universitas, feed, share content)
- Manajemen Perusahaan Mitra
- Monitoring Aktivitas Lamaran Alumni (NEW FEATURE)
- Buat Lowongan & Event

**Out of Scope (untuk versi ini):**
- Fitur chat/messaging antara PT dan perusahaan
- Rekomendasi pekerjaan berbasis AI
- Integrasi dengan job portal eksternal (LinkedIn, JobStreet, dll)
- Fitur alumni networking/community

---

## C. System Architecture & User Roles

### Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Admin PT   │  │   Alumni    │  │ Perusahaan  │              │
│  │ Portal Karir│  │  Job Seeker │  │  Recruiter  │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
└─────────┼────────────────┼────────────────┼─────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY                                 │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                        BACKEND                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Portal    │  │  Lamaran    │  │   Mitra     │              │
│  │   Service   │  │   Service   │  │   Service   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Lowongan   │  │    Auth     │  │Notification │              │
│  │   Service   │  │   Service   │  │   Service   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DATABASE                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  PostgreSQL │  │    Redis    │  │     S3      │              │
│  │  (Primary)  │  │   (Cache)   │  │  (Storage)  │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   THIRD-PARTY INTEGRATIONS                       │
│  ┌─────────────┐  ┌─────────────┐                               │
│  │   Sevima    │  │    SMTP     │                               │
│  │   Siakad    │  │   (Email)   │                               │
│  └─────────────┘  └─────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```

### User Roles

| Role | Deskripsi | Akses / Kapabilitas |
|------|-----------|---------------------|
| **Admin PT** | Administrator dari Perguruan Tinggi yang mengelola portal karir | - Kelola profil universitas<br>- Buat lowongan & event<br>- Kelola perusahaan mitra<br>- Monitoring lamaran alumni<br>- Posting konten di feed |
| **Alumni** | Lulusan PT yang mencari pekerjaan | - Melamar lowongan<br>- Follow perusahaan<br>- Lihat event |
| **Perusahaan** | Recruiter dari perusahaan mitra | - Posting lowongan<br>- Review lamaran<br>- Kelola profil perusahaan |
| **Super Admin Sevima** | Administrator sistem dari Sevima | - Kelola semua PT<br>- Konfigurasi sistem<br>- Monitoring platform |

---

## D. Daftar Fitur (Feature Inventory)

| ID Fitur | Nama Fitur | Status | Tipe | Versi | Prioritas |
|----------|------------|--------|------|-------|-----------|
| PK-001 | Beranda Portal Karir | Existing | Dokumentasi | 1.0 | High |
| PK-002 | Monitoring Aktivitas Lamaran Alumni | New Feature | Request Unpas | 1.0 | High |
| PK-003 | Perusahaan Mitra | Existing | Dokumentasi | 1.0 | Medium |
| PK-004 | Buat Lowongan | Existing | Dokumentasi | 1.1 | Medium |
| PK-005 | Buat Event | Existing | Dokumentasi | 1.1 | Medium |
| PK-006 | Kerja Sama | Existing | Dokumentasi | 1.1 | Low |

---

## FITUR PK-001: Beranda Portal Karir

**Status:** Existing (Dokumentasi)

### 1. Narasi Bisnis

**Latar Belakang:**

Beranda Portal Karir adalah halaman utama yang dilihat Admin PT saat mengakses modul Portal Karir di Karirlink. Halaman ini berfungsi sebagai hub informasi yang menampilkan profil universitas, ringkasan aktivitas, dan feed konten.

Berdasarkan observasi sistem existing:
- Admin PT dapat melihat profil universitas (jumlah pengikut, alumni terdaftar)
- Admin PT dapat membagikan konten (lowongan, event) ke feed
- Admin PT dapat melihat daftar perusahaan mitra dan statusnya
- Admin PT dapat melihat ringkasan aktivitas lamaran alumni

**Hipotesis / Expected Outcome:**
- Admin PT mendapatkan overview lengkap tentang portal karir dalam satu halaman
- Admin PT dapat dengan cepat mengakses fitur-fitur utama dari beranda

**Dampak jika tidak dibuat:**
- Admin PT tidak memiliki entry point yang jelas untuk mengelola portal karir
- Informasi tersebar di berbagai halaman tanpa ringkasan terpusat

### 2. Key Data Dictionary

#### A. Entitas: Profil Universitas

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Nama Universitas | `university_name` | String | Ya | Dari data PT di Siakad |
| Lokasi | `location` | String | Ya | Format: "Kota, Provinsi" |
| Logo | `logo_url` | String (URL) | Ya | Format gambar: PNG/JPG, max 2MB |
| Jumlah Pengikut | `followers_count` | Integer | Ya | Auto-calculated, real-time |
| Jumlah Diikuti | `following_count` | Integer | Ya | Auto-calculated, real-time |
| Alumni Terdaftar | `registered_alumni_count` | Integer | Ya | Jumlah alumni yang terdaftar di Karirlink |

#### B. Entitas: Perusahaan Mitra (di Beranda)

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Nama Perusahaan | `company_name` | String | Ya | Dari data perusahaan di Karirlink |
| Status Kerja Sama | `partnership_status` | Enum | Ya | Values: `approved`, `pending`, `rejected` |
| Tanggal Bergabung | `joined_at` | DateTime | Tidak | Null jika masih pending |

#### C. Entitas: Feed Post

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Konten | `content` | Text | Ya | Max 2000 karakter |
| Tipe Post | `post_type` | Enum | Ya | Values: `text`, `lowongan`, `event` |
| Tanggal Posting | `posted_at` | DateTime | Ya | Auto-generated |
| Author | `author_id` | UUID | Ya | Foreign key ke tabel User |

### 3. User Stories, Acceptance Criteria & Gherkin Scenarios

---

**US-1:** Sebagai **Admin PT**, saya ingin **melihat profil universitas saya di portal karir**, agar **saya mengetahui jumlah pengikut dan alumni yang terdaftar di Karirlink**.

**AC PK-001-01: Profil universitas tampil di beranda**

```gherkin
Scenario PK-001-01.1 Positive: Profil universitas tampil lengkap
  Given Admin PT sudah login ke Portal Karir
  When Admin berada di halaman Beranda
  Then sistem menampilkan card profil universitas di kolom kiri
  And card menampilkan logo, nama universitas, dan lokasi
  And card menampilkan jumlah pengikut dan jumlah diikuti
  And card menampilkan jumlah alumni terdaftar di Karirlink
```

---

**US-2:** Sebagai **Admin PT**, saya ingin **melihat ringkasan aktivitas lamaran alumni**, agar **saya dapat memantau seberapa aktif alumni melamar pekerjaan tanpa masuk ke halaman detail**.

**US-3:** Sebagai **Admin PT**, saya ingin **melihat top 5 perusahaan tujuan alumni**, agar **saya mengetahui perusahaan mana yang paling diminati alumni saya**.

**AC PK-001-02: Ringkasan aktivitas lamaran alumni tampil**

```gherkin
Scenario PK-001-02.1 Positive: Ringkasan lamaran tampil
  Given Admin PT sudah login ke Portal Karir
  And terdapat data lamaran alumni bulan ini
  When Admin berada di halaman Beranda
  Then sistem menampilkan card "Aktivitas Lamaran Alumni"
  And card menampilkan total lamaran bulan ini
  And card menampilkan jumlah alumni yang melamar
  And card menampilkan breakdown status: Diterima, Dalam Proses, Ditolak
  And card menampilkan Top 5 Perusahaan Tujuan beserta jumlah lamaran
  And terdapat link "Lihat Detail" yang mengarah ke halaman detail
```

```gherkin
Scenario PK-001-02.2 Negative: Belum ada data lamaran
  Given Admin PT sudah login ke Portal Karir
  And tidak ada data lamaran alumni bulan ini
  When Admin berada di halaman Beranda
  Then card "Aktivitas Lamaran Alumni" menampilkan angka 0 untuk semua metrik
  And Top 5 Perusahaan Tujuan menampilkan pesan "Belum ada data"
```

---

**US-4:** Sebagai **Admin PT**, saya ingin **melihat daftar perusahaan mitra beserta statusnya**, agar **saya mengetahui perusahaan mana yang sudah bergabung dan mana yang masih menunggu persetujuan**.

**AC PK-001-03: Daftar perusahaan mitra tampil**

```gherkin
Scenario PK-001-03.1 Positive: Daftar mitra tampil
  Given Admin PT sudah login ke Portal Karir
  And terdapat perusahaan mitra yang terdaftar
  When Admin berada di halaman Beranda
  Then sistem menampilkan card "Perusahaan Mitra"
  And setiap item menampilkan nama perusahaan dan status kerja sama
  And status "Berhasil Bergabung" ditampilkan dengan warna hijau
  And status "Menunggu Persetujuan" ditampilkan dengan warna kuning/orange
  And terdapat link "Lihat Semua" untuk melihat daftar lengkap
```

---

**US-5:** Sebagai **Admin PT**, saya ingin **membagikan lowongan atau event di feed**, agar **alumni dapat melihat informasi terbaru dari universitas**.

**AC PK-001-04: Admin dapat membagikan konten di feed**

```gherkin
Scenario PK-001-04.1 Positive: Buat lowongan dari beranda
  Given Admin PT sudah login ke Portal Karir
  When Admin mengklik tombol "Buat Lowongan"
  Then sistem mengarahkan ke halaman pembuatan lowongan
```

```gherkin
Scenario PK-001-04.2 Positive: Buat event dari beranda
  Given Admin PT sudah login ke Portal Karir
  When Admin mengklik tombol "Buat Event"
  Then sistem mengarahkan ke halaman pembuatan event
```

### 4. Open Questions / Dependencies

- [ ] **Q1:** Apakah feed post dari Admin PT juga muncul di timeline alumni?
- [ ] **Q2:** Apakah ada limit jumlah perusahaan mitra yang ditampilkan di beranda?
- [ ] **Q3:** Bagaimana mekanisme "Diikuti" dari sisi universitas? Apakah universitas bisa follow perusahaan?

---

## FITUR PK-002: Monitoring Aktivitas Lamaran Alumni

**Status:** New Feature (Request dari Universitas Pasundan)

### 1. Narasi Bisnis

**Latar Belakang:**

Fitur ini merupakan **new feature request** dari Universitas Pasundan. Sebagai Admin PT, mereka ingin dapat memonitor jumlah lulusan yang melamar ke perusahaan yang berada di naungan Karirlink Sevima.

Saat ini Admin PT tidak memiliki visibilitas terhadap:
- Berapa banyak alumni yang aktif melamar pekerjaan
- Perusahaan mana yang paling diminati alumni
- Status lamaran alumni (diterima/proses/ditolak)
- Tren lamaran dari waktu ke waktu

Data ini penting untuk:
- Mengukur efektivitas career services universitas
- Menentukan perusahaan mana yang perlu diajak kerja sama
- Membuat laporan employability lulusan
- Memberikan insight untuk pengembangan kurikulum

**Hipotesis / Expected Outcome:**
- Admin PT dapat memantau aktivitas lamaran alumni secara real-time
- Admin PT dapat mengidentifikasi tren dan pola lamaran
- Data monitoring dapat digunakan untuk laporan ke pimpinan universitas
- Meningkatkan engagement Admin PT dengan platform Karirlink

**Dampak jika tidak dibuat:**
- PT tidak memiliki data tentang employability alumni di platform Karirlink
- PT tidak bisa mengukur ROI dari kerja sama dengan perusahaan mitra
- PT kehilangan insight untuk pengembangan career services

### 2. Key Data Dictionary

#### A. Entitas: Lamaran Alumni

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| ID Lamaran | `application_id` | UUID | Ya | Primary key |
| ID Alumni | `alumni_id` | UUID | Ya | Foreign key ke tabel Alumni |
| Nama Alumni | `alumni_name` | String | Ya | Dari data alumni |
| NIM | `nim` | String | Ya | Dari data alumni |
| Program Studi | `program_studi` | String | Ya | Dari data alumni |
| ID Perusahaan | `company_id` | UUID | Ya | Foreign key ke tabel Perusahaan |
| Nama Perusahaan | `company_name` | String | Ya | Dari data perusahaan |
| Posisi yang Dilamar | `position` | String | Ya | Dari data lowongan |
| Tanggal Melamar | `applied_at` | DateTime | Ya | Auto-generated saat alumni submit lamaran |
| Status Lamaran | `status` | Enum | Ya | Values: `accepted`, `in_process`, `rejected` |
| ID Perguruan Tinggi | `pt_id` | UUID | Ya | Foreign key ke tabel PT (untuk filtering) |

#### B. Filter & Search (Halaman Detail)

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Periode | `period` | String | Ya | Format: "YYYY-MM", Default: bulan berjalan |
| Program Studi | `prodi_filter` | String | Tidak | Null = Semua Program Studi |
| Status Lamaran | `status_filter` | Enum | Tidak | Values: `all`, `accepted`, `in_process`, `rejected`. Default: `all` |
| Perusahaan | `company_filter` | UUID | Tidak | Null = Semua Perusahaan |
| Search | `search_query` | String | Tidak | Pencarian berdasarkan nama alumni atau nama perusahaan |
| Page Number | `page` | Integer | Ya | Default: 1, Min: 1 |
| Page Size | `per_page` | Integer | Ya | Default: 10, Max: 50 |

#### C. Summary Metrics

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Total Lamaran | `total_applications` | Integer | Ya | Count semua lamaran sesuai filter |
| Alumni Melamar | `unique_alumni_count` | Integer | Ya | Count distinct alumni_id sesuai filter |
| Diterima | `accepted_count` | Integer | Ya | Count lamaran dengan status `accepted` |
| Dalam Proses | `in_process_count` | Integer | Ya | Count lamaran dengan status `in_process` |
| Ditolak | `rejected_count` | Integer | Ya | Count lamaran dengan status `rejected` |

#### D. Chart: Tren Lamaran per Bulan

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Periode Chart | `chart_period` | String | Ya | 6 bulan terakhir dari periode yang dipilih |
| Data per Bulan | `monthly_data[]` | Array | Ya | Berisi: bulan, total, accepted, in_process, rejected |

#### E. Chart: Top 5 Perusahaan Tujuan

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Ranking | `rank` | Integer | Ya | 1-5, berdasarkan jumlah lamaran terbanyak |
| Nama Perusahaan | `company_name` | String | Ya | Dari data perusahaan |
| Jumlah Lamaran | `application_count` | Integer | Ya | Count lamaran ke perusahaan tersebut sesuai filter |

#### F. Ekspor Data

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Format Ekspor | `export_format` | Enum | Ya | Values: `xlsx`, `csv` |
| Data yang Diekspor | - | - | Ya | Semua kolom tabel sesuai filter yang aktif |

### 3. User Stories, Acceptance Criteria & Gherkin Scenarios

---

**US-1:** Sebagai **Admin PT**, saya ingin **melihat total lamaran alumni bulan ini**, agar **saya mengetahui seberapa aktif alumni melamar pekerjaan di Karirlink**.

**US-2:** Sebagai **Admin PT**, saya ingin **melihat jumlah alumni unik yang melamar**, agar **saya mengetahui berapa banyak alumni yang aktif menggunakan platform**.

**US-3:** Sebagai **Admin PT**, saya ingin **melihat breakdown status lamaran (Diterima, Dalam Proses, Ditolak)**, agar **saya mengetahui tingkat keberhasilan alumni**.

**US-4:** Sebagai **Admin PT**, saya ingin **melihat top 5 perusahaan tujuan alumni**, agar **saya mengetahui perusahaan mana yang paling diminati dan bisa memprioritaskan kerja sama**.

**AC PK-002-01: Card Aktivitas Lamaran Alumni tampil di Beranda**

```gherkin
Scenario PK-002-01.1 Positive: Card tampil dengan data lengkap
  Given Admin PT sudah login ke Portal Karir
  And terdapat data lamaran alumni bulan ini
  When Admin berada di halaman Beranda
  Then sistem menampilkan card "Aktivitas Lamaran Alumni" di kolom kiri
       (antara Profil Universitas dan Perusahaan Mitra)
  And card menampilkan total lamaran bulan ini (angka besar, prominent)
  And card menampilkan jumlah alumni yang melamar (dengan icon people)
  And card menampilkan grid 3 kolom status:
      | Diterima     | background hijau  | angka hijau tua  |
      | Dalam Proses | background kuning | angka kuning tua |
      | Ditolak      | background merah  | angka merah tua  |
  And card menampilkan Top 5 Perusahaan Tujuan:
      | Ranking (badge bulat biru) | Nama Perusahaan | Jumlah (biru bold) |
  And terdapat link "Lihat Detail" mengarah ke halaman detail
```

```gherkin
Scenario PK-002-01.2 Negative: Belum ada data lamaran bulan ini
  Given Admin PT sudah login ke Portal Karir
  And tidak ada data lamaran alumni bulan ini
  When Admin berada di halaman Beranda
  Then card "Aktivitas Lamaran Alumni" tetap tampil
  And total lamaran menampilkan angka 0
  And alumni melamar menampilkan angka 0
  And semua status (Diterima, Dalam Proses, Ditolak) menampilkan 0
  And Top 5 Perusahaan menampilkan pesan "Belum ada data"
```

---

**US-5:** Sebagai **Admin PT**, saya ingin **memfilter data lamaran berdasarkan periode**, agar **saya dapat melihat data untuk bulan atau rentang waktu tertentu**.

**US-6:** Sebagai **Admin PT**, saya ingin **memfilter data lamaran berdasarkan program studi**, agar **saya dapat melihat performa lamaran per jurusan**.

**US-7:** Sebagai **Admin PT**, saya ingin **memfilter data lamaran berdasarkan status**, agar **saya dapat fokus pada lamaran yang diterima atau yang masih dalam proses**.

**US-8:** Sebagai **Admin PT**, saya ingin **memfilter data lamaran berdasarkan perusahaan**, agar **saya dapat melihat berapa banyak alumni yang melamar ke perusahaan tertentu**.

**AC PK-002-02: Halaman detail monitoring tampil lengkap**

```gherkin
Scenario PK-002-02.1 Positive: Halaman detail tampil
  Given Admin PT sudah login ke Portal Karir
  When Admin mengakses halaman "Aktivitas Lamaran Alumni"
  Then sistem menampilkan judul halaman dan deskripsi
  And sistem menampilkan section filter (Periode, Program Studi, Status, Perusahaan)
  And sistem menampilkan 5 summary cards (Total Lamaran, Alumni Melamar, Diterima, Dalam Proses, Ditolak)
  And sistem menampilkan chart "Tren Lamaran per Bulan" (6 bulan terakhir)
  And sistem menampilkan chart "Top 5 Perusahaan Tujuan"
  And sistem menampilkan tabel "Daftar Lamaran Alumni" dengan pagination
```

**AC PK-002-03: Admin dapat memfilter data lamaran**

```gherkin
Scenario PK-002-03.1 Positive: Filter berdasarkan periode
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin memilih periode "April 2026" dari dropdown Periode
  And Admin mengklik tombol "Terapkan Filter"
  Then semua data (summary cards, chart, tabel) diperbarui sesuai periode April 2026
```

```gherkin
Scenario PK-002-03.2 Positive: Filter berdasarkan program studi
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin memilih "S1 - Teknik Informatika" dari dropdown Program Studi
  And Admin mengklik tombol "Terapkan Filter"
  Then semua data hanya menampilkan lamaran dari alumni Teknik Informatika
```

```gherkin
Scenario PK-002-03.3 Positive: Filter berdasarkan status lamaran
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin memilih "Diterima" dari dropdown Status Lamaran
  And Admin mengklik tombol "Terapkan Filter"
  Then tabel hanya menampilkan lamaran dengan status "Diterima"
```

```gherkin
Scenario PK-002-03.4 Positive: Filter berdasarkan perusahaan
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin memilih "PT Telkom Indonesia" dari dropdown Perusahaan
  And Admin mengklik tombol "Terapkan Filter"
  Then semua data hanya menampilkan lamaran ke PT Telkom Indonesia
```

```gherkin
Scenario PK-002-03.5 Positive: Reset filter
  Given Admin PT berada di halaman detail monitoring lamaran
  And terdapat filter yang aktif
  When Admin mengklik tombol "Reset"
  Then semua filter kembali ke default (bulan berjalan, semua prodi, semua status, semua perusahaan)
  And data diperbarui sesuai filter default
```

```gherkin
Scenario PK-002-03.6 Positive: Kombinasi multiple filter
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin memilih periode "Mei 2026"
  And Admin memilih program studi "S1 - Teknik Informatika"
  And Admin memilih status "Dalam Proses"
  And Admin mengklik tombol "Terapkan Filter"
  Then data menampilkan lamaran alumni Teknik Informatika yang berstatus "Dalam Proses" di bulan Mei 2026
```

---

**US-9:** Sebagai **Admin PT**, saya ingin **melihat tren lamaran per bulan dalam bentuk chart**, agar **saya dapat mengidentifikasi pola dan tren dari waktu ke waktu**.

**AC PK-002-04: Chart tren lamaran per bulan tampil**

```gherkin
Scenario PK-002-04.1 Positive: Chart tren tampil
  Given Admin PT berada di halaman detail monitoring lamaran
  Then sistem menampilkan bar chart "Tren Lamaran per Bulan"
  And chart menampilkan data 6 bulan terakhir
  And setiap bar menampilkan breakdown warna: Diterima (hijau), Dalam Proses (kuning), Ditolak (merah)
  And terdapat legend yang menjelaskan warna
```

---

**US-10:** Sebagai **Admin PT**, saya ingin **melihat top 5 perusahaan tujuan alumni**, agar **saya mengetahui perusahaan mana yang paling diminati dan bisa memprioritaskan kerja sama**.

**AC PK-002-05: Top 5 perusahaan tujuan tampil di halaman detail**

```gherkin
Scenario PK-002-05.1 Positive: Top 5 perusahaan tampil
  Given Admin PT berada di halaman detail monitoring lamaran
  And terdapat data lamaran ke berbagai perusahaan
  Then sistem menampilkan "Top 5 Perusahaan Tujuan"
  And setiap item menampilkan ranking, nama perusahaan, progress bar, dan jumlah lamaran
  And urutan berdasarkan jumlah lamaran terbanyak
```

```gherkin
Scenario PK-002-05.2 Negative: Kurang dari 5 perusahaan
  Given Admin PT berada di halaman detail monitoring lamaran
  And hanya terdapat lamaran ke 3 perusahaan
  Then sistem menampilkan 3 perusahaan saja (tidak memaksa 5)
```

---

**US-11:** Sebagai **Admin PT**, saya ingin **melihat daftar detail lamaran alumni**, agar **saya dapat melihat informasi spesifik per lamaran (nama, prodi, perusahaan, posisi, tanggal, status)**.

**AC PK-002-06: Tabel daftar lamaran tampil**

```gherkin
Scenario PK-002-06.1 Positive: Tabel lamaran tampil
  Given Admin PT berada di halaman detail monitoring lamaran
  Then sistem menampilkan tabel dengan kolom: No, Nama Alumni (+ NIM), Program Studi, Perusahaan Tujuan, Posisi, Tanggal Melamar, Status
  And data diurutkan berdasarkan tanggal melamar terbaru
  And status ditampilkan dengan badge berwarna (Diterima=hijau, Dalam Proses=kuning, Ditolak=merah)
  And tabel menampilkan 10 data per halaman
```

```gherkin
Scenario PK-002-06.2 Positive: Pagination tabel
  Given Admin PT berada di halaman detail monitoring lamaran
  And terdapat lebih dari 10 data lamaran
  When Admin mengklik halaman 2 di pagination
  Then tabel menampilkan data halaman 2 (data ke-11 sampai ke-20)
  And informasi "Menampilkan 11-20 dari X data" diperbarui
```

---

**US-12:** Sebagai **Admin PT**, saya ingin **mencari lamaran berdasarkan nama alumni atau perusahaan**, agar **saya dapat dengan cepat menemukan data tertentu**.

**AC PK-002-07: Admin dapat mencari data lamaran**

```gherkin
Scenario PK-002-07.1 Positive: Pencarian berdasarkan nama alumni
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin mengetik "Ahmad" di search box
  Then tabel hanya menampilkan lamaran dari alumni yang namanya mengandung "Ahmad"
```

```gherkin
Scenario PK-002-07.2 Positive: Pencarian berdasarkan nama perusahaan
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin mengetik "Telkom" di search box
  Then tabel hanya menampilkan lamaran ke perusahaan yang namanya mengandung "Telkom"
```

```gherkin
Scenario PK-002-07.3 Negative: Pencarian tidak menemukan hasil
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin mengetik "XYZ123" di search box
  Then tabel menampilkan pesan "Tidak ada data yang ditemukan"
  And pagination disembunyikan
```

---

**US-13:** Sebagai **Admin PT**, saya ingin **mengekspor data lamaran**, agar **saya dapat membuat laporan untuk pimpinan universitas**.

**AC PK-002-08: Admin dapat mengekspor data lamaran**

```gherkin
Scenario PK-002-08.1 Positive: Ekspor data berhasil
  Given Admin PT berada di halaman detail monitoring lamaran
  And terdapat data lamaran yang ditampilkan
  When Admin mengklik tombol "Ekspor"
  Then sistem mengunduh file berisi data lamaran sesuai filter yang aktif
  And file berformat Excel (.xlsx)
  And file berisi semua kolom yang ada di tabel
```

```gherkin
Scenario PK-002-08.2 Negative: Ekspor tanpa data
  Given Admin PT berada di halaman detail monitoring lamaran
  And tidak ada data lamaran (filter menghasilkan 0 data)
  When Admin mengklik tombol "Ekspor"
  Then sistem menampilkan pesan "Tidak ada data untuk diekspor"
```

---

**AC PK-002-09: Admin dapat kembali ke beranda**

```gherkin
Scenario PK-002-09.1 Positive: Navigasi kembali
  Given Admin PT berada di halaman detail monitoring lamaran
  When Admin mengklik link "Kembali ke Beranda"
  Then sistem mengarahkan kembali ke halaman Beranda Portal Karir
```

### 4. Open Questions / Dependencies

- [ ] **Q1:** Apakah data lamaran yang ditampilkan hanya dari alumni yang terdaftar di PT tersebut, atau termasuk alumni yang belum terverifikasi?
- [ ] **Q2:** Apakah Admin PT bisa melihat detail lamaran individual (CV, surat lamaran) atau hanya summary?
- [ ] **Q3:** Berapa lama data lamaran disimpan? Apakah ada retention policy?
- [ ] **Q4:** Apakah perlu notifikasi ke Admin PT ketika ada alumni yang diterima kerja?
- [ ] **Q5:** Apakah data "Ditolak" perlu di-breakdown lebih lanjut (alasan penolakan)?
- [ ] **Q6:** Apakah perlu fitur perbandingan antar periode (month-over-month growth)?
- [ ] **Q7:** Bagaimana handling jika alumni melamar ke perusahaan yang bukan mitra PT? Apakah tetap masuk monitoring?
- [ ] **Q8:** Apakah perusahaan perlu consent untuk data lamaran mereka ditampilkan ke PT?

---

## FITUR PK-003: Perusahaan Mitra

**Status:** Existing (Dokumentasi)

### 1. Narasi Bisnis

**Latar Belakang:**

Admin PT dapat melihat dan mengelola daftar perusahaan yang telah menjalin kerja sama dengan universitas melalui platform Karirlink. Fitur ini membantu PT memantau status kerja sama dan mengelola relasi dengan perusahaan.

**Hipotesis / Expected Outcome:**
- Admin PT dapat dengan mudah melihat status kerja sama dengan perusahaan
- Proses onboarding perusahaan mitra menjadi lebih terstruktur

**Dampak jika tidak dibuat:**
- PT tidak memiliki visibilitas terhadap status kerja sama
- Proses manajemen mitra menjadi manual dan tidak terdokumentasi

### 2. Key Data Dictionary

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Nama Perusahaan | `company_name` | String | Ya | Dari data perusahaan |
| Status | `status` | Enum | Ya | Values: `approved`, `pending`, `rejected` |
| Tanggal Request | `requested_at` | DateTime | Ya | Auto-generated |
| Tanggal Approved | `approved_at` | DateTime | Tidak | Null jika belum approved |

### 3. User Stories, Acceptance Criteria & Gherkin Scenarios

---

**US-1:** Sebagai **Admin PT**, saya ingin **melihat daftar semua perusahaan mitra**, agar **saya mengetahui perusahaan mana saja yang sudah bekerja sama**.

**US-2:** Sebagai **Admin PT**, saya ingin **melihat status kerja sama setiap perusahaan**, agar **saya mengetahui mana yang sudah aktif dan mana yang masih menunggu persetujuan**.

**AC PK-003-01: Daftar perusahaan mitra tampil lengkap**

```gherkin
Scenario PK-003-01.1 Positive: Daftar mitra tampil
  Given Admin PT sudah login ke Portal Karir
  When Admin mengakses halaman Perusahaan Mitra (via "Lihat Semua")
  Then sistem menampilkan daftar semua perusahaan mitra
  And setiap item menampilkan nama perusahaan, status, dan tanggal bergabung
  And perusahaan diurutkan berdasarkan status (approved dulu, lalu pending)
```

---

**US-3:** Sebagai **Admin PT**, saya ingin **mengundang perusahaan baru untuk bergabung**, agar **alumni memiliki lebih banyak pilihan lowongan**.

**AC PK-003-02: Admin dapat mengundang perusahaan baru**

```gherkin
Scenario PK-003-02.1 Positive: Undang perusahaan berhasil
  Given Admin PT berada di halaman Perusahaan Mitra
  When Admin mengklik "Undang Perusahaan"
  And Admin mengisi data perusahaan yang diundang
  And Admin mengklik "Kirim Undangan"
  Then sistem mengirim undangan ke perusahaan
  And perusahaan muncul di daftar dengan status "Menunggu Persetujuan"
```

### 4. Open Questions / Dependencies

- [ ] **Q1:** Apakah Admin PT bisa menolak/membatalkan kerja sama yang sudah approved?
- [ ] **Q2:** Apakah ada batasan jumlah perusahaan mitra per PT?
- [ ] **Q3:** Bagaimana flow undangan perusahaan baru? Apakah via email atau link?

---

*Dokumen ini adalah living document dan akan terus diupdate seiring perkembangan fitur.*
