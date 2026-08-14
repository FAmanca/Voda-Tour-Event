# Perencanaan Fitur Sewa Kendaraan (Transport)

## 1. Konsep Utama
Fitur "Transport" dirancang untuk menyewakan kendaraan wisata kepada pengguna, terpisah dari paket wisata yang ada. Agar alur penyewaan cepat (high conversion rate), pengguna **tidak akan masuk ke halaman detail**. Dari daftar kendaraan per daerah, mereka dapat langsung melihat harga dan spesifikasi kunci, lalu langsung terhubung ke WhatsApp admin.

---

## 2. Skema Database (Directus)
Dua koleksi baru di Directus untuk memisahkan data kendaraan dari data paket wisata:

### A. Koleksi `transport_regions` (Daerah/Domisili Transport)
- `id` (UUID) - Primary Key
- `status` (String) - published/draft
- `name` (String) - Nama daerah (misal: "Bandung", "Bali")
- `slug` (String) - URL friendly name (misal: "bandung")
- `image` (File Image) - Foto representasi daerah
- `sort_order` (Integer) - Urutan tampilan

### B. Koleksi `transports` (Daftar Kendaraan)
- `id` (UUID) - Primary Key
- `status` (String) - published/draft
- `region_id` (M2O ke `transport_regions`) - Relasi ke daerah mana kendaraan ini berada
- `name` (String) - Nama kendaraan (misal: "Hiace Commuter 15 Seat")
- `type` (String) - Jenis (misal: "Minibus", "Big Bus", "MPV")
- `capacity` (Integer) - Kapasitas penumpang maksimal (misal: 15)
- `starting_price` (Integer) - Harga sewa mulai dari (misal: 1200000)
- `featured_image` (File Image) - Foto kendaraan
- `description` (Text) - Deskripsi spesifikasi/ketentuan (opsional, tampil di card list)
- `sort_order` (Integer) - Urutan tampilan

---

## 3. Struktur URL & Routing (Astro)

Terdapat 2 layer halaman (rute) di frontend:

1. **`/transport`**
   - Halaman utama sewa kendaraan.
   - Menampilkan Grid daerah/domisili (`transport_regions`).
2. **`/transport/[region-slug]`**
   - Halaman daftar kendaraan untuk daerah spesifik (misal: `/transport/bandung`).
   - Menampilkan Grid kartu kendaraan (`transports`).
   - Setiap kartu berisi foto kendaraan, kapasitas, harga, spesifikasi singkat, dan tombol **"Tanya via WA"**.

---

## 4. Perubahan UI/UX (Frontend)
- **Navbar**: Menambahkan link **"Transport"** pada navigasi utama.
- **Region Card Component**: Komponen untuk memunculkan kotak daerah dengan background image elegan.
- **Vehicle Card Component**: Komponen untuk memunculkan detail kendaraan tanpa perlu klik masuk ke halaman detail. Dilengkapi call-to-action WhatsApp langsung dengan pesan otomatis (misal: "Halo, saya tertarik sewa Hiace Commuter 15 Seat di Bandung...").

---

## 5. Integrasi API
- Mengupdate file `apps/web/src/types/directus.ts` dengan interface `TransportRegion` dan `Transport`.
- Mengupdate file `apps/web/src/lib/directus.ts` dengan fungsi fetcher `getTransportRegions()` dan `getTransportsByRegion(regionSlug: string)`.
