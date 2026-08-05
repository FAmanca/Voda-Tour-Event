# Voda Tour & Event — TODO List Lengkap

> Status: **Dokumentasi Selesai (25 file) → Eksekusi Dimulai**
> Target: Production-ready, documentation-first, bisa dikerjakan AI manapun.

---

## Phase 0: Project Setup (Infra & Env)

### 0.1 Rename Folder (Opsional)
- [x] Rename WSL folder `voda-event/` → `voda-tour-event/`
- [x] Update semua path references di dokumen

### 0.2 Environment Variables
- [x] Bikin `infrastructure/.env.example`
- [x] Bikin `apps/web/.env.example`
- [x] Isi env: `DIRECTUS_URL`, `SITE_URL`, `DATABASE_URL`, `DB_USER`, `DB_PASS`
- [x] Update setup.md — jelasin env file & cara pakai

### 0.3 Docker Infra
- [x] Fix `infrastructure/docker-compose.yml` — env var references + hapus version warning
- [x] Setup PostgreSQL 16 container
- [x] Setup Directus 12 container
- [x] Pastiin volume mounting bener
- [x] `docker compose up -d` — verifikasi kedua container jalan
- [x] Akses Directus admin `http://localhost:8055` — login success

---

## Phase 1: Astro Frontend — Bootstrap

### 1.1 Inisialisasi Project
- [x] `mkdir -p apps/web && cd apps/web`
- [x] Inisialisasi Astro: `pnpm create astro@latest . --template basics --typescript strict`
- [x] Install Tailwind: `pnpm astro add tailwind`
- [x] Install dependencies: `pnpm add @tailwindcss/vite tailwindcss`

### 1.2 Tailwind Config — Design System Mapping
- [x] Setup `src/styles/global.css` dengan `@import "tailwindcss"`
- [x] Define `@theme` block:
  - [x] **Colors:** navy-900/800/700/600, orange-600/500/100, ink, body, body-light, mist, line, paper
  - [x] **Fonts:** `font-display: Poppins`, `font-accent: Playfair Display`, `font-body: Inter`
  - [x] **Border radius:** `--radius-lg: 20px`, `--radius-md: 14px`, `--radius-sm: 10px`
  - [x] **Shadows:** `--shadow-soft`, `--shadow-card` (sesuai design-system)
  - [x] **Container:** max-width 1280px
- [x] Load Google Fonts di Layout.astro (Poppins 500-800, Playfair Display italic 400, Inter 400-700)
- [x] Load Font Awesome 6 CDN di Layout.astro

### 1.3 Base Layout
- [x] `src/layouts/Layout.astro`:
  - [x] Meta tags base (charset, viewport, lang="id")
  - [x] SEO meta (title, description, og:image generator)
  - [x] Preconnect Google Fonts + Font Awesome CDN
  - [x] Google Fonts inline `@font-face` atau link
  - [x] Font Awesome CDN script
  - [x] Global CSS import
  - [x] `<Header />` + `<Footer />` wrapper
  - [x] `<slot />` untuk content
  - [x] Scrollbar styling
  - [x] Selection color (navy/orange)

---

## Phase 2: Shared Components

### 2.1 Header (`src/components/Header.astro`)
- [x] Sticky white header, 88px (76px mobile)
- [x] Logo lockup: rotated square + plane icon + "VODA" bold / "TOUR & EVENT" tracked
- [x] Nav links: Beranda, Paket Wisata ▼, Gathering & Event ▼, Destinasi ▼, Tentang Kami, Kontak
- [x] Active state: orange underline offset 10px, 2.5px
- [x] Right side: phone pill (outline) + WA pill (solid orange)
- [x] Mobile: hamburger menu, dropdown nav
- [x] Dropdown untuk Paket Wisata, Gathering & Event, Destinasi (CSS)

### 2.2 Footer (`src/components/Footer.astro`)
- [x] Navy-900 background
- [x] 3-column: logo + deskripsi, navigasi, kontak & sosial
- [x] WhatsApp, email, Instagram link
- [x] Copyright bar

### 2.3 WaButton (`src/components/WaButton.astro`)
- [x] Props: phone, message, label, variant, fullWidth, icon
- [x] Variant: primary (orange solid), outline (orange border), pill
- [x] WA icon + label
- [x] Hover: translateY(-2px)

### 2.4 Eyebrow (`src/components/Eyebrow.astro`)
- [x] Orange uppercase text, 12.5px, 700, tracking-widest
- [x] `::before` 22px horizontal rule

### 2.5 IconBadge (`src/components/IconBadge.astro`)
- [x] Props: icon, size (sm/md/lg), shape (circle/rounded-square), variant (navy/outline/glass)
- [x] Font Awesome icon di dalam shape

