# PRD - Portal Tracer Study Karirlink

---

## A. Header Dokumen

| Atribut | Nilai |
|---------|-------|
| **Nama Produk** | Portal Tracer Study - Karirlink |
| **Versi Dokumen** | 1.0 |
| **Tanggal Update** | 25 Mei 2026 |
| **Author / Owner** | Tim Product Sevima |
| **Status** | Draft |

### Changelog

| Versi | Tanggal | Perubahan | Author |
|-------|---------|-----------|--------|
| 1.0 | 25 Mei 2026 | Initial draft - Fitur Daftar Kuesioner | Tim Product |

---

## B. Overview Produk

### Problem Statement

Perguruan Tinggi (PT) di Indonesia diwajibkan untuk melakukan tracer study terhadap lulusannya sebagai bagian dari akreditasi dan pelaporan ke Kemdikbud. Proses ini seringkali:

1. **Manual dan tidak terstruktur** - Banyak PT masih menggunakan Google Form atau metode manual lainnya
2. **Sulit melacak response rate** - Tidak ada dashboard terpusat untuk monitoring
3. **Format tidak standar** - Setiap PT membuat format sendiri yang tidak sesuai standar Kemdikbud
4. **Kesulitan menjangkau alumni** - Tidak ada sistem distribusi kuesioner yang terintegrasi dengan database alumni

### Tujuan Produk (Goals & Success Metrics)

**Goals:**
1. Menyediakan platform terpusat untuk manajemen kuesioner tracer study
2. Memudahkan PT dalam membuat kuesioner sesuai standar Kemdikbud
3. Mengotomatisasi distribusi kuesioner ke alumni via email
4. Menyediakan dashboard monitoring response rate real-time
5. Memfasilitasi pengumpulan feedback dari pengguna lulusan (employer)

**Success Metrics:**
| Metric | Target |
|--------|--------|
| Response rate kuesioner | > 60% |
| Waktu pembuatan kuesioner | < 30 menit |
| Tingkat kepuasan Admin PT | > 4.0/5.0 |
| Jumlah PT aktif menggunakan | > 500 PT |

### Scope

**In Scope:**
- Manajemen kuesioner (CRUD)
- Template kuesioner standar Kemdikbud
- Template kuesioner Pengguna Lulusan
- Distribusi kuesioner via email
- Monitoring response rate
- Download hasil dalam format laporan
- Kirim ulang kuesioner ke non-responden

**Out of Scope (untuk versi ini):**
- Integrasi dengan PDDIKTI
- Mobile app untuk alumni
- Analitik prediktif
- Multi-bahasa

---

## C. System Architecture & User Roles

### Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Admin PT   │  │   Alumni    │  │  Employer   │              │
│  │  Dashboard  │  │  Form Fill  │  │  Form Fill  │              │
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
│  │  Kuesioner  │  │   Alumni    │  │   Report    │              │
│  │   Service   │  │   Service   │  │   Service   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐                               │
│  │    Email    │  │    Auth     │                               │
│  │   Service   │  │   Service   │                               │
│  └─────────────┘  └─────────────┘                               │
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
│  │    SMTP     │  │   Sevima    │                               │
│  │   (Email)   │  │   Siakad    │                               │
│  └─────────────┘  └─────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```

### User Roles

| Role | Deskripsi | Akses / Kapabilitas |
|------|-----------|---------------------|
| **Admin PT** | Administrator dari Perguruan Tinggi yang mengelola tracer study | - CRUD Kuesioner<br>- Finalisasi & Kirim Kuesioner<br>- Lihat Response<br>- Download Hasil<br>- Kirim Ulang<br>- Reset Hasil |
| **Alumni** | Lulusan PT yang menjadi responden kuesioner | - Mengisi kuesioner tracer study<br>- Melihat status pengisian |
| **Employer / Pengguna Lulusan** | Pimpinan perusahaan tempat alumni bekerja | - Mengisi kuesioner penilaian alumni<br>- Melihat status pengisian |
| **Super Admin Sevima** | Administrator sistem dari Sevima | - Kelola template global<br>- Monitoring semua PT<br>- Konfigurasi sistem |

---

## D. Daftar Fitur (Feature Inventory)

| ID Fitur | Nama Fitur | Status | Versi | Prioritas |
|----------|------------|--------|-------|-----------|
| TS-001 | Daftar Kuesioner | Draft | 1.0 | High |
| TS-002 | Buat Kuesioner Baru | Planned | 1.0 | High |
| TS-003 | Edit Kuesioner | Planned | 1.0 | High |
| TS-004 | Detail Response Kuesioner | Planned | 1.0 | Medium |
| TS-005 | Dashboard Statistik | Planned | 1.1 | Medium |
| TS-006 | Manajemen Alumni | Planned | 1.1 | Medium |

---

## FITUR TS-001: Daftar Kuesioner

### 1. Narasi Bisnis

**Latar Belakang:**
Admin PT membutuhkan halaman utama untuk melihat dan mengelola semua kuesioner tracer study yang telah dibuat. Halaman ini menjadi entry point utama setiap kali Admin login ke Portal Tracer Study.

Berdasarkan observasi sistem existing:
- Kuesioner memiliki 3 tahap lifecycle: Draft → Siap Kirim → Terkirim
- Setiap tahap memiliki aksi yang berbeda
- Admin perlu melihat progress response rate untuk kuesioner yang sudah terkirim

**Hipotesis / Expected Outcome:**
- Admin dapat dengan mudah menemukan dan mengelola kuesioner
- Waktu untuk menemukan kuesioner tertentu < 10 detik
- Admin dapat memahami status kuesioner dengan sekali lihat

**Dampak jika tidak dibuat:**
- Admin kesulitan melacak kuesioner yang sudah dibuat
- Tidak ada visibilitas terhadap lifecycle kuesioner
- Proses manajemen kuesioner menjadi tidak efisien

### 2. User Stories

> Sebagai **Admin PT**, saya ingin **melihat daftar semua kuesioner yang sudah dibuat**, agar **saya dapat mengelola dan memantau status masing-masing kuesioner**.

> Sebagai **Admin PT**, saya ingin **memfilter kuesioner berdasarkan jenis template**, agar **saya dapat dengan cepat menemukan kuesioner tertentu**.

> Sebagai **Admin PT**, saya ingin **mencari kuesioner berdasarkan nama**, agar **saya tidak perlu scroll panjang untuk menemukan kuesioner**.

> Sebagai **Admin PT**, saya ingin **melihat kuesioner berdasarkan status (Draft/Siap Kirim/Terkirim)**, agar **saya dapat fokus pada kuesioner yang perlu ditindaklanjuti**.

> Sebagai **Admin PT**, saya ingin **memfinalisasi kuesioner draft**, agar **kuesioner siap untuk dikirim ke alumni**.

> Sebagai **Admin PT**, saya ingin **mengirim kuesioner ke alumni**, agar **alumni dapat mengisi tracer study**.

> Sebagai **Admin PT**, saya ingin **melihat jumlah responden yang sudah mengisi**, agar **saya dapat memantau response rate**.

> Sebagai **Admin PT**, saya ingin **mendownload hasil kuesioner**, agar **saya dapat membuat laporan tracer study**.

> Sebagai **Admin PT**, saya ingin **mengirim ulang kuesioner ke alumni yang belum mengisi**, agar **response rate meningkat**.

> Sebagai **Admin PT**, saya ingin **menyalin kuesioner yang sudah ada**, agar **saya tidak perlu membuat dari awal untuk periode berikutnya**.

> Sebagai **Admin PT**, saya ingin **menghapus kuesioner yang tidak diperlukan**, agar **daftar kuesioner tetap rapi**.

> Sebagai **Admin PT**, saya ingin **mereset hasil jawaban kuesioner**, agar **saya dapat memulai pengumpulan data dari awal jika diperlukan**.

---

### 3. Key Data Dictionary

#### A. Entitas: Kuesioner

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Nama Kuesioner | `nama_kuesioner` | String | Ya | Min 5 karakter, Max 200 karakter |
| Tanggal Dibuat | `created_at` | DateTime | Ya | Auto-generated saat create |
| Tanggal Dikirim | `sent_at` | DateTime | Tidak | Auto-generated saat kirim |
| Status | `status` | Enum | Ya | Values: `draft`, `ready_to_send`, `sent` |
| Jenis Template | `template_type` | Enum | Ya | Values: `kosong`, `kemdikbud`, `lengkap`, `pengguna_lulusan` |
| ID Perguruan Tinggi | `pt_id` | UUID | Ya | Foreign key ke tabel PT |
| Created By | `created_by` | UUID | Ya | Foreign key ke tabel User |

#### B. Entitas: Template Kuesioner (per Kuesioner)

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| ID Kuesioner | `kuesioner_id` | UUID | Ya | Foreign key ke tabel Kuesioner |
| Nama Template | `template_name` | String | Ya | e.g., "Template Lengkap", "Template Pengguna Lulusan" |
| Tipe Template | `template_type` | Enum | Ya | Values: `lengkap`, `pengguna_lulusan` |
| Total Penerima | `total_recipients` | Integer | Ya | Dihitung dari jumlah alumni/employer yang ditarget |
| Total Responden | `total_responses` | Integer | Ya | Dihitung dari jumlah yang sudah mengisi |

#### C. Filter & Search

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Search Box | `search_query` | String | Tidak | Pencarian berdasarkan nama kuesioner, case-insensitive |
| Filter Jenis Template | `filter_template` | Enum | Tidak | Values: `all`, `kosong`, `kemdikbud`, `lengkap`, `pengguna_lulusan` |
| Tab Status | `filter_status` | Enum | Ya | Values: `draft`, `ready_to_send`, `sent` |
| Page Number | `page` | Integer | Ya | Default: 1, Min: 1 |
| Page Size | `per_page` | Integer | Ya | Default: 10, Max: 50 |

#### D. Modal: Finalisasi Kuesioner

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Checkbox Pengguna Lulusan | `include_employer_survey` | Boolean | Tidak | Default: false. Jika true, akan mengirim kuesioner ke employer juga |

#### E. Modal: Download Hasil

| UI Component / Field | Variable Name | Data Type | Mandatory? | Validation Rules & Business Logic |
|----------------------|---------------|-----------|------------|-----------------------------------|
| Template Laporan | `report_template` | Enum | Ya | Values: `kemdikbud`, `lengkap` |
| Program Studi | `prodi_filter` | UUID | Tidak | Null = Semua Prodi |
| Menampilkan Data Terbaru | `latest_data_only` | Boolean | Tidak | Default: true |

---

### 4. Acceptance Criteria & Gherkin Scenarios

#### Fitur: Daftar Kuesioner

---

**AC TS-001-01: Admin dapat melihat daftar kuesioner berdasarkan status**

**Scenario TS-001-01.1 Positive: Melihat daftar kuesioner draft**
```gherkin
Scenario: Admin melihat daftar kuesioner dengan status draft
  Given Admin PT sudah login ke sistem
  And Admin berada di halaman Daftar Kuesioner
  When Admin mengklik tab "Draft"
  Then sistem menampilkan daftar kuesioner dengan status draft
  And setiap card menampilkan nama kuesioner, tanggal dibuat, dan jenis template
  And setiap card menampilkan tombol "Finalisasi", "Edit", dan "Hapus"
