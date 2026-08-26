# Alur Sekali Isi, Simple

> Sumber: whiteboard "Alur sekali isi, simple"

``` mermaid
flowchart LR

    subgraph ADMIN["Admin CDC"]
        A1["Admin Login"]
        A2["Pilih angkatan/gelombang<br/>yang mau disurvei"]
        A3["Susun pertanyaan<br/>pilih yang perlu + tambah<br/>pertanyaan khusus"]
        A4["Kirim/ Publish<br/>quisioner"]
        A5[/"Pantau hasil"/]

        A1 --> A2 --> A3 --> A4
    end

    subgraph ALUMNI["Alumni"]
        B1["Buka link<br/>kuisioner"]
        B2{"Sudah pernah isi?"}
        B3(["Selesai"])
        B4["Isi kuisioner<br/>step-by-step"]
        B5["Kirim Jawaban"]
        B6(["Selesai"])

        B1 --> B2
        B2 -- "sudah" --> B3
        B2 -- "belum" --> B4 --> B5 --> B6
    end

    A4 -. "kuisioner aktif" .-> B1
    B5 -. "jawaban tersimpan" .-> A5
```

## Ringkasan

- Versi paling "polos" dari alur Tracer Study — tidak ada istilah Template Version maupun Campaign, hanya **kuesioner** yang disusun langsung per angkatan/gelombang lalu dikirim/publish.
- Alumni tinggal buka link kuesioner; kalau belum pernah isi, langsung diarahkan ke wizard step-by-step; kalau sudah pernah isi, langsung selesai (tidak bisa mengisi ulang).
- Ini adalah baseline paling sederhana dibanding tiga alur lain (`alur-sederhana.md`, `alur-sekali-isi.md`, `alur-alumni-isi-kembali-edit.md`) — berguna sebagai titik pembanding "seberapa jauh" kompleksitas Template Version + Campaign benar-benar dibutuhkan di versi awal.
