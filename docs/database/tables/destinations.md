# Destinations

Tabel `destinations` menyimpan data destinasi spesifik di dalam suatu region.

## Schema

| Column         | Type              | Default           | Description                  |
| -------------- | ----------------- | ----------------- | ---------------------------- |
| id             | uuid              | gen_random_uuid() | Primary key                  |
| region_id      | uuid (regions)    | —                 | Relasi ke region             |
| name           | varchar(255)      | —                 | Nama destinasi (Lembang)     |
| slug           | varchar(255)      | —                 | URL slug (unique)            |
| description    | text              | null              | Deskripsi destinasi          |
| image          | uuid (files)      | null              | Foto utama                   |
| gallery        | json              | null              | Array UUID file gambar       |
| status         | varchar(20)       | 'draft'           | draft / published / archived |
| created_at     | timestamptz       | now()             | Audit                        |
| updated_at     | timestamptz       | now()             | Audit                        |
| deleted_at     | timestamptz       | null              | Soft delete                  |
| created_by     | uuid (users)      | null              | Pembuat                      |
| updated_by     | uuid (users)      | null              | Pengubah terakhir            |

## Indexes

- `destinations_pkey` — Primary key
- `destinations_slug_unique` — Unique slug
- `destinations_region_id_idx` — Filter by region
- `destinations_status_idx` — Filter by status

## Relations

- `region_id` → `regions.id`
- `image` → `directus_files.id`
- `gallery` → JSON array of `directus_files.id`
- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## Notes

- Satu region bisa memiliki banyak destinasi.
- `gallery` berupa JSON array berisi UUID file dari Directus.
