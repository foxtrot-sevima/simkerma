# Alur Sekali Isi

> Sumber: whiteboard "Alur sekali isi"

``` mermaid
flowchart LR

    subgraph ADMIN["Admin CDC"]
        A1["Admin Akses<br/>KarirLink via Gate"]
        A2["Pilih jenis survei<br/>Lulusan / Pengguna<br/>Lulusan"]
        A3["Susun Template"]
        A4["Preview pertanyaan &<br/>validasi pertanyaan"]
        A5["Publish<br/>Template Version"]
        A6["Buat / konfirmasi Campaign:<br/>institusi + wave + cohort_year +<br/>tanggal buka-tutup"]
        A7(["Campaign aktif,<br/>notifikasi terkirim"])
        A8[/"Monitoring Tracer Study:<br/>response rate, drop-out,<br/>per prodi & angkatan"/]

        A1 --> A2 --> A3 --> A4 --> A5 --> A6 --> A7 --> A8
        A2 -. "campaign lain untuk angkatan/wave berbeda" .-> A2
    end

    subgraph ALUMNI["Alumni"]
        B1["Akses via Gate,<br/>karirlink.id,<br/>atau link dari<br/>notifikasi email(?)"]
        B2["Login sbg Alumni<br/>(nim; cohort_year<br/>terbaca otomatis)"]
        B3["Hitung wave<br/>dari cohort_year"]
        B4{"Cohort match<br/>wave<br/>Exit / GS-I / GS-II<br/>saat ini?"}
        B5(["Belum ada survei aktif<br/>utk angkatan ini saat ini<br/>(selesai)"])
        B6{"Sudah pernah<br/>submit Response<br/>utk campaign<br/>+ wave ini?"}
        B7(["Sudah pernah isi<br/>& lengkap"])
        B8["Resolve Template:<br/>Core + Optional aktif + Specific"]
        B9["Buka Wizard,<br/>isi step-per-step"]
        B10["Jawab & kirim<br/>Quisioner"]
        B11["Selesai"]

        B1 --> B2 --> B3 --> B4
        B4 -- "tidak match" --> B5
        B4 -- "ya" --> B6
        B6 -- "sudah pernah" --> B7
        B6 -- "belum pernah" --> B8 --> B9 --> B10 --> B11
    end

    A7 -. "data campaign + template aktif -> trigger notifikasi" .-> B1
    B11 --> A8
```

## Ringkasan

- Ini adalah alur "sekali isi" — versi utama yang jadi acuan model **Template Version + Campaign** yang dipakai di seluruh mockup (lihat `karirlink-cdc-unified-flow.mmd.md`).
- Admin menyusun satu **Template** (bukan banyak jenis kuesioner), mem-*publish*-nya sebagai sebuah **Template Version**, lalu membuat **Campaign** yang mengikat institusi + wave (Exit/GS-I/GS-II) + cohort_year + jendela waktu buka-tutup ke versi template tertentu.
- Di sisi alumni, wave dihitung otomatis dari `cohort_year`. Jika wave alumni tidak match campaign yang sedang aktif, alur berhenti ("belum ada survei aktif"). Jika sudah pernah mengisi response untuk campaign + wave yang sama, alur juga berhenti (dianggap sudah lengkap) — **belum ada mekanisme isi ulang/edit** di versi ini (bandingkan dengan `alur-alumni-isi-kembali-edit.md`).
- Template yang di-resolve ke alumni adalah gabungan section **Core** (wajib semua wave) + **Optional yang aktif** + section **spesifik wave** (Exit/GS-I/GS-II).
