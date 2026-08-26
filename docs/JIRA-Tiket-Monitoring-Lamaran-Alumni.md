════════════════════════════════════════════════════════════════════
EPIC: Monitoring Aktivitas Lamaran Alumni [PK-002]
════════════════════════════════════════════════════════════════════

Project       : Foxtrot
Type          : Epic
Priority      : High
Labels        : portal-karir, new-feature, unpas-request
Fix Version   : 1.0
PRD Reference : PRD-Portal-Karir.md → Fitur PK-002

Deskripsi:
Sebagai Admin PT (request dari Universitas Pasundan), saya ingin 
dapat memonitor jumlah lulusan yang melamar ke perusahaan yang 
berada di naungan Karirlink Sevima, agar saya memiliki visibilitas 
terhadap aktivitas karir alumni dan dapat mengambil keputusan 
terkait career services.

Stories:
  1. Card Aktivitas Lamaran Alumni di Beranda (sprint ini)
  2. Halaman Detail Monitoring Lamaran Alumni (sprint berikutnya)


════════════════════════════════════════════════════════════════════
STORY 1: Card Aktivitas Lamaran Alumni di Beranda
════════════════════════════════════════════════════════════════════

Project       : Foxtrot
Type          : Story
Priority      : High
Epic Link     : Monitoring Aktivitas Lamaran Alumni [PK-002]
Story Points  : 5

────────────────────────────────────────────────────────────────────
1. NARASI BISNIS
────────────────────────────────────────────────────────────────────

Latar Belakang:

Fitur ini merupakan new feature request dari Universitas Pasundan. 
Sebagai Admin PT, mereka ingin dapat memonitor jumlah lulusan yang 
melamar ke perusahaan yang berada di naungan Karirlink Sevima.

Sebagai langkah pertama, Admin PT membutuhkan ringkasan data 
lamaran alumni yang langsung terlihat di Beranda Portal Karir 
tanpa harus navigasi ke halaman lain. Card ini menjadi entry point 
sekaligus quick overview untuk monitoring lamaran.

Hipotesis / Expected Outcome:
  • Admin PT mendapat visibilitas instan terhadap aktivitas 
    lamaran alumni setiap kali membuka Portal Karir
  • Admin PT mengetahui perusahaan mana yang paling diminati 
    alumni tanpa effort tambahan
  • Meningkatkan engagement Admin PT dengan platform Karirlink

Dampak jika tidak dibuat:
  • Admin PT tidak tahu berapa banyak alumni yang aktif melamar
  • PT tidak memiliki data untuk mengukur efektivitas career services
  • PT kehilangan insight tentang perusahaan tujuan alumni

────────────────────────────────────────────────────────────────────
2. USER STORIES
────────────────────────────────────────────────────────────────────

US-1: Sebagai Admin PT, saya ingin melihat total lamaran alumni 
      bulan ini di Beranda, agar saya mengetahui seberapa aktif 
      alumni melamar pekerjaan di Karirlink.

US-2: Sebagai Admin PT, saya ingin melihat jumlah alumni unik 
      yang melamar, agar saya mengetahui berapa banyak alumni 
      yang aktif menggunakan platform.

US-3: Sebagai Admin PT, saya ingin melihat breakdown status 
      lamaran (Diterima, Dalam Proses, Ditolak), agar saya 
      mengetahui tingkat keberhasilan alumni.

US-4: Sebagai Admin PT, saya ingin melihat top 5 perusahaan 
      tujuan alumni, agar saya mengetahui perusahaan mana yang 
      paling diminati dan bisa memprioritaskan kerja sama.

────────────────────────────────────────────────────────────────────
3. KEY DATA DICTIONARY
────────────────────────────────────────────────────────────────────

A. API Response: Summary Lamaran (untuk card di Beranda)

┌──────────────────────┬────────────────────┬───────────┬──────────┬─────────────────────────────────────┐
│ UI Component / Field │ Variable Name      │ Data Type │ Wajib?   │ Validation & Business Logic         │
├──────────────────────┼────────────────────┼───────────┼──────────┼─────────────────────────────────────┤
│ Total Lamaran        │ total_applications │ Integer   │ Ya       │ Count lamaran bulan berjalan        │
│ Alumni Melamar       │ unique_alumni      │ Integer   │ Ya       │ Count distinct alumni_id bulan ini  │
│ Diterima             │ accepted_count     │ Integer   │ Ya       │ Count status = accepted             │
│ Dalam Proses         │ in_process_count   │ Integer   │ Ya       │ Count status = in_process           │
│ Ditolak              │ rejected_count     │ Integer   │ Ya       │ Count status = rejected             │
└──────────────────────┴────────────────────┴───────────┴──────────┴─────────────────────────────────────┘

B. API Response: Top 5 Perusahaan

┌──────────────────────┬────────────────────┬───────────┬──────────┬─────────────────────────────────────┐
│ UI Component / Field │ Variable Name      │ Data Type │ Wajib?   │ Validation & Business Logic         │
├──────────────────────┼────────────────────┼───────────┼──────────┼─────────────────────────────────────┤
│ Ranking              │ rank               │ Integer   │ Ya       │ 1-5, urut dari terbanyak            │
│ Nama Perusahaan      │ company_name       │ String    │ Ya       │ Dari data perusahaan                │
│ Jumlah Lamaran       │ application_count  │ Integer   │ Ya       │ Count lamaran bulan berjalan        │
└──────────────────────┴────────────────────┴───────────┴──────────┴─────────────────────────────────────┘

────────────────────────────────────────────────────────────────────
4. ACCEPTANCE CRITERIA & GHERKIN SCENARIOS
────────────────────────────────────────────────────────────────────

