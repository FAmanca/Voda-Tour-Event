# Transports

Tabel `transports` menyimpan daftar kendaraan yang disewakan berdasarkan daerah operasionalnya.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| region_id      | uuid (fk)     | —                 | Relasi ke transport_regions  |
| name           | varchar(255)  | —                 | Nama kendaraan               |
| type           | varchar(100)  | null              | Jenis (Minibus, Big Bus)     |
| capacity       | integer       | null              | Kapasitas penumpang          |
| starting_price | integer       | null              | Harga sewa mulai dari (Rp)   |
| featured_image | uuid (files)  | null              | Foto utama kendaraan         |
| description    | text          | null              | Spesifikasi / keterangan     |
| status         | varchar(20)   | 'draft'           | draft / published / archived |
| user_created   | uuid (users)  | null              | Pembuat                      |
| date_created   | timestamptz   | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)  | null              | Pengubah terakhir            |
| date_updated   | timestamptz   | now()             | Tanggal diubah               |

## Indexes

- `transports_pkey` — Primary key
- `transports_status_idx` — Filter by status
- `transports_region_idx` — Filter by region_id

## Relations

- `region_id` → `transport_regions.id` (Many-to-One)
- `featured_image` → `directus_files.id`
- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Hanya status `published` yang tampil di public API.
