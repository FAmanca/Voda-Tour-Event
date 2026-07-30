# Ekstensi Hook: `publish-cron` (Auto-Publish Artikel Terjadwal)

> **Versi Dokumen**: 1.0 — 2026-07-28
> **Tipe Ekstensi**: Directus Schedule Hook (Background Worker)
> **File Sumber**: `extensions/publish-cron/src/index.js`

---

## 1. Fungsi & Tujuan

Ekstensi `publish-cron` adalah sebuah *background hook* yang berjalan secara otomatis setiap menit di dalam server Directus. Tugasnya adalah memindai tabel `articles` dan secara otomatis mengubah status artikel dari `"scheduled"` menjadi `"published"` ketika nilai `publish_date`-nya sudah terlewati.

### Mengapa Hook Extension, Bukan Directus Flow?

Fitur jadwal ini **tidak menggunakan Directus Flow (Visual No-Code)** karena dua keterbatasan yang ditemukan saat pengembangan:

| Masalah | Penjelasan |
|---------|------------|
| **Bulk update tidak andal** | Block `item-update` di Flow tidak dapat memproses banyak ID sekaligus (`array`). Log menunjukkan "sukses" tapi status di database tidak berubah. |
| **Konflik timezone** | Flow menggunakan `$NOW` (UTC), sedangkan kolom `publish_date` di tabel `articles` bertipe `timestamp without time zone` — artinya waktu disimpan secara literal (WIB) tanpa info zona. Perbandingan langsung UTC vs WIB menyebabkan selisih 7 jam, sehingga artikel tidak pernah ter-publish tepat waktu. |

Hook Extension ini mengatasi keduanya menggunakan `ItemsService.updateMany()` dan konversi zona waktu eksplisit ke **Asia/Jakarta (WIB)**.

---

## 2. Cara Kerja

```
Setiap 1 menit (cron: * * * * *)
    │
    ├─ Ambil waktu sekarang dalam WIB (Asia/Jakarta)
    │    → Format: "YYYY-MM-DDTHH:mm:ss" (tanpa offset)
    │
    ├─ Query: articles WHERE status = 'scheduled' AND publish_date <= now_wib
    │
    ├─ Jika ada hasil:
    │    → updateMany(ids, { status: 'published' })
    │    → console.log("[publish-cron] ✅ Published N scheduled article(s)."
    │
    └─ Jika error:
         → console.error("[publish-cron] ❌ Error:", message)
```

---

## 3. Konfigurasi

| Variabel | Lokasi | Nilai | Keterangan |
|----------|--------|-------|------------|
| `TIMEZONE` | `src/index.js` baris 26 | `'Asia/Jakarta'` | Zona waktu untuk perbandingan `publish_date`. Ubah jika server pindah zona. |
| Cron schedule | `src/index.js` baris 56 | `'* * * * *'` | Setiap menit. Ubah ke `'*/5 * * * *'` jika ingin setiap 5 menit. |

---

## 4. Deployment

Setiap kali melakukan modifikasi pada kode sumber, jalankan alur berikut:

```bash
# 1. Build bundle
cd /home/famanca/voda-tour-event/extensions/publish-cron
npm run build

# 2. Deploy ke Docker dan atur permission
cd /home/famanca/voda-tour-event
docker cp extensions/publish-cron/dist/. voda-directus:/directus/extensions/publish-cron/dist/
docker exec -u root voda-directus chmod -R 777 /directus/extensions

# 3. Restart Directus
docker restart voda-directus

# 4. Verifikasi
sleep 5 && docker logs voda-directus --tail 20 | grep publish-cron
```

Pastikan log menampilkan baris berikut saat startup (tanpa error):
```
[INFO] Loaded extensions: ..., publish-cron, ...
```

---

## 5. Cara Menggunakan Fitur Scheduled Article

1. Di panel admin Directus, buka modul **Article Editor**.
2. Buat atau edit artikel yang ingin dijadwalkan.
3. Ubah **Status** artikel menjadi `Scheduled`.
4. Isi field **Tanggal Terbit** (`publish_date`) dengan tanggal dan jam yang diinginkan **(gunakan waktu WIB)**.
5. Klik **Simpan**.
6. Dalam maksimal **1 menit** setelah jam yang ditentukan, artikel akan otomatis berubah menjadi `Published` dan muncul di website.

> **Catatan**: Kolom `publish_date` di tabel `articles` adalah `timestamp without time zone`. Selalu isikan waktu dalam **WIB (GMT+7)**, bukan UTC.

---

## 6. Troubleshooting

| Gejala | Kemungkinan Penyebab | Solusi |
|--------|----------------------|--------|
| Artikel tidak ter-publish otomatis | Ekstensi tidak termuat | Cek log: `docker logs voda-directus --tail 50 \| grep publish-cron` |
| Error `FORBIDDEN` di log | Field `publish_date` tidak ada di collection target | Cek schema tabel — pastikan field tersebut ada |
| Error `Invalid payload` | Salah fungsi update (`updateBatch` vs `updateMany`) | Gunakan `updateMany(keys, data)` — **bukan** `updateBatch` |
| Waktu publish meleset ~7 jam | Timezone tidak dikonfigurasi | Pastikan konstanta `TIMEZONE = 'Asia/Jakarta'` di `src/index.js` |
