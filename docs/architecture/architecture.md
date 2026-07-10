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
|   vodaevent.id    |     +----------+-------------+
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
| Analytics | **Google Analytics** | Gratis, informatif untuk atasan |

## Why Cloudflare R2 for Images?

- **$0 egress fee** — bandwidth gratis, beda sama AWS S3
- **Auto CDN** — gambar dikirim lewat edge server terdekat
- **Integrasi langsung** — Directus support S3-compatible storage
- **Gratis tier** — 10GB storage + 1M request/bulan gratis
- **VPS tetap ringan** — storage & bandwidth gambar di R2, bukan di VPS