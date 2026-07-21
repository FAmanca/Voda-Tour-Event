# Package Activity Types

Tabel `packages_activity_types` menyimpan relasi many-to-many antara paket dan jenis kegiatan.

## Schema

| Column             | Type                    | Default           | Description             |
| ------------------ | ----------------------- | ----------------- | ----------------------- |
| id                 | uuid                    | gen_random_uuid() | Primary key             |
| packages_id        | uuid (packages)         | —                 | Relasi ke paket         |
| activity_types_id  | uuid (activity_types)   | —                 | Relasi ke jenis kegiatan |
| created_at         | timestamptz             | now()             | Audit                   |
| updated_at         | timestamptz             | now()             | Audit                   |

## Indexes

- `packages_activity_types_pkey` — Primary key
- `packages_activity_types_unique` — Unique constraint (packages_id + activity_types_id)
- `packages_activity_types_package_idx` — Filter by package
- `packages_activity_types_activity_idx` — Filter by activity type

## Relations

- `packages_id` → `packages.id`
- `activity_types_id` → `activity_types.id`

## Notes

- Satu paket bisa memiliki banyak jenis kegiatan.
- Satu jenis kegiatan bisa dimiliki oleh banyak paket.
- Contoh: Paket "Bandung Weekend Escape" bisa untuk Private Trip AND Corporate Gathering.