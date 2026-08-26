# Struktur Menu Admin CDC

> Sumber: whiteboard sticky-notes

## Diagram akses & posisi Dashboard

``` mermaid
flowchart LR
    A["Masuk<br/>dari Gate"] --> B{"Pilih akses"}
    B --> C["Portal<br/>Tracer Study"]
    B --> D["Dashboard adalah halaman utama,<br/>menampilkan informasi:<br/><br/>- Data riwayat karier dan profil<br/>mahasiswa/alumni (Portal Karir)<br/>- Data riwayat pengisian<br/>Tracer Study (Tracer Study)<br/><br/>Nice to have: jika mahasiswa<br/>mendapatkan pekerjaan dari<br/>Portal Karier, datanya sync<br/>dengan data di master dashboard"]
    B --> E["Portal<br/>Karir"]
```

Catatan tambahan di sticky-note terpisah (menu Kuesioner):

> **Menu Kuesioner:**
> Kuesioner untuk PT **hanya ada satu**, dengan pembagian ketentuan:
>
> **A. Jenis Pertanyaan**
> 1. Core questions (acuannya Tracer Kemdikti dan Kemenkes)
> 2. Optional questions (selain Core questions, dipersonalisasi sesuai keperluan PT. Nice to have: bisa hingga tingkat fakultas dan prodi)
>
> **B. Time Window Pertanyaan Disebar**
> 1. Student Survey
> 2. Alumni Survey

## Rincian menu (versi lebih lengkap)

| Menu | Isi |
|---|---|
| **Masuk dari Gate** | Titik masuk tunggal — Karirlink Admin CDC. Portal Karir dan Portal Tracer Study **digabung, tidak sendiri-sendiri**. |
| **Dashboard** *(halaman utama)* | Menampilkan: data riwayat karier & profil mahasiswa/alumni; data riwayat pengisian Tracer Study. Nice to have: jika mahasiswa mendapat pekerjaan dari Portal Karier, datanya sync ke master dashboard. |
| **Kuesioner** | Tracer Study untuk Alumni; Student Survey untuk Mahasiswa Aktif. Nice to have: kuesioner/evaluasi kerjasama dengan Perusahaan; kuesioner feedback aktivitas Event. |
| **Mahasiswa/Alumni** | 1. Memantau tren karier mahasiswa/alumni dan prestasi mahasiswa. 2. Memantau lamaran mahasiswa/alumni. |
| **Aktivitas** | 1. Memantau status kerjasama dengan Perusahaan. 2. Memantau dan membuat Event. 3. Memantau Calendar Aktivitas CDC. |

## Ringkasan

- Poin paling penting dari kedua diagram ini: **Karirlink Admin CDC menyatukan Portal Karir dan Portal Tracer Study dalam satu sistem** — bukan dua aplikasi terpisah — dan **Dashboard adalah halaman utama/landing**, bukan Kuesioner (bandingkan dengan catatan "Start Landing Page di Kuesioner, kenapa gak di Dashboard?" di `catatan.md`, yang sudah ditindaklanjuti di v1: `index.html` sekarang adalah Dashboard).
- Kuesioner ditegaskan **hanya ada satu** per PT, dipecah menjadi Core (mengacu ke Tracer Kemdikti/Kemenkes) + Optional (bisa dipersonalisasi PT, idealnya sampai tingkat fakultas/prodi), dan dibedakan berdasarkan Time Window (Student Survey vs Alumni Survey) — ini sejalan dengan model Template Version + Wave yang sudah diimplementasi di mockup.
- Menu "Aktivitas" mencakup kerjasama Perusahaan, Event, dan kalender aktivitas CDC — sesuai dengan struktur `kerja-sama.html`/`event.html`/`lowongan.html` yang sudah ada di v1.