### 2.6 PriceDisplay (`src/components/PriceDisplay.astro`)
- [x] Format rupiah: "Rp 850.000" atau "850rb"
- [x] Props: amount, prefix, format, perPax, size
- [x] Font Poppins bold, orange

### 2.7 SkeletonCard (`src/components/SkeletonCard.astro`)
- [x] Animated pulse placeholder
- [x] Variant: package, destinasi, feature
- [x] `animate-pulse` + `bg-gray-200`

---

## Phase 3: Landing Page (`index.astro`)

### 3.1 Hero + SearchCard
- [x] **Hero.astro:**
  - [x] Full-bleed teal/ocean gradient background (`0A3B52` → `8FD6B4`)
  - [x] 2-column grid: copy left, SearchCard right
  - [x] Eyebrow "VODA TOUR & EVENT" (light orange)
  - [x] H1 putih + Playfair italic accent phrase
  - [x] Subheadline putih, max-width 440px
  - [x] 2 CTA buttons: "Cari Paket" (orange) + "Hubungi Kami" (outline white)
  - [x] `hero::before` decorative circles
  - [x] `hero::after` bottom gradient fade
  - [x] Responsive: stack ke 1 kolom di tablet

- [x] **SearchCard.astro:**
  - [x] Navy gradient card (`navy-800` → `navy-900`), `radius-lg`
  - [x] Title "Cari Paket Impianmu" + orange underline
  - [x] 2x2 grid: Destinasi (autocomplete), Kegiatan (dropdown), Peserta (number), Tanggal (date)
  - [x] Form fields styling: glassmorphism (`rgba(255,255,255,.06)` bg, border)
  - [x] Submit button "🔍 Cari Paket" orange full-width
  - [x] On submit → redirect ke `/cari?params=`

### 3.2 FeatureStrip
- [x] **FeatureStrip.astro:**
  - [x] White card, `radius-lg`, `shadow-card`
  - [x] Negative margin `-64px` overlap hero
  - [x] 4-column grid icon + text
  - [x] Icon = 52px navy circle + orange FA icon
  - [x] Features: "Destinasi Terkurasi", "Harga Transparan", "Tim Profesional", "24/7 Support"

### 3.3 SectionHeader
- [x] **SectionHeader.astro:**
  - [x] Eyebrow (orange rule + text)
  - [x] H2 Poppins 700 34px
  - [x] Description optional
  - [x] Layout: "default" (stack) atau "split" (title left, CTA right)

### 3.4 PackageGrid (Paket Pilihan)
- [x] **PackageCard.astro:**
  - [x] White card, `radius-md`, `shadow-soft`
  - [x] Photo gradient area (150px) — color varies by kategori
  - [x] Circular icon badge pinned top-left, overlapping photo edge
  - [x] Body: title (15.5px/600), 2-line description (12.8px)
  - [x] Dashed divider
  - [x] Price row: "Mulai dari" label + bold orange price + navy circle arrow button
  - [x] Hover: translateY(-6px) + deeper shadow

- [x] **PackageGrid.astro:**
  - [x] Fetch 4 latest packages dari Directus
  - [x] 4-col grid (2-col tablet, 1-col mobile)
  - [x] Loading: 4 SkeletonCard
  - [x] Empty: "Belum ada paket tersedia"
  - [x] Error: alert merah + retry

### 3.5 StatsBar + Testimonial
- [x] **StatsBar.astro:**
  - [x] Full-width navy-900 section
  - [x] 4 stat clusters (outlined circle icon + bold number + 2-line label)
  - [x] Vertical hairline rules separator
  - [x] Right column: testimonial card
  - [x] Testimonial: quote icon, 5 orange stars, name + company, circular avatar with orange ring

### 3.6 CTABand
- [x] **CTABand.astro:**
  - [x] Gradient dark section (`122A3D` → `356E78`)
  - [x] Top: heading + description + CTA button, separated by bottom border
  - [x] Bottom: 4 feature chips (rounded-square 38px icon + label)
  - [x] Primary orange CTA button

### 3.7 Landing Page Assembly (`index.astro`)
- [x] Import all components
- [x] SSR fetch: settings, destinations, packages, activity_types
- [x] Render: Header → Hero + SearchCard → FeatureStrip → SectionHeader → PackageGrid → StatsBar → CTABand → Footer
- [x] Loading/error/empty state untuk tiap section
- [x] Responsive: verifikasi breakpoint 1080px & 640px

---

## Phase 4: CRUD Pages

### 4.1 Destinasi List (`/destinasi`)
- [x] `src/pages/destinasi.astro`
- [x] SSR fetch: all destinations + regions
- [x] Grid layout
- [x] Filter by region (optional)
- [x] Search input (client-side filter) — pindah ke halaman /cari

