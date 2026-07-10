# Packages

Tabel `packages` menyimpan data paket wisata yang ditawarkan untuk setiap destinasi.

## Schema

| Column          | Type                  | Default           | Description                       |
| --------------- | --------------------- | ----------------- | --------------------------------- |
| id              | uuid                  | gen_random_uuid() | Primary key                       |
| destination_id  | uuid (destinations)   | —                 | Relasi ke destinasi               |
| name            | varchar(255)          | —                 | Nama paket                        |
| slug            | varchar(255)          | —                 | URL slug (unique)                 |
| description     | text                  | null              | Deskripsi paket                   |
| duration        | varchar(50)           | —                 | Durasi ("2D1N", "3D2N", "Half Day") |
| itinerary       | json                  | null              | Array jadwal per hari             |
| facilities      | json                  | null              | Array fasilitas                   |
| price_tiers     | json                  | null              | Array tier harga                  |
| gallery         | json                  | null              | Array UUID file gambar            |
| status          | varchar(20)           | 'draft'           | draft / published / archived      |
| created_at      | timestamptz           | now()             | Audit                             |
| updated_at      | timestamptz           | now()             | Audit                             |
| deleted_at      | timestamptz           | null              | Soft delete                       |
| created_by      | uuid (users)          | null              | Pembuat                           |
| updated_by      | uuid (users)          | null              | Pengubah terakhir                 |

## Indexes

- `packages_pkey` — Primary key
- `packages_slug_unique` — Unique slug
- `packages_destination_id_idx` — Filter by destination
- `packages_status_idx` — Filter by status

## Relations

- `destination_id` → `destinations.id`
- `gallery` → JSON array of `directus_files.id`
- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## price_tiers Format

```json
[
  { "min_pax": 5, "max_pax": 10, "price": 850000, "note": "Minimal 5 orang" },
  { "min_pax": 11, "max_pax": 20, "price": 750000, "note": null },
  { "min_pax": 21, "max_pax": 50, "price": 650000, "note": "Termasuk akomodasi" }
]
```

## Notes

- Satu destinasi bisa memiliki banyak paket.
- Penentuan harga final ditentukan oleh jumlah peserta (pax), dicocokkan dengan `price_tiers`.
