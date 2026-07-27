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
  - Kolom **Durasi**: Menampilkan badge durasi (misal: *3 Hari 2 Malam*).
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
  - Kanan: Tombol aksi utama **Simpan Paket Wisata** dengan ikon centang di dalam teks yang bebas dari pemotongan.

---

## 2. Struktur Visual Section (Elementor Style)

Bagian dalam editor dirancang agar pengeditan terasa seperti merakit blok-blok halaman web publik secara langsung:

1. 🖼️ **Hero Banner Visual (Tanpa Hero-Controls Box & Tanpa Input Max Pax)**:
   - Menampilkan gambar latar (*Cover Banner*) dengan gradasi gelap di bagian bawah (`hero-gradient-overlay`) agar kontras teks putih selalu tajam.
   - Tombol aksi media di pojok kanan atas untuk mengganti **Gambar Cover Banner** (`image`) dan **Poster Thumbnail Vertikal** (`portrait`).
   - Input langsung pada area banner (*inline editing*):
     - **Searchable Destination Dropdown**: Pill interaktif (`← [pin] Bali v`) yang saat diklik memunculkan popover pencarian cepat (`Cari destinasi...`), memudahkan admin memilih destinasi dari puluhan daftar tujuan wisata.
     - **Judul Paket**: Input teks besar berukuran 38-40px cetak tebal warna putih langsung di atas gambar.
     - **Slug Pill**: Pengatur URL relatif (`vodatrip.id/paket/[slug]`).
     - **Visual Badges Bar**: Input interaktif untuk Durasi (*3 Hari 2 Malam*), Harga Mulai (*Mulai Rp X.XXX.XXX/org* yang dihitung otomatis), dan Status dokumen langsung dalam bentuk *pill glassmorphism*. Badge kapasitas maksimal ("Max Pax") yang kaku telah dihapus dari banner karena kapasitas sekarang dikelola secara presisi pada Tabel Harga.
     - **Interactive Activity Chips**: Daftar tema/kategori wisata (misal: *Adventure*, *Family*, *Honeymoon*) yang dapat dipilih atau dibatalkan cukup dengan satu klik (*toggle chip*).

2. 📝 **Overview / Tentang Paket Ini (Rich Text TipTap Editor)**:
   - Terintegrasi penuh dengan editor WYSIWYG **TipTap** (`@tiptap/vue-3`, `@tiptap/starter-kit`).
   - Dilengkapi *Toolbar* pembentuk format: Bold, Italic, Underline, Heading 2, Heading 3, Bullet List, Numbered List, Blockquote, Rata Kiri/Tengah, serta Undo/Redo.
   - Memiliki proteksi `word-wrap: break-word` agar teks tidak pernah merusak batas lebar kanvas.

3. ⚖️ **Layout 2 Kolom Berdampingan (Side-by-Side 1fr 1.5fr - Fasilitas & Itinerary)**:
   - Diimplementasikan dengan **Standard CSS Murni** (`display: grid; grid-template-columns: 1fr 1.5fr; gap: 32px;`) tanpa ketergantungan pada class utilitas eksternal seperti Tailwind CSS. Hal ini menjamin tampilan di Directus Admin UI 100% konsisten dan berdampingan persis seperti pada halaman frontend publikasinya (`paket/[slug].astro`).
   - **Kolom Kiri (1fr) — Fasilitas Termasuk**: Kartu putih bergaris dengan daftar periksa visual (*visual checklist*) berikon centang hijau (`check_circle`), input teks fasilitas, serta tombol geser atas/bawah (`↑` / `↓`) dan hapus.
   - **Kolom Kanan (1.5fr) — Rencana Perjalanan (Itinerary Timeline)**: Alur waktu (*timeline*) terbuka dengan garis vertikal lurus kontinu dari atas ke bawah tanpa kotak card per hari yang mengurung. Memiliki marker bulat oranye (`01`, `02`), input judul hari, serta daftar kegiatan bertanda *bullet* titik kecil.

4. 💰 **Tabel Harga Berdampingan & Biaya Tambahan (Price Tiers & Add-ons)**:
   - **Price Tables Grid**: Apabila paket memiliki 2 atau 3 kategori tabel harga (misal: *Domestik WNI*, *Wisatawan Asing*, *Private Tour*), tabel secara otomatis menyusun diri dalam format grid horizontal (2 kolom atau 3 kolom berdampingan) sesuai perilaku komponen `PriceTable.astro`.
   - **Desain Tabel Persis Frontend**: Menggunakan header Navy (`#0B2340`) dengan teks putih, serta kolom harga bercetak tebal warna oranye.
   - **Tabel Biaya Tambahan (`addons`)**: Seksi khusus untuk layanan tambahan opsional (misal: *Dokumentasi Drone*, *Upgrade Kamar Hotel*) lengkap dengan nominal harga dan deskripsi.

5. 📸 **Galeri Foto Dokumentasi (`gallery`)**:
   - Menampilkan grid kartu foto dokumentasi yang responsif.
   - Tombol hapus muncul saat kartu foto dilintasi kursor (*hover overlay*).
   - Kartu putus-putus (*dashed card*) `+ Tambah Foto Galeri Dokumentasi` untuk membuka Directus Media Library.

6. ➕ **Sistem Tombol Aksi Tambah yang Jelas & Responsif (+ Prefix & Zero Clipping)**:
   - Untuk mencegah masalah teks terpotong (*text clipping*) akibat pemaksaan mode ikon bujur sangkar (square icon button) oleh komponen `<v-button>` Directus SDK, seluruh atribut `icon="..."` pada tombol bertuliskan teks telah dihapus.
   - Diterapkan aturan CSS universal `:deep(.v-button) { width: auto !important; min-width: fit-content !important; overflow: visible !important; }` sehingga tombol selalu meregang menyesuaikan panjang teks di dalamnya.
   - Setiap tombol penambahan elemen dilabeli dengan teks bahasa Indonesia yang sangat jelas dan diawali tanda plus (`+`) berwarna oranye cetak tebal:
     - `+ Tambah Fasilitas Termasuk`
     - `+ Tambah Kegiatan Itinerary`
     - `+ Tambah Hari Perjalanan Baru`
     - `+ Tambah Baris Harga (Pax)`
     - `+ Tambah Kategori Tabel Harga (misal: WNI/WNA/Bintang 4)`
     - `+ Tambah Layanan Add-on`
     - `+ Tambah Foto Galeri Dokumentasi`

---

## 3. Skema & Relasi Database

Modul `package-editor` terhubung langsung dengan koleksi database di Directus:

| Koleksi / Tabel | Peran / Deskripsi | Field Utama yang Digunakan |
| :--- | :--- | :--- |
| **`packages`** | Tabel utama paket wisata | `id`, `name`, `slug`, `destination_id` (FK), `status`, `duration`, `max_participants`, `description` (HTML), `facilities` (JSON), `itinerary` (JSON), `price_tiers` (JSON), `addons` (JSON), `image` (FK file), `poster` (FK file). |
| **`destinations`** | Referensi tujuan wisata | `id`, `name`, `slug`. Diambil secara *asynchronous* untuk searchable dropdown popover. |
| **`activity_types`** | Referensi tema / kategori | `id`, `name`, `slug`. Diambil untuk membentuk interactive chips. |
| **`packages_files`** | Tabel relasi M2M Galeri | Relasi *Many-to-Many* antara `packages.id` dan `directus_files.id` untuk menyimpan daftar urutan foto galeri (`sort`). Di-sinkronisasi otomatis saat proses *Simpan Paket Wisata*. |
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
