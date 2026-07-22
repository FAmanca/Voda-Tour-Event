# Table: `ads`

Tabel `ads` digunakan untuk menyimpan iklan sponsor yang ditampilkan di *sidebar* halaman Artikel. Karena satu artikel bisa menampilkan lebih dari satu iklan, tabel ini menggunakan relasi **One-to-Many** (O2M) dengan tabel `articles`.

## Schema

| Field Name     | Type (PostgreSQL) | Default Value     | Description                  |
|----------------|-------------------|-------------------|------------------------------|
| id             | uuid              | (auto)            | Primary Key                  |
| image          | uuid (files)      | null              | Foto / Banner iklan (FK)     |
| description    | varchar(255)      | null              | Teks judul/deskripsi iklan   |
| url            | varchar(255)      | null              | Link eksternal iklan         |
| articles_id    | uuid              | null              | Relasi ke tabel `articles`   |
| user_created   | uuid              | null              | Audit                        |
| date_created   | timestamptz       | now()             | Audit                        |
| user_updated   | uuid              | null              | Audit                        |
| date_updated   | timestamptz       | now()             | Audit                        |

## Relasi

- **Many-to-One (M2O)** ke `articles`: Satu iklan selalu terikat dengan satu spesifik artikel (atau bisa null jika diparkir).
- **Many-to-One (M2O)** ke `directus_files`: Mengambil _asset_ gambar untuk *banner* iklan.

## Konfigurasi Directus (UI)

- Pada koleksi `articles`, secara otomatis akan muncul *Alias field* bernama `ads` bertipe **One to Many** setelah relasi ini dibuat.
- Pada `articles_id`, *On Delete* disarankan diatur ke `SET NULL` atau `CASCADE`. 