### 4.2 Destinasi Detail (`/destinasi/[slug]`)
- [x] `src/pages/destinasi/[slug].astro`
- [x] SSR fetch: destination by slug + related packages
- [x] Hero variant (DestinasiHeader) dengan gradient
- [x] Region badge
- [x] Description
- [x] GallerySection
- [x] Package list di bawah
- [x] 404 handling kalo slug gak ditemukan (render not-found state)

### 4.3 Paket List (`/paket` + `/gathering`)
- [x] `src/pages/paket.astro` — all packages
- [x] `src/pages/gathering.astro` — packages dengan activity_type = corporate-gathering
- [x] SSR fetch + filter
- [x] Grid cards
- [x] Category filter tabs (client-side)

### 4.4 Paket Detail (`/paket/[slug]`)
- [x] `src/pages/paket/[slug].astro`
- [x] SSR fetch: package by slug + destination
- [x] **ItineraryTimeline:** vertical timeline
  - [x] Day 1, Day 2 markers
  - [x] Title + list activities
- [x] **PriceTable:** 
  - [x] Rows: min-max pax, price/pax, keterangan
- [x] Facilities list (badges/chips)
- [x] Gallery foto
- [x] CTA: WhatsApp dengan prefilled message

### 4.5 Galeri (`/galeri`)
- [x] `src/pages/galeri.astro`
- [x] **GallerySection.astro:** masonry grid
- [x] Fetch all images from packages & destinations

### 4.6 Static Pages
- [x] `src/pages/tentang.astro` — company profile
- [x] `src/pages/kontak.astro` — contact info + WA link + embed GMaps (optional)

### 4.7 Sitemap
- [x] `src/pages/sitemap.xml.ts`
- [x] Generate all dynamic URLs (destinasi, paket)
- [x] Include static pages
- [x] Lastmod from updated_at

---

## Phase 5: Search Feature

### 5.1 Analytics Endpoint (Optional)
- [x] `src/pages/api/search.ts` — POST handler
- [x] Terima: destination_name, region_name, activity_type_name, pax_count, travel_date
- [x] Simpan ke Directus `searches` collection (public create)
- [x] Hash IP visitor (anonim)
- [x] Return matching packages (client-side atau server-side)

### 5.2 Search Form Client (`/cari`)
- [x] **SearchForm.astro:** full-width variant
- [x] Autocomplete destinasi (data embedded from SSR)
- [x] Dropdown kegiatan dari activity_types
- [x] Input jumlah peserta + date picker
- [x] **Client JS (`src/lib/search.js`):**
  - [x] Debounce 300ms pada input destinasi
  - [x] Filter client-side dari data destinasi yg di-load SSR
  - [x] Form submission → POST ke /api/search + redirect ke /cari?params
  - [x] No external requests saat mengetik — 100% client-side

### 5.3 Search Results
- [x] `src/pages/cari.astro` — SSR
- [x] Baca query params, fetch packages dari Directus
- [x] **SearchResult.astro:** list packages + highlight harga sesuai pax
- [x] Empty: "Tidak ditemukan paket untuk pencarian ini"
- [x] CTA: "Hubungi Kami untuk konsultasi" + WA button

### 5.4 Search Analytics
- [x] Verify `searches` table getting data
- [x] Directus panel bisa liat data pencarian (admin)

---

## Phase 6: Backend — Directus Setup

### 6.1 Collections
Buat di Directus Admin Panel:

- [x] **regions**
  - Fields: id (UUID), name (string), slug (string, unique), description (text), image (file), status (select)
  - System: created_at, updated_at, created_by, updated_by

- [x] **destinations**
  - Fields: id (UUID), region_id (M2O → regions), name (string), slug (string, unique), description (text), image (file), gallery (JSON/file[]), status (select)

- [x] **packages**
  - Fields: id (UUID), destination_id (M2O → destinations), name (string), slug (string, unique), description (text), duration (string), itinerary (JSON), facilities (JSON), price_tiers (JSON), gallery (JSON/file[]), status (select)

- [x] **activity_types**
  - Fields: id (UUID), name (string), slug (string, unique), description (text), status (select)

- [x] **packages_activity_types**
  - Fields: id (UUID), package_id (M2O → packages), activity_type_id (M2O → activity_types)
  - Junction: many-to-many

- [x] **settings**
  - Fields: id (UUID), key (string, unique), value (text)

- [x] **searches**
  - Fields: id (UUID), destination_name (string), region_name (string), activity_type_name (string), pax_count (integer), travel_date (date), ip_hash (string)
  - Note: NO status field, NO soft delete. Just log.

### 6.2 Directus Configuration
- [x] Set **Public Role**:
  - regions: Read
  - destinations: Read
  - packages: Read
  - activity_types: Read
  - settings: Read
  - searches: **Create only** (no read)
