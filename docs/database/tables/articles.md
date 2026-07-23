# Articles

Tabel `articles` menyimpan data blog/artikel untuk konten website, panduan wisata, dan pemasaran.

## Schema

| Column         | Type          | Default           | Description                  |
| -------------- | ------------- | ----------------- | ---------------------------- |
| id             | uuid          | gen_random_uuid() | Primary key                  |
| title          | varchar(255)  | —                 | Judul artikel                |
| slug           | varchar(255)  | —                 | URL slug (unique)            |
| publish_date   | timestamptz       | now()             | Tanggal publikasi            |
| content        | text              | null              | Konten artikel (Rich text)   |
| ads            | alias (O2M)       | null              | Relasi One-to-Many ke `ads`  |
| seo            | json              | null              | Data SEO (custom-seo-analyzer)|
| status         | varchar(20)       | 'draft'           | draft / published / archived |
| user_created   | uuid (users)  | null              | Pembuat                      |
| date_created   | timestamptz   | now()             | Tanggal dibuat               |
| user_updated   | uuid (users)  | null              | Pengubah terakhir            |
| date_updated   | timestamptz   | now()             | Tanggal diubah               |

## Indexes

- `articles_pkey` — Primary key
- `articles_slug_unique` — Unique slug
- `articles_status_idx` — Filter by status

## Relations

- `image` → `directus_files.id`
- `user_created` → `directus_users.id`
- `user_updated` → `directus_users.id`

## Notes

- Konten (`content`) menggunakan Tiptap atau HTML biasa.
- `seo` terhubung langsung dengan extension `custom-seo-analyzer` untuk mengkalkulasi on-page SEO berdasarkan input `content` dan `title`.
