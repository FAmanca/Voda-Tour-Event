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
- [x] Setup Directus 11 container
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
- [ ] Loading/error/empty state untuk tiap section
- [ ] Responsive: verifikasi breakpoint 1080px & 640px

---

## Phase 4: CRUD Pages

### 4.1 Destinasi List (`/destinasi`)
- [ ] `src/pages/destinasi.astro`
- [ ] SSR fetch: all destinations + regions
- [ ] Grid layout
- [ ] Filter by region (optional)
- [ ] Search input (client-side filter)

### 4.2 Destinasi Detail (`/destinasi/[slug]`)
- [ ] `src/pages/destinasi/[slug].astro`
- [ ] SSR fetch: destination by slug + related packages
- [ ] Hero variant (DestinasiHeader) dengan gradient
- [ ] Region badge
- [ ] Description
- [ ] GallerySection
- [ ] Package list di bawah
- [ ] 404 redirect kalo slug gak ditemukan

### 4.3 Paket List (`/paket` + `/gathering`)
- [ ] `src/pages/paket.astro` — all packages
- [ ] `src/pages/gathering.astro` — packages dengan activity_type = corporate-gathering
- [ ] SSR fetch + filter
- [ ] Grid cards
- [ ] Category filter tabs

### 4.4 Paket Detail (`/paket/[slug]`)
- [ ] `src/pages/paket/[slug].astro`
- [ ] SSR fetch: package by slug + destination
- [ ] **ItineraryTimeline:** vertical timeline
  - [ ] Day 1, Day 2 markers
  - [ ] Title + list activities
- [ ] **PriceTable:** 
  - [ ] Rows: min-max pax, price/pax, keterangan
  - [ ] Highlight baris sesuai pax yg dipilih user
  - [ ] Price calculator: input pax → hitung total
- [ ] Facilities list (badges/chips)
- [ ] Gallery foto
- [ ] CTA: "Hubungi Kami via WhatsApp" dengan prefilled message

### 4.5 Galeri (`/galeri`)
- [ ] `src/pages/galeri.astro`
- [ ] **GallerySection.astro:** masonry grid
- [ ] Fetch all images from packages & destinations
- [ ] Lightbox (optional — bisa pake vanilla JS simple)

### 4.6 Static Pages
- [ ] `src/pages/tentang.astro` — company profile
- [ ] `src/pages/kontak.astro` — contact info + WA link + embed GMaps (optional)

### 4.7 Sitemap
- [ ] `src/pages/sitemap.xml.ts`
- [ ] Generate all dynamic URLs (destinasi, paket)
- [ ] Include static pages
- [ ] Lastmod from updated_at

---

## Phase 5: Search Feature

### 5.1 Search Endpoint
- [ ] `src/pages/api/search.ts` — POST handler
- [ ] Terima: destination_name, region_name, activity_type_name, pax_count, travel_date
- [ ] Simpan ke Directus `searches` collection (public create)
- [ ] Hash IP visitor (anonim)
- [ ] Return matching packages (client-side atau server-side)

### 5.2 Search Form Client (`/cari`)
- [ ] **SearchForm.astro:** full-width variant
- [ ] Autocomplete destinasi (data embedded from SSR)
- [ ] Dropdown kegiatan dari activity_types
- [ ] Input jumlah peserta + date picker
- [ ] **Client JS (`src/lib/search.js`):**
  - [ ] Debounce 300ms pada input destinasi
  - [ ] Filter client-side dari data destinasi yg di-load SSR
  - [ ] Form submission → POST ke /api/search + redirect ke /cari?params
  - [ ] No external requests saat mengetik — 100% client-side

### 5.3 Search Results
- [ ] `src/pages/cari.astro` — SSR
- [ ] Baca query params, fetch packages dari Directus
- [ ] **SearchResult.astro:** list packages + highlight harga sesuai pax
- [ ] Empty: "Tidak ditemukan paket untuk pencarian ini"
- [ ] CTA: "Hubungi Kami untuk konsultasi" + WA button

### 5.4 Search Analytics
- [ ] Verify `searches` table getting data
- [ ] Directus panel bisa liat data pencarian (admin)

---

## Phase 6: Backend — Directus Setup

### 6.1 Collections
Buat di Directus Admin Panel:

- [ ] **regions**
  - Fields: id (UUID), name (string), slug (string, unique), description (text), image (file), status (select)
  - System: created_at, updated_at, created_by, updated_by

