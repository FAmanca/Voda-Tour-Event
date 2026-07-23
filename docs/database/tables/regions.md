# Regions

Tabel `regions` menyimpan data wilayah/region tujuan wisata.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| name           | varchar(255)  | —                 | Nama region (Bandung, Bali)  |
| slug           | varchar(255)  | —                 | URL slug (unique)            |
| description    | text          | null              | Deskripsi region             |
| image          | uuid (files)  | null              | Foto utama region            |
| status         | varchar(20)   | 'draft'           | draft / published / archived |
| user_created   | uuid (users)  | null              | Pembuat                      |
| date_created   | timestamptz   | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)  | null              | Pengubah terakhir            |
| date_updated   | timestamptz   | now()             | Tanggal diubah               |

## Indexes

- `regions_pkey` — Primary key
- `regions_slug_unique` — Unique slug
- `regions_status_idx` — Filter by status

## Relations

- `image` → `directus_files.id`
- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Hanya status `published` yang tampil di public API.
