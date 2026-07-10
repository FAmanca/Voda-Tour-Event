# Voda Tour & Event — Source of Truth

> Version: 3.0
> File ini adalah **entry point pertama** untuk AI manapun sebelum menulis kode.
> Baca SETIAP section. Gak usah dilewati.

## Project Identity

- **Nama:** Voda Tour & Event
- **URL:** https://vodaeventorganizer.id (production)
- **Bisnis:** Travel & Event Organizer — private trip, corporate gathering, team building
- **Model:** Brosur online + WhatsApp inquiry. **Tidak ada booking, payment, atau user account.**

## Tech Stack

| Layer | Teknologi | Catatan |
|-------|-----------|---------|
| Backend & Admin | Directus 11 (Headless CMS) | REST API, PostgreSQL, file management |
| Frontend | Astro 7 (SSR) | Static + SSR hybrid |
| Database | PostgreSQL 16 | Via Docker |
| Image Storage | Cloudflare R2 | S3-compatible, zero egress fee |
| CSS | Tailwind CSS 4 | Utility-first, custom theme di global.css |
| Font | **Poppins** (headings) + **Playfair Display** italic (accent) + **Inter** (body/UI) | Google Fonts |
| Colors | **Navy** `#0B2340` + **Orange** `#EE7D0F` | Lihat `docs/frontend/design-system.md` |
| Icons | Font Awesome 6 (free) | CDN via Layout |
| Container | Docker Compose | infra/docker-compose.yml |

## Content Hierarchy

```
Regions (1) ──→ Destinations (M) ──→ Packages (M)
                                            │
                                     many-to-many
                                            │
                                     Activity Types
```

### Contoh Data Real

| Region | Destinasi | Paket | Activity Types |
|--------|-----------|-------|----------------|
| Bandung | Lembang | Lembang Weekend 2D1N | Private Trip, Corporate Gathering |
| Bandung | Bandung Kota | Bandung City Tour 1D | Private Trip |
| Bali | Ubud | Ubud Wellness 3D2N | Private Trip |
| Bali | Seminyak | Seminyak Sunset 2D1N | Corporate Gathering, Team Building |
| Yogyakarta | Kota Yogya | Jogja Heritage 2D1N | Private Trip, Family Vacation |
| Kep. Seribu | Pulau Macan | Island Hopping 1D | Corporate Gathering, Team Building |

## Pricing Strategy

- **Price per pax (bukan flat).** Harga ditentukan oleh jumlah peserta.
- Setiap paket punya `price_tiers` (JSON array of {min_pax, max_pax, price, note}).
- Frontend otomatis menghitung harga sesuai input pax pengguna.

```
Contoh price_tiers:
- 5-10 orang: Rp 850.000/pax
- 11-20 orang: Rp 750.000/pax
- 21-50 orang: Rp 650.000/pax
```

## Non-Fungsional Requirements

| Requirement | Target |
|-------------|--------|
| PageSpeed (Lighthouse) | ≥ 90 (desktop & mobile) |
| Image format | WebP, auto-resize via Directus |
| Font loading | swap + preconnect |
| JavaScript | Zero JS on page load (kecuali search) |
| SEO | Meta tags, JSON-LD, sitemap.xml, semantic HTML |
| Accessibility | Contrast WCAG AA, aria-label, keyboard nav |

## Struktur Folder

```
voda-tour-event/
├── apps/web/                    # Astro frontend
│   └── src/
│       ├── layouts/Layout.astro # Base layout (Header + Footer)
│       ├── components/          # UI components
│       ├── pages/               # Routes
│       ├── lib/                 # Helpers (directus.ts, utils.ts)
│       ├── types/               # TypeScript definitions
│       └── styles/global.css    # Tailwind + theme
├── infrastructure/              # Docker, Nginx
├── docs/                        # Dokumentasi lengkap
│   ├── adr/                     # Architecture Decision Records
│   ├── architecture/            # System architecture
│   ├── database/                # Schema per tabel
│   ├── development/             # Setup, API, workflow
│   ├── features/                # Feature docs (search)
│   └── frontend/                # Structure, SEO
└── .ai/                         # AI context per provider
```

