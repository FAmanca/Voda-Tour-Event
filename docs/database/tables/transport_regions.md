# Transport Regions

Tabel `transport_regions` menyimpan data wilayah/region operasional untuk penyewaan kendaraan (terpisah dari daerah paket wisata).

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| name           | varchar(255)  | —                 | Nama daerah (Bandung, Bali)  |
| slug           | varchar(255)  | —                 | URL slug (unique)            |
| image          | uuid (files)  | null              | Foto utama daerah            |
| status         | varchar(20)   | 'draft'           | draft / published / archived |
| user_created   | uuid (users)  | null              | Pembuat                      |
| date_created   | timestamptz   | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)  | null              | Pengubah terakhir            |
| date_updated   | timestamptz   | now()             | Tanggal diubah               |

## Indexes

- `transport_regions_pkey` — Primary key
- `transport_regions_slug_unique` — Unique slug
- `transport_regions_status_idx` — Filter by status

## Relations

- `image` → `directus_files.id`
- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Hanya status `published` yang tampil di public API.
