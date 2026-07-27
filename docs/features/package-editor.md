# Modul Ekstensi Kustom: Paket Wisata Editor (`package-editor`)

Modul **Paket Wisata Editor** (`package-editor`) adalah ekstensi kustom Directus bergaya **Visual Page Builder (ala Elementor / WordPress Gutenberg)** yang dirancang khusus untuk mengelola data penawaran tour dan travel pada ekosistem Voda Tour & Event. Ekstensi ini menggantikan form standar Directus dengan antarmuka interaktif yang langsung mencerminkan tampilan halaman publik di frontend Astro (`apps/web/src/pages/paket/[slug].astro`).

---

## 1. Arsitektur & Antarmuka UI/UX

Modul ini menggunakan sistem **Hybrid Layout** dengan 2 mode tampilan utama:

### A. Mode Dashboard (Table List View ala Artikel)
- **Komponen Pembungkus**: Menggunakan `<private-view title="Daftar Paket Wisata">` untuk integrasi natif dengan kerangka admin Directus.
- **Top Search Bar**: Pencarian cepat berposisi di bagian atas (`.dashboard-top-search`) yang mendukung pencarian berdasarkan nama paket atau slug URL secara *real-time*.
- **Sidebar Filter Status (`#navigation`)**: Menggunakan akordeon `<sidebar-detail icon="filter_alt">` di panel navigasi kiri dengan opsi filter:
  - *Semua Paket*
  - *Published* (diikuti indikator dot hijau)
  - *Draft* (diikuti indikator dot oranye)
  - *Archived* (diikuti indikator dot abu-abu)
- **Top Action Button (`#actions`)**: Tombol ikon bulat tunggal (`+`) untuk membuat paket wisata baru dengan *placeholder data* berstandar Voda Tour.
- **Tabel Responsif Modern**:
  - Kolom **Gambar**: Menampilkan thumbnail poster/cover berukuran 50x50px dengan sudut membulat.
  - Kolom **Nama & Slug**: Judul utama paket dan link URL relatif (`/paket/slug`).
  - Kolom **Destinasi**: Menampilkan nama daerah tujuan wisata dengan ikon pin lokasi oranye.
  - Kolom **Durasi & Max Pax**: Menampilkan badge durasi (misal: *3 Hari 2 Malam*) dan kapasitas maksimal peserta (misal: *15 Orang*).
  - Kolom **Harga Mulai**: Menghitung secara otomatis harga terendah dari seluruh kategori tabel harga dan menampilkannya dalam format Rupiah (`Rp X.XXX.XXX`).
  - Kolom **Status**: Badge dengan warna bergaris jelas (Hijau, Oranye, Abu-abu).
  - Kolom **Aksi**: Tombol ikon tunggal (*icon-only round secondary button*) untuk **Edit** (`edit`, warna oranye) dan **Hapus** (`delete`, warna merah).

### B. Mode Editor (Fullscreen Visual Builder - Takeover Mode)
Ketika pengguna mengklik baris paket atau tombol edit/tambah, modul masuk ke dalam mode layar penuh (Gutenberg/Elementor Takeover Mode).
- **Z-Index Golden Rule (`z-index: 150 !important`)**: Kontainer utama `.editor-view` berada di atas navigasi kiri dan header admin Directus (kisaran `20 - 100`), namun tetap berada **di bawah** modal dialog standar Directus (`500 - 1000`). Hal ini menjamin bebas dari *deadlock UI freeze* dan masalah backdrop bergeser.
- **Smooth Vertical Scroll**: Kontainer scroll utama (`.editor-main-scroll`) menggunakan `flex: 1; overflow-y: auto; overflow-x: hidden;`, memastikan seluruh seksi dari atas hingga bawah dapat digeser dengan sangat lancar dan mulus.
- **Top Navigation Bar**:
  - Kiri: Tombol ikon kembali (`arrow_back`) dan judul status dokumen.
  - Tengah: Breadcrumbs interaktif (`Voda Tour & Event › Paket › [slug]`) dengan indikator dot warna status.
  - Kanan: Tombol aksi utama **Simpan Paket** (`check`).

---

## 2. Struktur Visual Section (Elementor Style)

Bagian dalam editor dirancang agar pengeditan terasa seperti merakit blok-blok halaman web publik secara langsung:

1. 🖼️ **Hero Banner Visual (Tanpa Hero-Controls Box)**:
   - Menampilkan gambar latar (*Cover Banner*) dengan gradasi gelap di bagian bawah (`hero-gradient-overlay`) agar kontras teks putih selalu tajam.
   - Tombol aksi media di pojok kanan atas untuk mengganti **Gambar Cover Banner** (`image`) dan **Poster Thumbnail Vertikal** (`portrait`).
   - Input langsung pada area banner (*inline editing*):
     - **Dropdown Destinasi**: Pill tembus pandang di atas judul.
     - **Judul Paket**: Input teks besar berukuran 40px cetak tebal warna putih langsung di atas gambar.
     - **Slug Pill**: Pengatur URL relatif (`vodatrip.id/paket/[slug]`).
     - **Visual Badges Bar**: Input interaktif untuk Durasi, Maksimal Peserta, dan Status langsung dalam bentuk *pill glassmorphism*.
     - **Interactive Activity Chips**: Daftar tema/kategori wisata (misal: *Adventure*, *Family*, *Honeymoon*) yang dapat dipilih atau dibatalkan cukup dengan satu klik (*toggle chip*).