- [ ] **destinations**
  - Fields: id (UUID), region_id (M2O → regions), name (string), slug (string, unique), description (text), image (file), gallery (JSON/file[]), status (select)

- [ ] **packages**
  - Fields: id (UUID), destination_id (M2O → destinations), name (string), slug (string, unique), description (text), duration (string), itinerary (JSON), facilities (JSON), price_tiers (JSON), gallery (JSON/file[]), status (select)

- [ ] **activity_types**
  - Fields: id (UUID), name (string), slug (string, unique), description (text), status (select)

- [ ] **packages_activity_types**
  - Fields: id (UUID), package_id (M2O → packages), activity_type_id (M2O → activity_types)
  - Junction: many-to-many

- [ ] **settings**
  - Fields: id (UUID), key (string, unique), value (text)

- [ ] **searches**
  - Fields: id (UUID), destination_name (string), region_name (string), activity_type_name (string), pax_count (integer), travel_date (date), ip_hash (string)
  - Note: NO status field, NO soft delete. Just log.

### 6.2 Directus Configuration
- [ ] Set **Public Role**:
  - regions: Read
  - destinations: Read
  - packages: Read
  - activity_types: Read
  - settings: Read
  - searches: **Create only** (no read)
- [ ] Set admin user: `admin@vodaevent.id` / `admin123`
- [ ] Test: GET `/items/destinations` tanpa auth → harus return data

### 6.3 Seed Data
- [ ] Input via admin panel:
  - Regions: Bandung, Bali, Yogyakarta, Kepulauan Seribu
  - Destinations: 2-3 per region
  - Packages: 1-2 per destination with price_tiers
  - Activity Types: Private Trip, Corporate Gathering, Team Building, Family Vacation
  - Settings: site_name, whatsapp, email, phone, address, instagram
- [ ] Upload sample images via Directus file manager

---

## Phase 7: SEO & Performance

### 7.1 SEO Per Page
- [ ] **SEO component** reusable:
  - [ ] Title tag + fallback
  - [ ] Meta description
  - [ ] OG: title, description, image, url, type
  - [ ] Twitter card
  - [ ] JSON-LD (Organization schema) di Layout
  - [ ] JSON-LD (BreadcrumbList) di halaman detail
  - [ ] JSON-LD (Product) untuk halaman paket
- [ ] Canonical URL tiap halaman
- [ ] `robots.txt` — allow all, point to sitemap
- [ ] `sitemap.xml` — dynamic + static pages

### 7.2 Image Optimization
- [ ] Semua `<img>` dari Directus pake `?format=webp&quality=80`
- [ ] `loading="lazy"` untuk below-fold images
- [ ] `width` + `height` attributes (CLS prevention)
- [ ] `srcset` untuk responsive images (opsional — bisa lewat Directus params)

### 7.3 Performance
- [ ] Font: `display=swap`, preconnect Google Fonts
- [ ] Font Awesome: load async/defer
- [ ] CSS: Tailwind purged otomatis
- [ ] JS: minimal, inline untuk critical, `type="module"` untuk search
- [ ] Lighthouse target: ≥90 desktop & mobile

---

## Phase 8: Client-Side JavaScript

### 8.1 Mobile Menu
- [ ] Hamburger toggle
- [ ] Slide-in nav
- [ ] Dropdown accordion untuk submenu
- [ ] Close on outside click

### 8.2 Search Autocomplete
- [ ] `src/lib/search.js`:
  - [ ] Debounce 300ms
  - [ ] Client-side filter dari data destinasi (embedded di HTML)
  - [ ] Render dropdown suggestions
  - [ ] Keyboard navigation (arrow keys + enter)
  - [ ] Click outside close

### 8.3 Price Calculator
- [ ] Input jumlah peserta di halaman paket detail
- [ ] Otomatis highlight tier yg sesuai
- [ ] Tampilkan total harga: `price_per_pax * pax`
- [ ] Update real-time tanpa reload

### 8.4 Form Submissions
- [ ] Search form → POST ke `/api/search` + redirect
- [ ] WA button → generate wa.me URL dengan prefilled message

---

## Phase 9: Error Pages & Edge Cases

### 9.1 404 Page
- [ ] `src/pages/404.astro`
- [ ] Ilustrasi + copy ramah
- [ ] CTA: kembali ke beranda

### 9.2 500 / Error Page
- [ ] Fallback error page
- [ ] Minimalis: logo + "Terjadi kesalahan" + refresh button

