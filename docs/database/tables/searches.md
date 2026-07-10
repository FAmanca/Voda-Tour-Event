# Searches

Tabel `searches` menyimpan data pencarian yang dilakukan visitor (anonim) untuk keperluan analisa admin.

## Schema

| Column             | Type          | Default           | Description                    |
| ------------------ | ------------- | ----------------- | ------------------------------ |
| id                 | uuid          | gen_random_uuid() | Primary key                    |
| destination_name   | varchar(255)  | null              | Nama destinasi yg dipilih      |
| region_name        | varchar(255)  | null              | Nama region yg dipilih         |
| activity_type_name | varchar(255)  | null              | Nama jenis kegiatan            |
| pax_count          | integer       | null              | Jumlah peserta                 |
| travel_date        | date          | null              | Tanggal rencana berangkat      |
| ip_hash            | varchar(64)   | null              | Hash IP visitor (anonim)       |
| created_at         | timestamptz   | now()             | Audit                          |
| updated_at         | timestamptz   | now()             | Audit                          |

## Indexes

- `searches_pkey` — Primary key
- `searches_created_at_idx` — Filter by date range

## Relations

Tidak ada foreign key — data disimpan sebagai string bebas untuk kecepatan.

## Notes

- Data bersifat anonim — hanya hash IP yang disimpan, bukan IP asli.
- Admin dapat melihat statistik pencarian: destinasi populer, jumlah peserta rata-rata, tren tanggal.
- Tidak ada `deleted_at` karena data log tidak perlu dihapus.
- Tidak ada `created_by` / `updated_by` karena data berasal dari visitor, bukan admin.