## Aturan Coding untuk AI

### Wajib
1. **TypeScript.** Semua kode pake TypeScript, gak ada `any`. Gunakan types dari `src/types/directus.ts`.
2. **Tailwind CSS.** Utility classes. Jangan tambah `var(--custom)` di luar theme.
3. **Components.** Props harus di-declare dengan interface, ekspor `type Props = ...`.
4. **Accessibility.** Semua `<img>` wajib `alt=""`, interaktif wajib `aria-label`.
5. **Format gambar.** Semua URL gambar dari Directus wajib: `?format=webp&quality=80`.
6. **Error handling.** Setiap fetch harus ada try-catch + fallback UI.
7. **Loading state.** Tiap komponen data harus handle loading & empty state.

### Design System Wajib
1. **Warna:** Navy (`#0B2340`) untuk struktur/trust, Orange (`#EE7D0F`) untuk aksi/aksen. Orange hanya untuk aksen — CTAs, harga, link, badge. Jangan pake orange untuk area besar.
2. **Font:** Poppins untuk heading (H1-H4, logo, harga). Inter untuk body, nav, tombol. Playfair Display italic **hanya** untuk satu frase emosional per halaman.
3. **Eyebrow label:** Setiap section (kecuali hero) butuh eyebrow: `12.5px / 700 / uppercase / letter-spacing 0.14em / orange` — didahului horizontal rule 22px.
4. **Hero pattern:** Full-bleed gradient + floating dark search card yg overlap ke section berikutnya.
5. **Icons:** Selalu di dalam shape (circle atau rounded-square), jangan floating bare.
6. **Cards:** `radius-md (14px)` + `shadow-soft` untuk normal. Hero-adjacent floating panels: `radius-lg (20px)` + `shadow-card`.
7. **Hover:** cards/buttons lift `translateY(-2px to -6px)` + deepen shadow. Jangan scale.
8. **CTA buttons:** "Lihat Paket", "Cari Paket", "Hubungi Kami" — jangan "Submit" atau "Klik di sini".
9. **Section rhythm:** 90-110px top/bottom padding.
10. **Container:** max-width 1280px, side padding 40px (24px di bawah 1080px).

### Dilarang
1. ❌ Gak usah bikin login/signup/user auth — **gak ada.**
2. ❌ Gak usah bikin payment gateway — **gak ada.**
3. ❌ Gak usah instal React/Vue/Svelte — HTML + vanilla JS cukup.
4. ❌ Gak usah tambah `any` di TypeScript — bikin type atau `unknown`.
5. ❌ Gak usah hardcode URL — pake env variable `DIRECTUS_URL`.

## Cara Mulai

```bash
# 1. Clone
git clone ... && cd voda-tour-event

# 2. Start infrastructure
cd infrastructure && docker compose up -d

# 3. Setup frontend
cd ../apps/web
pnpm install
pnpm dev          # → http://localhost:4321

# 4. Buka Directus admin
# → http://localhost:8055
# Login: admin@vodaevent.id / admin123
# Bikin collections: regions, destinations, packages, activity_types, dll
```

## Links Penting

| Resource | Path |
|----------|------|
| PRD | `docs/product/product-requirements.md` |
| Arsitektur | `docs/architecture/architecture.md` |
| Design System | `docs/frontend/design-system.md` |
| Mockup HTML | `mockup/landing.html` |
| Setup | `docs/development/setup.md` |
| API Integration | `docs/development/api-integration.md` |
| Frontend Structure | `docs/frontend/structure.md` |
| DB Design (per tabel) | `docs/database/tables/*.md` |
| Types | `apps/web/src/types/directus.ts` |
| Search Feature | `docs/features/search.md` |
| SEO | `docs/frontend/seo.md` |
| Docker | `infrastructure/docker-compose.yml` |