### 9.3 Edge Case Handling
- [ ] Destinasi tanpa paket → empty state
- [ ] Paket tanpa price_tiers → "Hubungi kami untuk informasi harga"
- [ ] Directus offline → error state gracefully
- [ ] Gambar broken → fallback gradient sesuai kategori
- [ ] Slug duplicate → 404 atau redirect

---

## Phase 10: Production Readiness

### 10.1 Environment Config
- [ ] `infrastructure/.env.example` final
- [ ] `apps/web/.env.example` final
- [ ] Verify all env vars documented

### 10.2 Deployment Prep
- [ ] Docker compose production variant (no port mapping exposed for DB, etc.)
- [ ] Nginx reverse proxy config (optional)
- [ ] SSL certificate (LetsEncrypt / Cloudflare)
- [ ] CI/CD pipeline setup (opsional — bisa manual dulu)

### 10.3 Security Checklist
- [ ] CORS Directus — batasi origins
- [ ] Rate limiting (Directus atau reverse proxy)
- [ ] No sensitive data in client
- [ ] IP hashing untuk searches (anonim)
- [ ] .env gak ke-commit

### 10.4 Cloudflare R2 Migration (Nanti)
- [ ] Setup R2 bucket
- [ ] Dapetin Access Key + Account ID
- [ ] Update Directus env: uncomment S3 config
- [ ] Migrate existing images (directus storage move or re-upload)
- [ ] Verify image URLs via Directus assets

---

## Phase 11: Testing & QA

### 11.1 Manual Testing Checklist
- [ ] Landing page: semua section muncul, responsive
- [ ] Nav: semua link jalan, dropdown work, mobile menu
- [ ] Destinasi list: data dari Directus muncul
- [ ] Destinasi detail: info + packages + gallery
- [ ] Paket detail: itinerary, price table, calculator, WA
- [ ] Search: autocomplete, form submit, results page
- [ ] Galeri: grid masonry work
- [ ] Sitemap: semua URL tercakup
- [ ] 404: muncul kalo akses slug acak
- [ ] Directus admin: bisa CRUD data, Public Read works

### 11.2 Lighthouse
- [ ] Desktop ≥ 90
- [ ] Mobile ≥ 90
- [ ] Core Web Vitals: LCP, FID, CLS

### 11.3 Accessibility
- [ ] Tab order: nav → content → footer
- [ ] Focus visible: all interactive elements
- [ ] Color contrast: WCAG AA
- [ ] Screen reader: semantic HTML, aria-label

---

## Phase 12: Documentation Finalization

### 12.1 Code Sync
- [ ] Update `docs/frontend/structure.md` kalo ada deviasi selama coding
- [ ] Update `docs/development/api-integration.md` kalo endpoint berubah
- [ ] Update `.ai/context.md` dengan info baru
- [ ] Update `types/directus.ts` kalo ada perubahan model

### 12.2 AI Agent Docs
- [ ] Pastiin `.ai/README.md` masih akurat
- [ ] Pastiin CLAUDE.md, CODEX.md, CHATGPT.md, CURSOR.md up-to-date

### 12.3 Final Verification
- [ ] `grep -rn "TODO\|FIXME\|HACK\|XXX" apps/web/src` — zero results
- [ ] `grep -rn "console.log" apps/web/src` — zero results (kecuali di lib/search.js yg emang client-side)
- [ ] `pnpm build` — success
- [ ] `pnpm preview` — semua halaman jalan

---

## Summary

| Phase | Tasks | Priority |
|-------|-------|----------|
| 0: Setup Infra | ~10 | 🔴 First |
| 1: Astro Bootstrap | ~15 | 🔴 First |
| 2: Shared Components | ~7 | 🔴 First |
| 3: Landing Page | ~25 | 🔴 First |
| 4: CRUD Pages | ~20 | 🟡 Second |
| 5: Search Feature | ~10 | 🟡 Second |
| 6: Directus Setup | ~15 | 🔴 Before Phase 3-5 |
| 7: SEO & Perf | ~15 | 🟡 Second |
| 8: Client JS | ~10 | 🟡 Second |
| 9: Error Pages | ~8 | 🟢 Third |
| 10: Production | ~10 | 🟢 Third |
| 11: Testing | ~15 | 🟢 Third |
| 12: Docs Final | ~8 | 🟢 Third |

**Total:** ~168 task items
