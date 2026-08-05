# Architecture Overview

## System Architecture

```
+---------------------------------------------------+
|                   VISITOR                          |
|  Browser -> Cloudflare CDN (cache images, assets)  |
+---------------------------------------------------+
          |                         |
          v                         v
+-------------------+     +------------------------+
|   Astro (SSR)     |     |  Directus Admin Panel  |
|   Website Publik  |     |  (domain.com/directus) |
|   vodatrip.id    |     +----------+-------------+
+-------------------+                |
          |                          |
          v                          v
+-------------------+     +------------------------+
|   Cloudflare R2   |     |      PostgreSQL        |
|   Image Storage   |     |   (via Directus)       |
|   (Auto WebP)     |     +------------------------+
+-------------------+
```

**Flow Gambar:**
1. Admin upload gambar resolusi tinggi ke Directus
2. Directus simpan file ke **Cloudflare R2** (object storage)
3. Astro minta gambar via URL Directus dengan parameter: `?format=webp&width=400`
4. Cloudflare CDN cache gambar — super cepat, ga bebanin VPS
5. Visitor dapet gambar tajam ukuran kecil

## Tech Stack

| Layer | Teknologi | Alasan |
|-------|-----------|--------|
| Backend & Admin | **Directus** | Self-hosted, admin panel built-in |
| Frontend | **Astro** (Node.js SSR) | SEO, performa, static HTML |
| Database | **PostgreSQL 16** | Standar Directus, support JSON |
| Image Storage | **Cloudflare R2** | Murah, 0 egress, auto CDN cache |
| Image Processing | Directus Assets API | WebP/AVIF auto conversion, resize |
| Container | **Docker Compose** | Satu file untuk semua service |
| Reverse Proxy | **Nginx** | Routing ke Directus & Astro |
| Server Analytics | **GoAccess** | Log analyzer via Nginx access log, statis diupdate per 10s |
| Server Monitoring| **Netdata** | Pantau CPU, RAM, Disk real-time via Netdata Cloud |
| Security | **Cloudflare WAF & DNSSEC** | Anti-DDoS, IP Whitelist untuk /stats/, otentikasi DNS |
| Analytics | **Google Analytics** | Gratis, informatif untuk atasan |

## Why Cloudflare R2 for Images?

- **$0 egress fee** — bandwidth gratis, beda sama AWS S3
- **Auto CDN** — gambar dikirim lewat edge server terdekat
- **Integrasi langsung** — Directus support S3-compatible storage
- **Gratis tier** — 10GB storage + 1M request/bulan gratis
- **VPS tetap ringan** — storage & bandwidth gambar di R2, bukan di VPS

## Directus Custom Extensions (CMS Ecosystem)

Untuk mengatasi keterbatasan antarmuka tabel bawaan Directus dalam manajemen konten berstruktur rumit, sistem admin dilengkapi dengan 4 ekstensi kustom yang dikompilasi ke dalam container Docker (`voda-directus`):

1. **[`article-editor`](file:///home/famanca/voda-tour-event/docs/features/article-editor.md) (Custom Module)**: Menggantikan grid koleksi `articles` dengan antarmuka bergaya **WordPress Gutenberg Fullscreen Mode**. Punya analisis SEO interaktif (*real-time* 0-100% score) ala Yoast/RankMath, manajemen Konten Pilar (`is_pillar` & `pillar_parent`), serta sistem smart chip tag untuk Focus/Secondary keywords.
2. **[`package-editor`](file:///home/famanca/voda-tour-event/docs/features/package-editor.md) (Custom Module)**: Modul Visual Page Builder bergaya **Elementor / WordPress Gutenberg** untuk mengelola paket wisata, Itinerary timeline, tier harga dinamis (*price tiers*), dan fasilitas. Menerapkan layout tabel di halaman daftar serta Aturan Emas Z-Index (`z-index: 150`).
3. **[`custom-seo-analyzer`](file:///home/famanca/voda-tour-event/docs/features/seo-analyzer.md) (Custom Interface)**: Antarmuka panel SEO stand-alone (kini aturan dan rumusnya telah ditarik ke dalam `article-editor`).
4. **`auto-compress-webp` (Action Hook)**: Hook backend otomatis yang mengompresi dan mengonversi setiap gambar yang diunggah ke Directus menjadi format WebP sebelum disimpan ke Cloudflare R2.

> [!TIP]
> **Panduan Alur Kerja Ekstensi**: Baca dokumentasi lengkap alur kompilasi Vue 3, deployment Docker, dan aturan komponen UI Directus pada berkas [`docs/development/directus-extensions.md`](file:///home/famanca/voda-tour-event/docs/development/directus-extensions.md).