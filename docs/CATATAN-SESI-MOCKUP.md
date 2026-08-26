# Catatan Sesi Mockup Karirlink - Current State

## Status: IN PROGRESS

## File Mockup yang Sudah Dibuat

### Admin CDC (Tracer Study Module - Quantum Design)
| File | Fungsi |
|------|--------|
| `quantum/index.html` | Daftar Kuesioner (Draft/Siap Kirim/Terkirim) |
| `quantum/kuesioner-builder.html` | Builder kuesioner |
| `quantum/kuesioner-template-view.html` | View template lengkap (admin lihat semua section) |
| `quantum/kuesioner-preview.html` | Preview journey alumni (step 1, 2, form) |
| `quantum/dashboard.html` | Dashboard Tracer Study |

### Flow Alumni (Tracer Study - Pengisian)
| File | Fungsi |
|------|--------|
| `quantum/email-tracer-study.html` | Email undangan ke alumni |
| `quantum/tracer-study-step1.html` | Step 1: Pilih Tahun Lulus, Jenjang, Prodi |
| `quantum/tracer-study-step2.html` | Daftar Alumni (pilih diri sendiri) |
| `quantum/tracer-study-verify.html` | Verifikasi identitas (tanggal lahir DD/MM/YYYY) |
| `quantum/tracer-study-form.html` | Form kuesioner (Section 1: Informasi Umum) |
| `quantum/tracer-study-success.html` | Halaman sukses + lowongan kerja |

### Flow Pengguna Lulusan (Kuesioner Kinerja Karyawan)
| File | Fungsi |
|------|--------|
| `quantum/email-pengguna-lulusan.html` | Email ke atasan/pengguna lulusan |
| `quantum/pengguna-lulusan-form.html` | Form survei pengguna lulusan (12 pertanyaan) |

### Portal Karirlink (CDC Portal - Tailwind)
| File | Fungsi |
|------|--------|
| `quantum/portal-karir.html` | Beranda Portal (profile, feed, mitra) |
| `quantum/alumni-activity.html` | Aktivitas Lamaran Alumni (filter, chart, tabel) |
| `quantum/perusahaan-mitra.html` | Perusahaan Mitra (invite, list, status) |
| `quantum/lowongan-create.html` | Buat Lowongan (form - PERLU DILENGKAPI) |
| `quantum/landing-cdc.html` | Landing page CDC publik |

---

## TODO: Yang Perlu Dilengkapi

### 1. `lowongan-create.html` - Field yang kurang (dari referensi asli)
Mockup saat ini sudah ada: Judul, Jenis Pekerjaan, Tipe Pekerjaan, Gaji Min/Max, Provinsi, Kab/Kota, Deskripsi, Toggle Portal, Batas Lamaran.

**Field yang BELUM ada (harus ditambahkan):**
- Penyelenggara (radio: Perguruan Tinggi / Perusahaan Mitra)
- Perusahaan Pembuat Lowongan (conditional select, muncul jika pilih Perusahaan Mitra)
- Lokasi (select dengan search - bukan dropdown Provinsi/Kota terpisah, tapi satu field "Masukkan nama lokasi")
- Batasi Domisili Pelamar (toggle switch)
- Dokumen Tambahan (toggle switch)
- Deskripsi Pekerjaan (rich text editor / Quill - bukan textarea biasa)
- Persyaratan Pekerjaan (rich text editor)
- Preferensi Program Studi (multi-select with tags)
- Tingkat Pendidikan (select: SMA, D3, D4, S1, S2, S3)
- Tingkat Pengalaman Kerja (select: Fresh Graduate, 1-2 tahun, 3-5 tahun, dll)
- Keahlian (multi-select with tags)
- Kategori Pekerjaan* (select, required)
- Poster (file upload with drag-drop area, max 2MB)
- Kisaran Gaji (select type: Bulanan/Tahunan + input min/max dengan prefix Rp)
- Tanggal Publikasi* (date picker)
- Batasi Lowongan (toggle + number input untuk max pelamar)

**Referensi:** `karir_prompt/reference/karirlink-mockup-quantum/Buat Lowongan _ KarirLink.html`

### 2. Tracer Study Form - Section lanjutan belum dibuat
- Section 2-6 belum ada di `tracer-study-form.html` (hanya Section 1: Informasi Umum)
- Conditional logic Q5 (Status) → routing ke section berbeda belum diimplementasi
- Section "Tingkat Kompetensi" (tabel skala) belum dibuat di sisi alumni

### 3. Halaman yang belum dibuat tapi sudah ada referensi
- Event page (dari "Buat Event" di portal-karir.html)
- Lowongan list page (daftar lowongan yang sudah dipublish)
- Kerja Sama pages (Pencarian Mitra, Daftar Mitra, Kegiatan Kerja Sama)

---

## Konteks Penting untuk Sesi Berikutnya

### Penamaan Template (Inkonsistensi di Karirlink saat ini)
- "Template Lengkap" = Template Kemdikbud + Template Pengguna Lulusan (bundle)
- Di card expand Tab Terkirim, sub-item tetap ditulis "Template Lengkap" (bukan "Template Kemdikbud") — ini inkonsisten tapi kita ikuti state saat ini dulu

### Flow Current State
```
ADMIN:
index.html → Tab Terkirim → expand card → klik "Template Lengkap" → kuesioner-template-view.html

ALUMNI:
email-tracer-study.html → step1 → step2 (daftar alumni) → verify (DOB) → form → success

PENGGUNA LULUSAN:
email-pengguna-lulusan.html → pengguna-lulusan-form.html (step + survei) → modal selesai → landing-cdc.html
```

### Conditional Logic Tracer Study
- Q7 (Pekerjaan sebelum lulus): "Tidak" → show Q8 (berapa bulan)
- Q5 (Status): routing ke section berbeda (Bekerja/Wiraswasta/Pendidikan) — BELUM diimplementasi
- Section Wiraswasta Q1: "Sebelum lulus" → Q2, "Sesudah lulus" → Q3, "Tidak merencanakan" → skip ke Q4

### Tech Stack Mockup
- Admin Tracer Study (quantum folder): Vanilla HTML/CSS/JS + Quantum CSS framework
- Portal Karirlink: Tailwind CSS via CDN + Poppins font + custom tailwind.config
- Landing CDC: Standalone HTML/CSS

### Navbar Consistency
- Portal pages (portal-karir, alumni-activity, perusahaan-mitra, lowongan-create) harus pakai navbar yang sama
- Active state ditandai dengan `text-primary500 font-semibold`
- Items: Beranda, Aktivitas ▾, Perusahaan, Kerja Sama ▾ | Bell, Mail, "Tracer Study ↗", Avatar ▾
