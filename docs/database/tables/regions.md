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
| created_at     | timestamptz   | now()             | Audit                        |
| updated_at     | timestamptz   | now()             | Audit                        |
| deleted_at     | timestamptz   | null              | Soft delete                  |
| created_by     | uuid (users)  | null              | Pembuat                      |
| updated_by     | uuid (users)  | null              | Pengubah terakhir            |

## Indexes

- `regions_pkey` — Primary key
- `regions_slug_unique` — Unique slug
- `regions_status_idx` — Filter by status

## Relations

- `image` → `directus_files.id`
- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## Notes

- Hanya status `published` yang tampil di public API.