- [x] Set admin user: `admin@vodatrip.id` / `admin123`
- [x] Test: GET `/items/*` tanpa auth → ✅ semua accessible

### 6.3 Seed Data
- [x] Input via seeder script:
  - Regions: 5 ✅
  - Destinations: 14 (2-3 per region) ✅
  - Packages: 6 (with itinerary, price_tiers, facilities, M2M) ✅
  - Activity Types: 5 ✅
  - Settings: 9 entries ✅
  - Images: need upload via admin panel (Directus files API requires multipart)
- [ ] Upload sample images via Directus file manager — masih perlu manual via admin panel

---

## Phase 7: SEO & Performance

### 7.1 SEO Per Page
- [x] **SEO component** reusable:
  - [x] Title tag + fallback
  - [x] Meta description
  - [x] OG: title, description, image, url, type
  - [x] Twitter card
  - [x] JSON-LD (Organization schema) di Layout
  - [ ] JSON-LD (BreadcrumbList) di halaman detail
  - [x] JSON-LD (Product) untuk halaman paket
- [x] Canonical URL tiap halaman
- [x] `robots.txt` — allow all, point to sitemap
- [x] `sitemap.xml` — dynamic + static pages

### 7.2 Image Optimization
- [x] Semua `<img>` dari Directus pake `?format=webp&quality=80`
- [x] `loading="lazy"` untuk below-fold images
- [x] Preconnect ke image domain
- [x] Asynchronous font loading
- [x] `srcset` untuk responsive images (opsional — bisa lewat Directus params)

### 7.3 Performance
- [x] Font: `display=swap`, preconnect Google Fonts
- [x] Font Awesome: load async/defer
- [x] CSS: Tailwind purged otomatis
- [x] JS: minimal, inline untuk critical, `type="module"` untuk search
- [x] Lighthouse target: ≥90 desktop & mobile

---

## Phase 8: Client-Side JavaScript

### 8.1 Mobile Menu
- [x] Hamburger toggle
- [x] Slide-in nav
- [x] Dropdown accordion untuk submenu  (N/A — semua nav top-level)
- [x] Close on outside click

### 8.2 Search Autocomplete
- [x] `src/lib/search.js`:
  - [x] Debounce 300ms
  - [x] Client-side filter dari data destinasi (embedded di HTML)
  - [x] Render dropdown suggestions
  - [x] Keyboard navigation (arrow keys + enter)
  - [x] Click outside close

### 8.3 Form Submissions
- [x] Search form → POST ke `/api/search` + redirect  (🗑️ obsolete — client-side search)
- [x] WA button → generate wa.me URL dengan prefilled message ✅

---

## Phase 9: Error Pages & Edge Cases

### 9.1 404 Page
- [x] `src/pages/404.astro`
- [x] Ilustrasi + copy ramah
- [x] CTA: kembali ke beranda

### 9.2 500 / Error Page
- [x] Fallback error page
- [x] Minimalis: logo + "Terjadi kesalahan" + refresh button

### 9.3 Edge Case Handling
- [x] Destinasi tanpa paket → empty state ✅
- [x] Paket tanpa price_tiers → "Hubungi kami untuk informasi harga" ✅
- [x] Directus offline → error state gracefully ✅
- [x] Gambar broken → fallback no image sesuai kategori ✅
- [x] Slug duplicate → 404 atau redirect ✅

---

## Phase 10: Production Readiness

### 10.1 Environment & Security
- [x] `infrastructure/.env.example` final
- [x] `apps/web/.env.example` final
- [x] Verify all env vars documented

### 10.2 Server Infrastructure
- [x] Docker compose production variant (no port mapping exposed for DB, etc.)
- [x] Nginx reverse proxy config (optional)
- [ ] SSL certificate (LetsEncrypt / Cloudflare)
- [ ] CI/CD pipeline setup (opsional — bisa manual dulu)

### 10.3 Directus Hardening
- [x] CORS Directus — batasi origins
- [ ] Rate limiting (Directus atau reverse proxy)
- [x] No sensitive data in client
- [ ] IP hashing untuk searches (anonim)
- [x] .env gak ke-commit

### 10.4 Cloudflare R2 Migration (Nanti)
- [ ] Setup R2 bucket
- [ ] Dapetin Access Key + Account ID
- [ ] Update Directus env: uncomment S3 config
- [ ] Migrate existing images (directus storage move or re-upload)
- [ ] Verify image URLs via Directus assets

---

## Phase 11: Testing & QA

