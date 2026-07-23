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
| user_created   | uuid (users)      | null              | Pembuat                      |
| date_created   | timestamptz       | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)      | null              | Pengubah terakhir            |
| date_updated   | timestamptz       | now()             | Tanggal diubah               |

## Indexes

- `destinations_pkey` — Primary key
- `destinations_slug_unique` — Unique slug
- `destinations_region_id_idx` — Filter by region
- `destinations_status_idx` — Filter by status

## Relations

- `region_id` → `regions.id`
- `image` → `directus_files.id`
- `gallery` → JSON array of `directus_files.id`
- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Satu region bisa memiliki banyak destinasi.
- `gallery` berupa JSON array berisi UUID file dari Directus.
