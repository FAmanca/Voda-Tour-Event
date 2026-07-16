# Settings

Tabel `settings` menyimpan konfigurasi global website.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| key            | varchar(255)  | —                 | Kunci setting (unique)       |
| value          | text          | null              | Nilai setting                |
| created_at     | timestamptz   | now()             | Audit                        |
| updated_at     | timestamptz   | now()             | Audit                        |
| deleted_at     | timestamptz   | null              | Soft delete                  |
| created_by     | uuid (users)  | null              | Pembuat                      |
| updated_by     | uuid (users)  | null              | Pengubah terakhir            |

## Indexes

- `settings_pkey` — Primary key
- `settings_key_unique` — Unique key

## Relations

- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## Data Examples

| key           | value                          |
|---------------|--------------------------------|
| site_name     | Voda Tour & Event           |
| whatsapp      | 6281234567890                  |
| email         | hello@vodatrip.id             |
| address       | Jakarta, Indonesia             |
| instagram     | @vodatrip                     |
| hero_title    | Jelajahi Keindahan Indonesia   |
| hero_subtitle | Private trip & corporate gathering terbaik |

## Notes

- Key-value sederhana, dapat ditambah kapan saja tanpa perubahan schema.
- Frontend membaca semua settings via API untuk konfigurasi tampilan.