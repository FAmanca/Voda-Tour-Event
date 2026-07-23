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
| user_created   | uuid (users)  | null              | Pembuat                      |
| date_created   | timestamptz   | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)  | null              | Pengubah terakhir            |
| date_updated   | timestamptz   | now()             | Tanggal diubah               |

## Indexes

- `activity_types_pkey` — Primary key
- `activity_types_slug_unique` — Unique slug
- `activity_types_status_idx` — Filter by status

## Relations

- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Data bersifat fleksibel — admin dapat menambah jenis kegiatan kapan saja.
- Contoh: Private Trip, Corporate Gathering, Team Building, Family Vacation.
