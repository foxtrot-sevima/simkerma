# Alur Sederhana

> Sumber: whiteboard "Alur sederhana"

``` mermaid
flowchart LR

    subgraph ADMIN["Admin CDC"]
        A1["Admin Akses<br/>KarirLink via Gate"]
        A2["Admin buat<br/>Quisioner Berdasarkan<br/>Tahun Lulus"]
        A3["Atur quisioner<br/>(Save as Template)"]
        A4["Quisioner berhasil<br/>dibuat"]
        A5["Kirim Tracer Study"]
        A6[/"Monitoring<br/>Tracer Study"/]

        A1 --> A2 --> A3 --> A4 --> A5 --> A6
        A5 -. "include" .-> A6
    end

    subgraph ALUMNI["Alumni"]
        B1["Alumni Akses<br/>KarirLink via Gate"]
        B2["Alumni Akses<br/>KarirLink via<br/>karirlink.id"]
        B3["Akses KarirLink<br/>Tracer Study<br/>Sebagai Alumni<br/>(tahun_lulus; nim)"]
        B4{"Sesi<br/>Alumni"}
        B5["Exit"]
        B6["G1"]
        B7["G2"]
        B8["Alumni isi Quisioner<br/>by Wizard page;<br/>step-per-step"]
        B9["Quisioner berhasil<br/>di kirim"]

        B1 --> B3
        B2 --> B3
        B3 --> B4
        B4 --> B5
        B4 --> B6
        B4 --> B7
        B5 --> B8
        B6 --> B8
        B7 --> B8
        B8 --> B9
    end

    A5 -. "data di kirim" .-> B8
    B9 -. "data tersimpan" .-> A6
```

## Ringkasan

- Ini adalah versi paling ringkas dari alur Tracer Study: admin membuat satu kuesioner berdasarkan tahun lulus, lalu mengirimkannya; alumni mengakses lewat gate atau karirlink.id, memilih salah satu wave (Exit / G1 / G2), lalu mengisi lewat wizard step-by-step.
- Belum ada konsep Template Version maupun Campaign terpisah di versi ini — kuesioner dan pengiriman masih satu langkah yang sama ("Atur quisioner" langsung disimpan sebagai template lalu langsung dikirim).
- Monitoring Tracer Study men-*include* langkah "Kirim Tracer Study", dan menerima data balik dari alumni setelah kuisioner berhasil dikirim.
