# Database Design (Directus Collections)

## Overview

Project ini menggunakan **Directus** sebagai backend. Database PostgreSQL berisi dua jenis tabel:
1. **System tables (built-in Directus)** — auth, user, role, permission, file, dll. Tidak perlu dibuat manual.
2. **Collections (data bisnis)** — tabel yang kita buat untuk konten website.

## System Tables (Otomatis oleh Directus)

| Tabel | Fungsi |
|-------|--------|
| `directus_users` | Data admin & staf (email, password hash, role, dll) |
| `directus_roles` | Role & permission level |
| `directus_permissions` | Aturan akses per collection per role |
| `directus_files` | Metadata file upload (gambar) |
| `directus_folders` | Folder organisasi file |
| `directus_settings` | Setting internal Directus |
| `directus_activity` | Log aktivitas admin |
| *(dan beberapa tabel internal lain)* | |

**Tidak perlu dibuat** — Directus otomatis membuatnya saat pertama kali dijalankan.

## Collections (Data Bisnis)

Berikut collection yang **harus dibuat manual** di admin panel Directus.

---

### `regions`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| name | string | Nama region (Bandung, Bali, dll) |
| slug | string (unique) | Auto dari name |
| description | text | Deskripsi region |
| image | string (URL) | Foto utama region |
| sort_order | integer | Urutan tampilan |
| status | string | published / draft |

### `destinations`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| region_id | integer (FK) | Relasi ke regions |
| name | string | Nama destinasi |
| slug | string (unique) | Auto dari name |
| description | text | Deskripsi |
| image | string | Foto utama |
| gallery | JSON | Array URL gambar |
| sort_order | integer | Urutan tampilan |
| status | string | published / draft |

### `packages`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| destination_id | integer (FK) | Relasi ke destinations |
| name | string | Nama paket |
| slug | string (unique) | Auto dari name |
| description | text | Deskripsi |
| duration | string | "2D1N", "3D2N", "Half Day" |
| itinerary | JSON | Array: day -> list kegiatan |
| facilities | JSON | Array: list fasilitas |
| price_tiers | JSON | Array multi-tabel: { table_title, tiers: [{ min_pax, max_pax, price_per_pax, description }] } |
| addons | JSON | Array: { addon_name, price, description } (fitur tambahan opsional) |
| gallery | JSON | Array URL gambar |
| sort_order | integer | Urutan tampilan |
| status | string | published / draft |

### `settings`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| key | string (unique) | site_name, whatsapp, email, address, ig, etc |
| value | text | Nilai setting |

### `articles`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| title | string | Judul artikel |
| slug | string (unique) | Auto dari title |
| content | text | Konten artikel (Rich text) |
| image | string (URL) | Featured image |
| ads | alias (O2M) | Relasi ke tabel `ads` |
| seo | JSON | Data SEO via custom-seo-analyzer |
| status | string | published / draft |

### `ads`

| Field | Type | Notes |
|-------|------|-------|
| id | uuid (PK) | UUID auto-generated |
| image | uuid (FK) | Relasi ke directus_files |
| description | string | Teks atau judul iklan |
| url | string | Link eksternal iklan |
| articles_id | uuid (FK) | Relasi balik ke articles |

## Relasi

```
regions (1) ----< destinations (M) ----< packages (M)
articles (1) ---< ads (M)
```

## Cara Buat Collection

1. Login ke `/directus` dengan akun admin
2. Kiri: Settings -> Data Model
3. Klik "Create Collection"
4. Pilih mode: **Table** (bukan singleton)
5. Isi Collection Name: `regions` / `destinations` / `packages` / `articles` / `settings` / `ads`
6. Tambah field sesuai tabel di atas
7. Untuk field relasi (region_id, destination_id, articles_id), pilih tipe **Many-to-One** (M2O) atau **One-to-Many** (O2M) dari sisi tabel induk
8. Set permission: Public -> Read (biar API bisa diakses tanpa auth)