### 11.1 Manual Testing Checklist
- [x] Landing page: semua section muncul, responsive
- [x] Nav: semua link jalan, dropdown work, mobile menu
- [x] Destinasi list: data dari Directus muncul
- [x] Destinasi detail: info + packages + gallery
- [x] Paket detail: itinerary, price table, calculator, WA
- [x] Search: autocomplete, form submit, results page
- [x] Galeri: grid masonry work
- [x] Sitemap: semua URL tercakup
- [x] 404: muncul kalo akses slug acak
- [x] Directus admin: bisa CRUD data, Public Read works

### 11.2 Lighthouse
- [x] Desktop ≥ 90
- [x] Mobile ≥ 90
- [x] Core Web Vitals: LCP, FID, CLS

### 11.3 Accessibility
- [x] Tab order: nav → content → footer
- [x] Focus visible: all interactive elements
- [x] Color contrast: WCAG AA
- [x] Screen reader: semantic HTML, aria-label

---

## Phase 12: Documentation Finalization

### 12.1 Code Sync
- [x] Update `docs/frontend/structure.md` kalo ada deviasi selama coding
- [x] Update `docs/development/api-integration.md` kalo endpoint berubah
- [x] Update `.ai/context.md` dengan info baru
- [x] Update `types/directus.ts` kalo ada perubahan model

### 12.2 AI Agent Docs
- [x] Ekspos Halaman Dokumentasi Publik (`llms.txt` / `auth.md`)
- [x] Pastiin `.ai/README.md` masih akurat
- [x] Pastiin CLAUDE.md, CODEX.md, CHATGPT.md, CURSOR.md up-to-date

### 12.3 Final Verification
- [x] `grep -rn "TODO\|FIXME\|HACK\|XXX" apps/web/src` — zero results
- [x] `grep -rn "console.log" apps/web/src` — zero results (kecuali di lib/search.js yg emang client-side)
- [x] `pnpm build` — success
- [x] `pnpm preview` — semua halaman jalan

## Phase 13: Security Hardening & Dependency Updates

### 13.1 Dependency Audits & Updates
- [ ] Upgrade versi `astro` ke `^7.1.6` (atau terbaru) di `apps/web/package.json` untuk menambal kerentanan Moderate XSS.
- [ ] Verifikasi bahwa sub-dependensi `postcss` dan `svgo` yang bermasalah ter-upgrade otomatis.
- [ ] Jalankan ulang `pnpm audit` di `apps/web` untuk memastikan zero vulnerabilities.

### 13.2 Web Server Security Headers (Nginx)
- [ ] Tambahkan security headers di file `infrastructure/nginx/nginx.conf` (HTTP / server block):
  - [ ] `X-Frame-Options: SAMEORIGIN` (mencegah Clickjacking).
  - [ ] `X-Content-Type-Options: nosniff` (mencegah MIME Sniffing).
  - [ ] `X-XSS-Protection: 1; mode=block`.
  - [ ] `Referrer-Policy: strict-origin-when-cross-origin`.
  - [ ] `Strict-Transport-Security` (HSTS).
  - [ ] `Content-Security-Policy` (CSP) untuk membatasi pemuatan external resources (GTM, Google Fonts, Directus).
- [ ] Uji validasi konfigurasi Nginx dan muat ulang web server.

### 13.3 Directus API Permissions Check
- [ ] Verifikasi role `Public` di panel admin Directus agar tidak memiliki hak akses berlebih ke tabel sistem atau data sensitif.

### 13.4 AI Agent Discovery (DNS-AID)
- [x] Publish DNS untuk AI Discovery (DNS-AID) di dashboard provider DNS (misal Cloudflare, Route53, Namecheap).
- [x] Buat record tipe `SVCB` (atau `HTTPS`) dengan nama `_a2a._agents` dan target `vodatrip.id.`.
- [x] Set Parameter: `alpn="a2a" port=443 mandatory=alpn,port`.
- [x] Aktifkan DNSSEC pada provider DNS untuk autentikasi data.
- [x] Verifikasi penyiapan menggunakan API pemindai `https://isitagentready.com/api/scan`.

### 13.5 Server Monitoring & Anti-DDoS
- [ ] Konfigurasi GoAccess di `docker-compose.yml` untuk menganalisa `access.log` Nginx (deteksi IP spam/crawler).
- [ ] Instalasi agen Netdata di VPS untuk memonitor beban hardware (CPU, RAM, Jaringan) secara *real-time*.
- [ ] Cloudflare Hardening: Aktifkan "Bot Fight Mode" dan sesuaikan rule WAF di dashboard Cloudflare.

---


# Phase 2 Voda Tour & Event - TODO List

