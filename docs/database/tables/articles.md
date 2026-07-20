# Articles

Tabel `articles` menyimpan data blog/artikel untuk konten website, panduan wisata, dan pemasaran.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| title          | varchar(255)  | —                 | Judul artikel                |
| slug           | varchar(255)  | —                 | URL slug (unique)            |
| content        | text/html     | null              | Isi artikel (Tiptap/WYSIWYG) |
| image          | uuid (files)  | null              | Featured image artikel       |
| seo            | json          | null              | Data SEO (custom-seo-analyzer)|
| status         | varchar(20)   | 'draft'           | draft / published / archived |
| created_at     | timestamptz   | now()             | Audit                        |
| updated_at     | timestamptz   | now()             | Audit                        |
| deleted_at     | timestamptz   | null              | Soft delete                  |
| created_by     | uuid (users)  | null              | Pembuat                      |
| updated_by     | uuid (users)  | null              | Pengubah terakhir            |

## Indexes

- `articles_pkey` — Primary key
- `articles_slug_unique` — Unique slug
- `articles_status_idx` — Filter by status

## Relations

- `image` → `directus_files.id`
- `created_by` → `directus_users.id`
- `updated_by` → `directus_users.id`

## Notes

- Konten (`content`) menggunakan Tiptap atau HTML biasa.
- `seo` terhubung langsung dengan extension `custom-seo-analyzer` untuk mengkalkulasi on-page SEO berdasarkan input `content` dan `title`.