```

**Scenario TS-001-01.2 Negative: Tidak ada kuesioner draft**
```gherkin
Scenario: Admin melihat tab draft yang kosong
  Given Admin PT sudah login ke sistem
  And tidak ada kuesioner dengan status draft
  When Admin mengklik tab "Draft"
  Then sistem menampilkan pesan "Belum ada kuesioner draft"
  And sistem menampilkan tombol "Buat Kuesioner Baru"
```

---

**AC TS-001-02: Admin dapat mencari kuesioner berdasarkan nama**

**Scenario TS-001-02.1 Positive: Pencarian menemukan hasil**
```gherkin
Scenario: Admin mencari kuesioner dan menemukan hasil
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner dengan nama "Tracer Study Lulusan 2025"
  When Admin mengetik "Tracer" di search box
  Then sistem menampilkan kuesioner yang mengandung kata "Tracer"
  And hasil pencarian di-highlight
```

**Scenario TS-001-02.2 Negative: Pencarian tidak menemukan hasil**
```gherkin
Scenario: Admin mencari kuesioner yang tidak ada
  Given Admin PT sudah login ke sistem
  When Admin mengetik "XYZ123" di search box
  Then sistem menampilkan pesan "Tidak ada kuesioner yang ditemukan"
```

---

**AC TS-001-03: Admin dapat memfilter kuesioner berdasarkan jenis template**

**Scenario TS-001-03.1 Positive: Filter berdasarkan template Kemdikbud**
```gherkin
Scenario: Admin memfilter kuesioner dengan template Kemdikbud
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner dengan berbagai jenis template
  When Admin memilih filter "Kemdikbud" dari dropdown Jenis Template
  Then sistem hanya menampilkan kuesioner dengan template Kemdikbud
  And badge "Template Kemdikbud" terlihat di setiap card