AC PK-002-01: Card Aktivitas Lamaran Alumni tampil di Beranda
═══════════════════════════════════════════════════════════════

Scenario PK-002-01.1 Positive: Card tampil dengan data lengkap

  Scenario: Admin melihat card Aktivitas Lamaran Alumni di beranda
    Given Admin PT sudah login ke Portal Karir
    And terdapat data lamaran alumni bulan ini
    When Admin berada di halaman Beranda
    Then sistem menampilkan card "Aktivitas Lamaran Alumni" 
         di kolom kiri (antara Profil Universitas dan Perusahaan Mitra)
    And card menampilkan total lamaran bulan ini (angka besar, prominent)
    And card menampilkan jumlah alumni yang melamar (dengan icon people)
    And card menampilkan grid 3 kolom status:
      | Diterima      | background hijau  | angka hijau tua  |
      | Dalam Proses  | background kuning | angka kuning tua |
      | Ditolak       | background merah  | angka merah tua  |

Scenario PK-002-01.2 Negative: Belum ada data lamaran bulan ini

  Scenario: Admin melihat card tanpa data lamaran
    Given Admin PT sudah login ke Portal Karir
    And tidak ada data lamaran alumni bulan ini
    When Admin berada di halaman Beranda
    Then card "Aktivitas Lamaran Alumni" tetap tampil
    And total lamaran menampilkan angka 0
    And alumni melamar menampilkan angka 0
    And semua status (Diterima, Dalam Proses, Ditolak) menampilkan 0


AC PK-002-02: Top 5 Perusahaan Tujuan tampil di card
═══════════════════════════════════════════════════════════════

Scenario PK-002-02.1 Positive: Top 5 perusahaan tampil

  Scenario: Admin melihat top 5 perusahaan tujuan di card
    Given Admin PT sudah login ke Portal Karir
    And terdapat data lamaran ke berbagai perusahaan bulan ini
    When Admin berada di halaman Beranda
    Then card menampilkan section "Top 5 Perusahaan Tujuan"
    And setiap item menampilkan:
      - Nomor ranking (1-5, badge bulat biru)
      - Nama perusahaan
      - Jumlah lamaran (angka biru, bold)
    And urutan berdasarkan jumlah lamaran terbanyak

Scenario PK-002-02.2 Negative: Kurang dari 5 perusahaan

  Scenario: Data lamaran hanya ke 2 perusahaan
    Given Admin PT sudah login ke Portal Karir
    And bulan ini alumni hanya melamar ke 2 perusahaan
    When Admin berada di halaman Beranda
    Then section Top 5 hanya menampilkan 2 perusahaan

Scenario PK-002-02.3 Negative: Belum ada data perusahaan

  Scenario: Belum ada lamaran sama sekali
    Given Admin PT sudah login ke Portal Karir
    And tidak ada data lamaran bulan ini
    When Admin berada di halaman Beranda
    Then section Top 5 menampilkan pesan "Belum ada data"


AC PK-002-03: Link Lihat Detail tersedia
═══════════════════════════════════════════════════════════════

Scenario PK-002-03.1 Positive: Link Lihat Detail mengarah ke halaman detail

  Scenario: Admin mengklik Lihat Detail
    Given Admin PT sudah login ke Portal Karir
    And card "Aktivitas Lamaran Alumni" tampil di beranda
    When Admin mengklik link "Lihat Detail"
    Then sistem mengarahkan ke halaman "Aktivitas Lamaran Alumni"
         (halaman detail monitoring - Story 2)

  Catatan: Untuk saat ini, jika halaman detail belum ready, 
  link bisa mengarah ke halaman placeholder atau disabled 
  dengan tooltip "Segera hadir".

────────────────────────────────────────────────────────────────────
5. OPEN QUESTIONS / DEPENDENCIES
────────────────────────────────────────────────────────────────────

Q1: Data lamaran diambil dari tabel mana? Apakah sudah ada 
    tabel yang mencatat setiap kali alumni submit lamaran?

Q2: Apakah "bulan ini" dihitung dari tanggal 1 sampai hari ini, 
    atau 30 hari terakhir?

Q3: Apakah data di card perlu auto-refresh atau cukup refresh 
    saat halaman di-load?

Q4: Bagaimana handling jika alumni melamar ke perusahaan yang 
    bukan mitra PT? Apakah tetap masuk hitungan?

────────────────────────────────────────────────────────────────────
6. REFERENSI MOCKUP
────────────────────────────────────────────────────────────────────

Mockup Card    : mockup/portal-karir.html (section "Aktivitas 
                 Lamaran Alumni Card" di kolom kiri)
Stylesheet     : mockup/assets/style.css (class .lamaran-card 
                 dan turunannya)


════════════════════════════════════════════════════════════════════
STORY 2: Halaman Detail Monitoring Lamaran Alumni [BACKLOG]
════════════════════════════════════════════════════════════════════

Project       : Foxtrot
Type          : Story
Priority      : High
Epic Link     : Monitoring Aktivitas Lamaran Alumni [PK-002]
Story Points  : 13
Status        : Backlog (sprint berikutnya)

Deskripsi singkat:
Halaman detail lengkap dengan filter (Periode, Program Studi, 
Status, Perusahaan), summary cards, chart tren per bulan, chart 
top 5 perusahaan, tabel daftar lamaran dengan search, pagination, 
dan ekspor data.

Detail AC dan Gherkin: Lihat PRD-Portal-Karir.md → PK-002, 
AC PK-002-02 sampai PK-002-09.

Mockup: mockup/portal-aktivitas-lamaran.html

════════════════════════════════════════════════════════════════════
