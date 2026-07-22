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
| price_tiers     | json                  | null              | Array multi-tabel tier harga (max 3) |
| addons          | json                  | null              | Array fitur tambahan (opsional)   |
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

Mendukung maksimal 3 tabel harga mandiri (misal: Domestik WNI, Internasional WNA, dll) dengan struktur bertingkat (*nested JSON*):

```json
[
  {
    "table_title": "Harga Domestik (WNI)",
    "tiers": [
      { "min_pax": 2, "max_pax": 4, "price_per_pax": 850000, "description": "Hotel Bintang 3" },
      { "min_pax": 5, "max_pax": 10, "price_per_pax": 750000, "description": "Hotel Bintang 3" }
    ]
  },
  {
    "table_title": "Harga Internasional (WNA)",
    "tiers": [
      { "min_pax": 2, "max_pax": 4, "price_per_pax": 1200000, "description": "Hotel + Guide Inggris" }
    ]
  }
]
```

## addons Format

Menyimpan daftar pilihan opsional/layanan tambahan (*add-ons*) paket:

```json
[
  {
    "addon_name": "Banana Boat",
    "price": 300000,
    "description": "Tambahan wahana air Banana Boat selama 15 menit"
  },
  {
    "addon_name": "Dokumentasi Drone",
    "price": 1500000,
    "description": "Dokumentasi foto & video udara menggunakan DJI Drone"
  }
]
```

## Notes

- Satu destinasi bisa memiliki banyak paket.
- Penentuan harga final ditentukan oleh jumlah peserta (pax), dicocokkan dengan `price_tiers`.