```

**Scenario TS-001-03.2 Negative: Tidak ada kuesioner dengan template yang dipilih**
```gherkin
Scenario: Admin memfilter template yang tidak ada kuesionernya
  Given Admin PT sudah login ke sistem
  And tidak ada kuesioner dengan template "Pengguna Lulusan"
  When Admin memilih filter "Pengguna Lulusan"
  Then sistem menampilkan pesan "Tidak ada kuesioner dengan template ini"
```

---

**AC TS-001-04: Admin dapat memfinalisasi kuesioner draft**

**Scenario TS-001-04.1 Positive: Finalisasi kuesioner berhasil**
```gherkin
Scenario: Admin memfinalisasi kuesioner draft
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner draft dengan nama "Tracer Study 2025"
  When Admin mengklik tombol "Finalisasi" pada kuesioner tersebut
  Then sistem menampilkan modal konfirmasi finalisasi
  When Admin mengklik tombol "Finalisasi" di modal
  Then kuesioner berpindah ke tab "Siap Kirim"
  And status kuesioner berubah menjadi "ready_to_send"
  And sistem menampilkan notifikasi sukses
```

**Scenario TS-001-04.2 Positive: Finalisasi dengan opsi Pengguna Lulusan**
```gherkin
Scenario: Admin memfinalisasi kuesioner dengan menyertakan template Pengguna Lulusan
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner draft
  When Admin mengklik tombol "Finalisasi"
  And Admin mencentang checkbox "Kirimkan juga Template Kuesioner Pengguna Lulusan"
  And Admin mengklik tombol "Finalisasi" di modal
  Then kuesioner memiliki 2 template: Lengkap dan Pengguna Lulusan
  And kuesioner berpindah ke tab "Siap Kirim"
```

**Scenario TS-001-04.3 Negative: Batal finalisasi**
```gherkin
Scenario: Admin membatalkan finalisasi kuesioner
  Given Admin PT sudah login ke sistem
  And modal finalisasi sedang terbuka
  When Admin mengklik tombol "Batal"
  Then modal tertutup
  And kuesioner tetap berada di tab "Draft"
