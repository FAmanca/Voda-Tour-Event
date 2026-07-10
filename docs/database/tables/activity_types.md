# Activity Types

Tabel `activity_types` menyimpan master data jenis kegiatan yang tersedia.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| name           | varchar(255)  | —                 | Nama kegiatan                |
| slug           | varchar(255)  | —                 | URL slug (unique)            |
| description    | text          | null              | Deskripsi                    |
| status         | varchar(20)   | 'draft'           | draft / published / archived |
| created_at     | timestamptz   | now()             | Audit                        |
| updated_at     | timestamptz   | now()             | Audit                        |
| deleted_at     | timestamptz   | null              | Soft delete                  |
| created_by     | uuid (users)  | null              | Pembuat                      |
| updated_by     | uuid (users)  | null              | Pengubah terakhir            |

## Indexes

- `activity_types_pkey` — Primary key
- `activity_types_slug_unique` — Unique slug
- `activity_types_status_idx` — Filter by status

## Relations

- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## Notes

- Data bersifat fleksibel — admin dapat menambah jenis kegiatan kapan saja.
- Contoh: Private Trip, Corporate Gathering, Team Building, Family Vacation.