### 🛠️ 2.1 Layout & Visual Adjustments
- [x] **Pembersihan Kontak Rumah (Header & Footer):**
  - [x] Hapus/sembunyikan nomor telepon rumah statis (misal: "021-xxxx") di komponen [Header.astro](file:///home/famanca/voda-tour-event/apps/web/src/components/Header.astro).
  - [x] Hapus/sembunyikan nomor telepon rumah statis di kolom kontak komponen [Footer.astro](file:///home/famanca/voda-tour-event/apps/web/src/components/Footer.astro).
  - [x] Pastikan hanya menyisakan tombol WhatsApp dan Email yang aktif.
  - [x] Sembunyikan Section Sosmed di footer dan Kontak

---

### 🏷️ 2.3 Penyesuaian Dinamis Harga & Fitur Tambahan (Add-ons) pada Package
- [x] **Refactor Code**
  - [x] Check All file ganti variable yg ga jelas namanya biar memudahkan maintenance
---

### 📰 2.2 Sistem Artikel & Blog (Directus CMS + Astro Frontend)

#### A. Konfigurasi Directus CMS (Backend & Database)
- [x] **Setup Skema Collection `articles`:**
  - Buat tabel/collection baru bernama `articles` dengan field-field berikut:
    - [x] `id` (Tipe: UUID, Primary Key, Auto-generated)
    - [x] `status` (Tipe: String, Dropdown: `draft`, `published`, `archived`)
    - [x] `title` (Tipe: String, Text Input, Required)
    - [x] `slug` (Tipe: String, Unique, interface: `wpslug` agar auto-generate dari title ala WordPress)
    - [x] `content` (Tipe: JSON, interface: `Editor.js` atau WYSIWYG/TipTap untuk editor berbasis blok)
    - [x] `featured_image` (Tipe: File, M2O ke directus_files, WAJIB diisi untuk thumbnail)
    - [x] `publish_date` (Tipe: DateTime, default to current time)
    - [x] `ads` (Tipe: JSON, menampung list maksimal 10 iklan spesifik per artikel. Format: `[{ "image": "uuid-gambar", "url": "link-tujuan" }]`)
    - [x] `seo` (Tipe: JSON, interface: `seo-plugin` untuk meta title, meta desc, SERP preview, dan social OG card preview)
    - [x] System fields: `created_at`, `updated_at`, `created_by`, `updated_by`
- [x] **Instalasi Ekstensi di Directus Studio:**
  - [x] Install **`@directus-labs/seo-plugin`** via Extensions Marketplace.
  - [x] Install **`directus-extension-wpslug-interface`** untuk interface generator slug yang ramah pengguna.
- [x] **Custom SEO Content Analyzer (Yoast/Rank Math Clone):**
  - [x] Buat Custom Interface Extension menggunakan Directus SDK (`defineInterface`).
  - [x] Gunakan Vue 3 `inject('values')` untuk memantau perubahan pada field `content` (WYSIWYG/Editor.js JSON) dan `seo` secara real-time.
  - [x] Integrasikan library NPM **`yoastseo`** di dalam ekstensi untuk memproses kata kunci fokus, kepadatan kata kunci, sebaran heading, dan alt tag gambar, lalu tampilkan checklist skor lampu merah/kuning/hijau di panel editor Directus.
- [x] **Aksesibilitas Perizinan (Roles & Permissions):**
  - [x] Buka perizinan baca (**Read**) secara publik (*Public Role*) untuk collection `articles` agar bisa di-fetch oleh Astro.

#### B. Implementasi di Frontend Astro
- [x] **Install Integrasi & SDK:**
  - [x] Jalankan `npx astro add sitemap` untuk menginstal `@astrojs/sitemap`.
  - [x] Pastikan `@directus/sdk` terinstal di `apps/web/package.json` untuk komunikasi API.
- [x] **Halaman Daftar Artikel (`src/pages/artikel/index.astro`):**
  - [x] Buat halaman baru di `/artikel` untuk menampilkan semua list artikel.
  - [x] Fetch data dari Directus menggunakan SDK, filter artikel dengan `status: "published"`, urutkan dari `publish_date` terbaru (`sort: "-publish_date"`).
  - [x] Gunakan tata letak grid kartu (*Card Grid*), tampilkan `featured_image` yang telah dioptimasi via query params Directus (`?format=webp&quality=80&width=600`).
  - [x] Berikan sistem penomoran halaman (*pagination*) sederhana jika jumlah artikel melebihi 12 item.
- [x] **Halaman Detail Artikel Dinamis (`src/pages/artikel/[slug].astro`):**
  - [x] Buat halaman detail dinamis di `/artikel/[slug]`.
  - [x] Lakukan fetch data artikel tunggal berdasarkan parameter `slug`.
  - [x] Jika slug tidak ditemukan, lempar ke halaman 404 (`Astro.redirect('/404')`).
  - [x] Layout halaman dengan sistem grid kolom: Kolom utama (kiri) untuk thumbnail + konten, dan kolom sidebar (kanan) untuk 'Artikel Lainnya' dan 'Slot Iklan'.
  - [x] Tarik artikel lainnya secara otomatis dengan mencari kecocokan kata kunci dari judul artikel (tanpa field kategori manual).
  - [x] Render maksimal 10 iklan spesifik artikel dari array field `ads` dalam bentuk banner vertikal di bawah 'Artikel Lainnya'.
  - [x] Parse data `content` (JSON Editor.js blocks) ke format HTML bersih menggunakan pustaka helper seperti `editorjs-html` atau buat parser custom di Astro.
  - [x] Ekstrak metadata dari field `seo` (Title, Description, OG Image) dan masukkan ke dalam tag `<head>` menggunakan komponen SEO Layout agar optimal.
- [x] **Integrasi Sitemap Dinamis (`src/pages/sitemap.xml.ts`):**
  - [x] Tulis fungsi sitemap generator agar secara otomatis menarik seluruh `slug` artikel aktif dari Directus dan menambahkannya ke berkas `sitemap.xml`.

---

### 🏷️ 2.3 Penyesuaian Dinamis Harga & Fitur Tambahan (Add-ons) pada Package

#### A. Konfigurasi Directus CMS
- [x] **Modifikasi & Validasi Skema Collection `packages`:**
  - [x] **Struktur Nested JSON `price_tiers` (Repeater di dalam Repeater):**
    Ubah skema/dokumentasi pengisian agar mendukung **maksimal 3 tabel harga** mandiri di dalam satu paket (misalnya: Tabel Harga Domestik WNI, Tabel Harga Asing WNA, atau Durasi Paket berbeda).
    - Format struktur JSON bertingkat yang direncanakan:
      ```json
      [
        {
          "table_title": "Harga Domestik (WNI)",
          "tiers": [
            { "min_pax": 2, "max_pax": 4, "price_per_pax": 850000, "description": "Hotel Bintang 3" },
            { "min_pax": 5, "max_pax": 10, "price_per_pax": 750000, "description": "Hotel Bintang 3" }
          ]
        },
        {
          "table_title": "Harga Internasional (WNA)",
          "tiers": [
            { "min_pax": 2, "max_pax": 4, "price_per_pax": 1200000, "description": "Hotel + Guide Inggris" }
          ]
        }
      ]
      ```
  - [x] **Tambah Field `addons` (Fitur Tambahan/Additional):**
    - Buat field baru di dalam collection `packages` bernama `addons` dengan tipe **JSON** (agar bisa menampung daftar pilihan opsional).
    - Format struktur JSON yang direncanakan:
      ```json
      [
        {
          "addon_name": "Banana Boat",
          "price": 300000,
          "description": "Tambahan wahana air Banana Boat selama 15 menit"
        },
        {
          "addon_name": "Dokumentasi Drone",
          "price": 1500000,
          "description": "Dokumentasi foto & video udara menggunakan DJI Drone"
        }
      ]
      ```

#### B. Implementasi di Frontend Astro
- [x] **Optimasi Komponen Tabel Harga (`src/components/PriceTable.astro`):**
  - [x] Ubah komponen agar dapat merender **hingga maksimal 3 tabel harga** yang berbeda secara berurutan sesuai data bertingkat di JSON `price_tiers`.
  - [x] Tampilkan `table_title` sebagai judul di atas masing-masing tabel harga.
  - [x] Ubah logika kolom di dalam masing-masing tabel agar mendeteksi jumlah objek dalam array `tiers` dan menyesuaikan lebarnya secara dinamis (1, 2, atau 3 kolom).
- [x] **Implementasi Tabel/List Add-ons pada Halaman Detail Paket (`src/pages/paket/[slug].astro`):**
  - [x] **Tata Letak Layout:** Posisikan seksi/tabel tambahan ini **tepat di bawah komponen `PriceTable` (tabel harga utama)** di halaman detail paket `src/pages/paket/[slug].astro`.
  - [x] Buat komponen atau seksi baru untuk merender daftar `addons` tersebut (jika data JSON `addons` terisi di Directus).
  - [x] **Penyelarasan Desain (Styling):** Samakan gaya desain (*styling*), border, warna latar, tipografi, dan padding tabel add-on agar senada (*cohesive*) dengan gaya visual komponen `PriceTable` (tabel harga utama).
  - [x] Tampilkan informasi add-on dalam bentuk baris tabel atau list kartu mini:
    - Nama tambahan (misal: "Banana Boat")
    - Deskripsi singkat
    - Format harga tambahan yang terformat rapi (misal: "+Rp 300.000 / orang" atau "+Rp 1.500.000 / grup").
  - [x] Berikan penanganan fallback jika data `addons` kosong (sembunyikan seksi add-ons secara anggun).

### 3. 📊 Analytics & Tracking

---

# Future Ideas & Backlog (30 Fitur Potensial)

### ⚙️ A. Infrastruktur & DevOps (Server)
- [ ] 1. **Automated Database Backups:** Script cron job harian mem-backup PostgreSQL ke S3/Cloudflare R2.
- [ ] 2. **Uptime & Health Monitoring:** Setup Uptime Kuma untuk notifikasi Telegram jika server mati.
- [ ] 3. **Redis Caching Layer:** Menyimpan hasil query API Directus di memory (Redis) untuk SSR lebih cepat.
- [ ] 4. **CI/CD Pipeline (GitHub Actions):** Sistem deploy otomatis ke VPS setiap kali push ke branch `main`.
- [ ] 5. **Log Aggregation:** Promtail & Grafana Loki untuk memusatkan log Nginx, Astro, dan Directus.
- [ ] 6. **Docker Auto-restart Policies:** Membatasi pemakaian RAM per container (mencegah OOM Killer).
- [ ] 7. **Brotli Compression Nginx:** Mengaktifkan kompresi Brotli untuk ukuran file HTML/CSS yang jauh lebih kecil.

### 🛡️ B. Keamanan & Perlindungan (Security)
- [ ] 8. **Rate Limiting API:** Mencegah spam pada fitur pencarian (Search) atau form kontak.
- [ ] 9. **Mandatory 2FA (Two-Factor Auth):** Mewajibkan seluruh staf mengaktifkan 2FA di admin panel Directus.
- [ ] 10. **Fail2Ban di VPS:** Otomatis memblokir IP jika mencoba membobol SSH atau Nginx berulang kali.
- [ ] 11. **Cloudflare Turnstile (Captcha):** Integrasi invisible captcha pada form interaktif (mencegah bot/spam).
- [ ] 12. **Strict Content-Security-Policy (CSP):** Mengunci sumber asset website (mencegah serangan XSS).

### 📈 C. SEO & Visibilitas Marketing
- [ ] 13. **Dynamic Open Graph (OG) Images:** Auto-generate gambar thumbnail/banner ketika link paket dibagikan.
- [ ] 14. **RSS Feed XML:** Membuat endpoint `/rss.xml` dari koleksi Artikel/Blog.
- [ ] 15. **Advanced JSON-LD Schemas:** Melengkapi Structured Data untuk `FAQPage`, `LocalBusiness`, dan `BreadcrumbList`.
- [ ] 16. **Product Catalog Export (API):** Endpoint API khusus ekspor paket wisata (untuk FB Ads / Google Merchant).
- [ ] 17. **Integrasi Email Auto-responder:** Mengirim email konfirmasi (via Resend/Brevo) saat pengunjung mengisi form.

### 💸 D. Peningkatan Konversi & Bisnis (Fitur Baru)
- [ ] 18. **Lead Capture Form (Intercept WA):** Pengunjung memasukkan Nama & No WA di website *sebelum* tombol WhatsApp terbuka (simpan ke Directus).
- [ ] 19. **Kalender Ketersediaan (Availability Calendar):** Menampilkan kalender tanggal *fully booked* di halaman paket.
- [ ] 20. **Integrasi Google Maps API (Live Reviews):** Menarik review/ulasan bintang 5 asli dari profil Google Maps bisnis Voda.
- [ ] 21. **Fitur "Bandingkan Paket" (Compare):** Pengunjung bisa membandingkan 2-3 paket secara *side-by-side*.
- [ ] 22. **Custom Itinerary Builder:** Fitur drag & drop destinasi untuk membuat custom itinerary (dikirim via form).
- [ ] 23. **Sistem Multi-bahasa (i18n):** Bahasa Indonesia & Inggris (mengakomodir Tabel Harga WNA).
- [ ] 24. **Payment Gateway Integration:** Integrasi Midtrans/Xendit agar klien bisa langsung membayar Down Payment (DP) via website.

### 🎨 E. Performa Frontend & UX
- [ ] 25. **PWA (Progressive Web App):** Membuat *manifest.json* & *Service Worker* (bisa di-install di HP).
- [ ] 26. **Blur-up Image Placeholder:** Efek gambar "blur" saat *loading* gambar (mencegah layout shift).
- [ ] 27. **Intelligent Link Prefetching:** Auto-download halaman di belakang layar saat mouse *hover* tombol.
- [ ] 28. **Fitur "Wishlist" Lokal:** Simpan paket favorit pengunjung di *Local Storage* browser tanpa perlu login.
- [ ] 29. **Dark Mode (Tema Gelap):** Menambahkan *toggle* tema gelap.
- [ ] 30. **Animasi Mikro (Micro-interactions):** Transisi halaman menggunakan *Astro View Transitions* agar lebih premium.