```

---

**AC TS-001-05: Admin dapat mengirim kuesioner ke alumni**

**Scenario TS-001-05.1 Positive: Kirim kuesioner berhasil**
```gherkin
Scenario: Admin mengirim kuesioner ke alumni
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner di tab "Siap Kirim"
  When Admin mengklik tombol "Kirim" pada kuesioner tersebut
  Then sistem mengirim email kuesioner ke semua alumni yang ditarget
  And kuesioner berpindah ke tab "Terkirim"
  And status kuesioner berubah menjadi "sent"
  And tanggal kirim tercatat di sistem
```

**Scenario TS-001-05.2 Negative: Tidak ada alumni yang ditarget**
```gherkin
Scenario: Admin mencoba mengirim kuesioner tanpa target alumni
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner di tab "Siap Kirim"
  And tidak ada alumni yang ditarget untuk kuesioner tersebut
  When Admin mengklik tombol "Kirim"
  Then sistem menampilkan pesan error "Tidak ada alumni yang ditarget"
  And kuesioner tetap di tab "Siap Kirim"
```

---

**AC TS-001-06: Admin dapat melihat response rate kuesioner terkirim**

**Scenario TS-001-06.1 Positive: Melihat response rate**
```gherkin
Scenario: Admin melihat jumlah responden kuesioner
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim dengan 49 target dan 1 responden
  When Admin membuka tab "Terkirim"
  Then sistem menampilkan badge "1 / 49 Sudah Mengisi"
  And Admin dapat melihat detail per template jika di-expand
```

**Scenario TS-001-06.2 Positive: Expand card untuk melihat detail template**
```gherkin
Scenario: Admin meng-expand card untuk melihat detail response per template
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim dengan template Lengkap dan Pengguna Lulusan
  When Admin mengklik tombol expand pada card kuesioner
  Then sistem menampilkan detail response untuk masing-masing template
  And setiap template menampilkan jumlah responden
```

---

**AC TS-001-07: Admin dapat mendownload hasil kuesioner**

**Scenario TS-001-07.1 Positive: Download hasil berhasil**
```gherkin
Scenario: Admin mendownload hasil kuesioner
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim dengan responden
  When Admin mengklik tombol "Download Hasil"
  Then sistem menampilkan modal Download Hasil
  When Admin memilih template laporan "Kemdikbud"
  And Admin mengklik tombol "Download"
  Then sistem mengunduh file laporan dalam format yang dipilih
```

**Scenario TS-001-07.2 Negative: Download tanpa memilih template**
```gherkin
Scenario: Admin mencoba download tanpa memilih template laporan
  Given Admin PT sudah login ke sistem
  And modal Download Hasil sedang terbuka
  When Admin tidak memilih template laporan
  And Admin mengklik tombol "Download"
  Then sistem menampilkan pesan error "Template Laporan wajib dipilih"
  And download tidak diproses
```

---

**AC TS-001-08: Admin dapat mengirim ulang kuesioner**

**Scenario TS-001-08.1 Positive: Kirim ulang berhasil**
```gherkin
Scenario: Admin mengirim ulang kuesioner ke non-responden
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim dengan alumni yang belum mengisi
  And sudah lebih dari 3 hari sejak pengiriman terakhir
  When Admin mengklik "Kirim Ulang" dari menu aksi
  And Admin mengkonfirmasi di modal
  Then sistem mengirim email ke alumni yang belum mengisi
  And sistem menampilkan notifikasi sukses
```

**Scenario TS-001-08.2 Negative: Kirim ulang sebelum 3 hari**
```gherkin
Scenario: Admin mencoba kirim ulang sebelum 3 hari
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim
  And pengiriman terakhir kurang dari 3 hari yang lalu
  When Admin mengklik "Kirim Ulang"
  Then sistem menampilkan pesan "Kirim ulang hanya dapat dilakukan setiap 3 hari sekali"
  And tombol "Ya, Yakin" di-disable