2. 📝 **Overview / Tentang Paket Ini (Rich Text TipTap Editor)**:
   - Terintegrasi penuh dengan editor WYSIWYG **TipTap** (`@tiptap/vue-3`, `@tiptap/starter-kit`).
   - Dilengkapi *Toolbar* pembentuk format: Bold, Italic, Underline, Heading 2, Heading 3, Bullet List, Numbered List, Blockquote, Rata Kiri/Tengah, serta Undo/Redo.
   - Memiliki proteksi `word-wrap: break-word` agar teks tidak pernah merusak batas lebar kanvas.

3. 🗺️ **Rencana Perjalanan (Itinerary Timeline Builder)**:
   - Menampilkan alur waktu (*timeline*) hari per hari dengan garis vertikal penghubung persis seperti pada komponen `ItineraryTimeline.astro`.
   - **Kartu Hari**: Memiliki badge lingkaran oranye (`Hari 1`, `Hari 2`), input judul hari, serta tombol hapus hari.
   - **Daftar Kegiatan (Bullet Points)**: Setiap kegiatan memiliki titik bullet biru gelap, input teks rincian aktivitas dan jam, serta tombol hapus ikon tunggal (`close`).
   - Dilengkapi tombol cepat `+ Tambah Kegiatan` di setiap hari dan tombol utama `+ Tambah Hari Perjalanan` di bagian bawah.

4. ✅ **Fasilitas & Layanan (Termasuk & Tidak Termasuk)**:
   - Daftar periksa visual (*visual checklist*) dengan ikon centang hijau (`check_circle`) di setiap barisnya.
   - Tombol ikon tunggal untuk menggeser posisi fasilitas ke atas (`arrow_upward`), ke bawah (`arrow_downward`), atau menghapusnya (`delete`).
   - Tombol cepat `+ Tambah Fasilitas Termasuk`.

5. 💰 **Harga Paket & Biaya Tambahan (Price Tiers & Add-ons)**:
   - **Tabel Harga Utama (`price_tiers`)**: Mendukung hingga 3 kategori tabel harga (misal: *Domestik WNI*, *Wisatawan Asing*, *Private Tour*). Setiap tabel memiliki judul input dan kolom untuk `Min Pax`, `Max Pax`, `Harga / Orang (Rp)` (dengan pemformatan otomatis mata uang), dan `Keterangan / Kelas Hotel`.
   - **Tabel Biaya Tambahan (`addons`)**: Seksi khusus untuk layanan tambahan opsional (misal: *Dokumentasi Drone*, *Upgrade Kamar Hotel*) lengkap dengan nominal harga dan deskripsi.

6. 📸 **Galeri Foto Dokumentasi (`gallery`)**:
   - Menampilkan grid kartu foto dokumentasi yang responsif.
   - Tombol hapus muncul saat kartu foto dilintasi kursor (*hover overlay*).
   - Kartu putus-putus (*dashed card*) `+ Tambah Foto Galeri` untuk membuka Directus Media Library.

---

## 3. Skema & Relasi Database

Modul `package-editor` terhubung langsung dengan koleksi database di Directus:

| Koleksi / Tabel | Peran / Deskripsi | Field Utama yang Digunakan |
| :--- | :--- | :--- |
| **`packages`** | Tabel utama paket wisata | `id`, `name`, `slug`, `destination_id` (FK), `status`, `duration`, `max_participants`, `description` (HTML), `facilities` (JSON), `itinerary` (JSON), `price_tiers` (JSON), `addons` (JSON), `image` (FK file), `poster` (FK file). |
| **`destinations`** | Referensi tujuan wisata | `id`, `name`, `slug`. Diambil secara *asynchronous* untuk dropdown opsi. |
| **`activity_types`** | Referensi tema / kategori | `id`, `name`, `slug`. Diambil untuk membentuk interactive chips. |
| **`packages_files`** | Tabel relasi M2M Galeri | Relasi *Many-to-Many* antara `packages.id` dan `directus_files.id` untuk menyimpan daftar urutan foto galeri (`sort`). Di-sinkronisasi otomatis saat proses *Simpan Paket*. |
| **`packages_activity_types`** | Tabel relasi M2M Kategori | Relasi *Many-to-Many* antara `packages.id` dan `activity_types.id`. Di-sinkronisasi secara dinamis melalui operasi `POST` dan `DELETE` ke API internal Directus. |

---

## 4. Panduan Kompilasi & Deployment

Setiap kali melakukan modifikasi pada kode sumber di `/home/famanca/voda-tour-event/extensions/package-editor/src/module.vue`, jalankan alur kerja baku berikut dari terminal:

```bash
# 1. Build bundle ekstensi
cd /home/famanca/voda-tour-event/extensions/package-editor
npm run build

# 2. Deploy bundle ke dalam Docker Container dan atur perizinan
cd /home/famanca/voda-tour-event
docker cp extensions/package-editor/dist/. voda-directus:/directus/extensions/package-editor/dist/
docker exec -u root voda-directus chmod -R 777 /directus/extensions

# 3. Restart layanan Directus untuk memuat bundle terbaru
docker restart voda-directus
```

Setelah itu, lakukan **Hard Refresh** (**Shift + F5** atau **Ctrl + F5**) di browser pada panel admin Directus untuk melihat hasil pembaruannya.
