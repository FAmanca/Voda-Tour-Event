# Product Requirements Document (PRD)

## Voda Tour & Event

**Version:** 2.0
**Status:** Planning
**Domain:** vodaeventorganizer.id

---

## 1. Project Overview

Voda Tour & Event adalah website Company Profile + Dynamic Catalog untuk jasa Event Organizer dan Travel. Website berfungsi sebagai **brosur online interaktif** yang menampilkan destinasi dan paket wisata/gathering.

Tidak ada fitur booking online, pembayaran, atau akun pelanggan. Seluruh transaksi melalui WhatsApp resmi perusahaan.

## 2. Business Goals

- Menampilkan katalog paket wisata dan gathering secara profesional
- SEO optimal agar calon pelanggan mudah menemukan website
- Admin (non-teknis) bisa mengelola konten sendiri tanpa developer
- Seluruh calon pelanggan diarahkan ke WhatsApp

## 3. Target Audience

- **HR / Event Planner** perusahaan (gathering, outbound, seminar)
- **Individu / Pasangan / Kelompok kecil** (private trip)
- **Siapa pun** yang mencari paket wisata dan gathering di berbagai daerah

## 4. Content Hierarchy

```
Region (Bandung, Yogyakarta, Bali, Kepulauan Seribu)
  -> Destinasi (Situ Cileunca, Pulau Pari, dll)
      -> Paket (2D1N, 3D2N, Half Day)
          -> Price Tiers (harga per pax by jumlah peserta)
```

## 5. Halaman Website

### 5.1 Home (Landing Page)
- Grid card region
- Setiap card: nama region, gambar, deskripsi singkat
- CTA ke halaman region

### 5.2 Detail Region
- Header: nama, gambar besar, deskripsi
- List destinasi dalam region

### 5.3 Detail Destinasi
- Header: nama, gambar besar, deskripsi
- List paket yang tersedia
- Setiap paket: nama, durasi, harga mulai, gambar

### 5.4 Detail Paket
- Nama, gambar, deskripsi
- Itinerary (hari per hari)
- Fasilitas
- **Price Tiers** (tabel harga per pax berdasarkan jumlah peserta)
- Galeri
- CTA: Pesan via WhatsApp

### 5.5 Search
- Cari berdasarkan nama region / destinasi / paket
- Hasil: destinasi & paket

### 5.6 Tentang Kami
- Profil perusahaan, visi misi

### 5.7 Kontak
- Alamat, nomor WA, email, sosial media

## 6. Fitur Admin (via Directus)

Login via `/directus`:
1. **Region** — CRUD: nama, slug, deskripsi, gambar
2. **Destinasi** — CRUD: region_id, nama, slug, deskripsi, gambar
3. **Paket** — CRUD: destinasi_id, nama, slug, deskripsi, durasi, itinerary, fasilitas, price tiers, galeri
4. **Galeri** — upload & manage gambar
5. **Settings** — nomor WA, email, alamat, sosial media, site name

## 7. Permission Matrix

| Feature | Super Admin | Admin Staff |
|---------|-------------|-------------|
| Region CRUD | ✅ | ❌ |
| Destinasi CRUD | ✅ | ✅ |
| Paket CRUD | ✅ | ✅ |
| Settings | ✅ | ❌ |
| User Management | ✅ | ❌ |

## 8. Out of Scope

- Booking online
- Payment gateway
- Akun pelanggan
- Cart / wishlist
- Review / rating
- Live chat
- Manajemen kuota / ketersediaan

## 9. Non Functional Requirements

- **Mobile First** — responsive untuk semua device
- **SEO** — meta tags, OG, JSON-LD, canonical, sitemap, robots.txt
- **Performa** — Lighthouse Performance 95+, SEO 100
- **Security** — akses admin via HTTPS, authentication via Directus
- **Design** — modern, clean, minimal, solid colors (no gradient)