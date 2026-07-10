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
| price_tiers | JSON | Array: { min_pax, max_pax, price, note } |
| gallery | JSON | Array URL gambar |
| sort_order | integer | Urutan tampilan |
| status | string | published / draft |

### `settings`

| Field | Type | Notes |
|-------|------|-------|
| id | integer (PK) | auto-increment |
| key | string (unique) | site_name, whatsapp, email, address, ig, etc |
| value | text | Nilai setting |

## Relasi

```
regions (1) ----< destinations (M) ----< packages (M)
```

## Cara Buat Collection

1. Login ke `/directus` dengan akun admin
2. Kiri: Settings -> Data Model
3. Klik "Create Collection"
4. Pilih mode: **Table** (bukan singleton)
5. Isi Collection Name: `regions` / `destinations` / `packages` / `settings`
6. Tambah field sesuai tabel di atas
7. Untuk field relasi (region_id, destination_id), pilih tipe **Many-to-One**
8. Set permission: Public -> Read (biar API bisa diakses tanpa auth)