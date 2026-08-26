# Alur Alumni Dapat Isi Kembali / Edit

> Sumber: whiteboard "Alur Alumni dapat isi Kembali/ Edit"

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
        B5(["Belum ada survei aktif<br/>untuk angkatan ini<br/>saat ini (selesai)"])
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

        B7 -. "terdapat history & dapat mengisi kembali" .-> B3
        B11 -. "terdapat history & dapat mengisi kembali" .-> B3
    end

    A7 -. "data campaign + template aktif -> trigger notifikasi" .-> B1
    B11 --> A8
```

## Ringkasan

- Diagram ini sama persis dengan `alur-sekali-isi.md` di sisi Admin CDC — perbedaannya ada di sisi Alumni: setelah alumni **sudah pernah isi & lengkap** ("B7") atau baru saja **selesai** mengisi ("B11"), alur bisa **kembali lagi ke "Hitung wave dari cohort_year"** ("B3") untuk mengisi ulang / mengedit response yang sudah ada.
- Ini adalah pertanyaan desain terbuka: apakah Tracer Study bersifat **sekali isi lalu terkunci** (`alur-sekali-isi.md`), atau **bisa diisi ulang/diedit** kapan saja selama campaign masih aktif (dokumen ini)? Keduanya digambar terpisah untuk dibandingkan sebelum diputuskan mana yang dipakai.
- Kalau alur "dapat edit" ini yang dipilih, artinya sistem perlu menyimpan riwayat/versi response per alumni per campaign+wave, bukan hanya status "sudah/belum submit".