```

---

**AC TS-001-09: Admin dapat menyalin kuesioner**

**Scenario TS-001-09.1 Positive: Salin kuesioner berhasil**
```gherkin
Scenario: Admin menyalin kuesioner yang sudah ada
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner dengan nama "Tracer Study 2025"
  When Admin mengklik tombol "Buat Salinan"
  And Admin mengkonfirmasi di modal
  Then sistem membuat kuesioner baru dengan nama "Tracer Study 2025 (Copy)"
  And kuesioner baru memiliki status "draft"
  And semua pertanyaan tersalin ke kuesioner baru
```

**Scenario TS-001-09.2 Negative: Batal menyalin**
```gherkin
Scenario: Admin membatalkan penyalinan kuesioner
  Given Admin PT sudah login ke sistem
  And modal konfirmasi salin sedang terbuka
  When Admin mengklik tombol "Batal"
  Then modal tertutup
  And tidak ada kuesioner baru yang dibuat
```

---

**AC TS-001-10: Admin dapat menghapus kuesioner**

**Scenario TS-001-10.1 Positive: Hapus kuesioner berhasil**
```gherkin
Scenario: Admin menghapus kuesioner
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner yang ingin dihapus
  When Admin mengklik tombol hapus (icon trash)
  Then sistem menampilkan modal konfirmasi hapus
  When Admin mengklik "Ya, Yakin"
  Then kuesioner dihapus dari sistem
  And kuesioner tidak muncul lagi di daftar
  And sistem menampilkan notifikasi sukses
```

**Scenario TS-001-10.2 Negative: Batal menghapus**
```gherkin
Scenario: Admin membatalkan penghapusan kuesioner
  Given Admin PT sudah login ke sistem
  And modal konfirmasi hapus sedang terbuka
  When Admin mengklik tombol "Batal"
  Then modal tertutup
  And kuesioner tidak dihapus
```

---

**AC TS-001-11: Admin dapat mereset hasil jawaban kuesioner**

**Scenario TS-001-11.1 Positive: Reset hasil berhasil**
```gherkin
Scenario: Admin mereset semua jawaban kuesioner
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim dengan responden
  When Admin mengklik "Reset Hasil" dari menu aksi
  And Admin mengkonfirmasi di modal
  Then semua jawaban kuesioner dihapus
  And counter responden kembali ke 0
  And sistem menampilkan notifikasi sukses
```

**Scenario TS-001-11.2 Negative: Batal reset**
```gherkin
Scenario: Admin membatalkan reset hasil
  Given Admin PT sudah login ke sistem
  And modal konfirmasi reset sedang terbuka
  When Admin mengklik tombol "Batal"
  Then modal tertutup
  And jawaban kuesioner tidak dihapus
```

---

**AC TS-001-12: Admin dapat menyalin link kuesioner**

**Scenario TS-001-12.1 Positive: Salin link berhasil**
```gherkin
Scenario: Admin menyalin link kuesioner
  Given Admin PT sudah login ke sistem
  And terdapat kuesioner terkirim
  When Admin mengklik "Salin Link" dari menu aksi
  Then link kuesioner tersalin ke clipboard
  And sistem menampilkan toast "Link berhasil disalin"
```

---

### 5. Open Questions / Dependencies

- [ ] **Q1:** Apakah ada batasan jumlah kuesioner yang bisa dibuat per PT?
- [ ] **Q2:** Bagaimana mekanisme integrasi dengan database alumni dari Siakad?
- [ ] **Q3:** Apakah perlu fitur scheduling untuk pengiriman kuesioner otomatis?
- [ ] **Q4:** Format file apa saja yang didukung untuk download hasil? (Excel, PDF, CSV?)
- [ ] **Q5:** Apakah ada retention policy untuk data kuesioner yang sudah lama?
- [ ] **Q6:** Bagaimana handling jika email alumni bounce/invalid?

---

*Dokumen ini adalah living document dan akan terus diupdate seiring perkembangan fitur.*
