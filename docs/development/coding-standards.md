# Coding Standards — Voda Tour & Event

> Version: 1.0
> Berlaku untuk semua developer dan AI Agent.
> Referensi: `docs/frontend/design-system.md`, `apps/web/src/types/directus.ts`

---

## Tech Stack

| Layer | Teknologi | Catatan |
|-------|-----------|---------|
| Frontend | **Astro 7** (SSR) | — |
| Backend & Admin | **Directus 12** (Headless CMS) | REST API langsung, gak ada backend layer tambahan |
| Database | **PostgreSQL 16** | Via Docker |
| CSS | **Tailwind CSS 4** | Utility-first, custom theme |
| Client JS | **Vanilla JavaScript** | Gak pake React/Vue/Svelte. Zero JS on page load (kecuali Search) |
| Font | **Poppins** (heading) + **Playfair Display** italic (accent) + **Inter** (body) | Google Fonts |
| Icons | **Font Awesome 6** (free) | CDN via Layout |
| Package Manager | **pnpm** | — |
| Infrastructure | **Docker Compose** | PostgreSQL + Directus |

---

## Prinsip Umum

1. **Documentation First** — tulis dokumen sebelum nulis kode.
2. **SEO First** — meta tags, JSON-LD, semantic HTML di tiap halaman.
3. **Mobile First** — semua responsive, breakpoint di 1080px & 640px.
4. **Production Ready** — gak ada dummy data, gak ada console.log di production.
5. **Accessibility** — semantic HTML, keyboard nav, aria-label, alt text.

---

## Design System Wajib

Semua kode WAJIB mengikuti design system (`docs/frontend/design-system.md`).

### Warna

| Token | Hex | Tailwind Class | Use |
|-------|-----|---------------|-----|
| Navy 900 | `#0B2340` | `bg-navy-900 text-navy-900` | Footer, stats bg, deep gradients |
| Navy 800 | `#0F2C4C` | `bg-navy-800 text-navy-800` | Search card, icon badges, buttons |
| Navy 700 | `#173A5E` | `bg-navy-700` | Gradient stops |
| Orange 600 | `#EE7D0F` | `bg-orange-600 text-orange-600` | **Primary accent** — CTAs, links, prices, active |
| Orange 500 | `#F5900F` | `text-orange-500` | Icon glyphs, star ratings |
| Ink | `#0B2340` | `text-ink` | Heading text |
| Body | `#5B6B80` | `text-body` | Paragraph text |
| Body Light | `#8A97A8` | `text-body-light` | Captions, placeholders |
| Mist | `#F5F7FA` | `bg-mist` | Section BG (alternate) |
| Line | `#E6EAF0` | `border-line` | Borders, dividers |
| Paper | `#FFFFFF` | `bg-white` | Base background |

**Rule:** Navy = struktur/trust. Orange = aksi/warmth. **Jangan pake orange untuk area besar** — dia spark, bukan backdrop.

### Font

| Role | Family | Weight | Tailwind Class |
|------|--------|--------|---------------|
| Heading (H1-H4, logo, price) | **Poppins** | 600-800 | `font-display` |
| Accent phrase | **Playfair Display italic** | 400 italic | `font-accent` |
| Body, UI, Nav, Button | **Inter** | 400-700 | `font-body` |

- **Playfair Display italic** — maksimal **satu frase per halaman**. Jangan dipake buat full sentence.
- H1: 48px / 700 / leading-tight
- H2: 34px / 700
- H3 (dark panel title): 19px / 700
- H4 (card title): 15.5px / 600
- Body: 14.5-16.5px / 400 / leading-relaxed
- Eyebrow: 12.5px / 700 / uppercase / tracking-widest / orange / preceded by 22px horizontal rule

### Spacing & Shape

- Base unit: 8px grid
- Section padding: 90-110px top/bottom
- Container: max-w-[1280px], px-[40px] (px-[24px] ≤1080px)
- Radius: `--radius-lg: 20px`, `--radius-md: 14px`, `--radius-sm: 10px`, pill: `999px`
- Shadow: `--shadow-soft` (resting cards), `--shadow-card` (floating panels)

### Hover & Motion

- Cards/buttons: `translateY(-2px to -6px)` + deepen shadow. **Jangan scale.**
- Transition: 0.18-0.22s ease on transform + shadow/color only.
- Gak ada entrance animation.

---

## TypeScript Rules

1. **Strict mode.** Selalu.
2. **No `any`.** Pake `unknown` kalo emang gak tau tipenya.
3. Pake `interface` untuk object contract / props.
4. Pake `type` untuk union / utility type.
5. Semua function parameter & return value wajib di-type.
6. Gunakan type dari `apps/web/src/types/directus.ts` — jangan redefine.

```typescript
// ✅ Good
function getPrice(tiers: PriceTier[], pax: number): number { ... }

// ❌ Bad
function getPrice(tiers, pax) { ... }
```

---

## Astro Rules

1. **Gak pake React/Vue/Svelte.** Semua komponen `.astro`.
2. Props wajib dideclare sebagai `interface Props` + export.
3. Pattern komponen:

```astro
---
// 1. Import type
import type { PackageWithDestination } from "../types/directus";

// 2. Props interface
export interface Props {
  packages: PackageWithDestination[];
  loading?: boolean;
  error?: string | null;
}

// 3. Destructure props
const { packages, loading, error } = Astro.props;
---

<!-- 4. Template — loading/error/empty/success -->
```

4. Interaktivitas (search, mobile menu) pake **vanilla JS inline atau `client:load`**.
5. Fetch data di **page level** (SSR), kirim ke component via props.

---

## Tailwind CSS Rules

1. **Utility classes doang.** Jangan tambah `var(--custom)` di luar theme.
2. Jangan pake `@apply` — bikin component baru kalo pattern berulang.
3. Gak usah inline style (`style=""`) — pake utility Tailwind.
4. Responsive: `md:` (≤1080px), `sm:` (≤640px).

---

## Component Rules

1. **Single Responsibility.** Satu komponen = satu fungsi.
2. **Props max 8.** Kalo lebih, refactor.
3. **Setiap komponen data WAJIB handle 4 state:**

| State | Tampilan |
|-------|----------|
| Loading | Skeleton (animate-pulse), bukan spinner teks |
| Empty | Ilustrasi + pesan ramah + CTA (opsional) |
| Error | Alert merah + pesan jelas + tombol retry |
| Success | Render data normal |

4. **Semua `<img>` wajib `alt=""`.** Interaktif wajib `aria-label`.

---

## Data Fetching

1. Fetch data di **page level** (SSR), kirim via props.
2. Semua URL gambar dari Directus:
   ```
   {DIRECTUS_URL}/assets/{uuid}?width=600&format=webp&quality=80
   ```
3. Jangan hardcode URL — pake env variable `DIRECTUS_URL`.

```typescript
// ✅ Good
const res = await fetch(`${import.meta.env.DIRECTUS_URL}/items/destinations?...`);

// ❌ Bad
const res = await fetch("http://localhost:8055/items/destinations?...");
```

---

## Error Handling

1. Setiap fetch WAJIB try-catch.
2. Setiap API call WAJIB handle error state di UI.
3. Jangan throw error mentah ke user — kasi pesan yg ramah.

```typescript
try {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  data = await res.json();
} catch (e) {
  error = "Gagal memuat data. Silakan coba lagi.";
}
```

---

## Naming Convention

| Item | Convention | Example |
|------|-----------|---------|
| Folder | `kebab-case` | `landing/`, `detail/` |
| File | `kebab-case` | `search-card.astro` |
| Variable | `camelCase` | `selectedDestination` |
| Function | `camelCase` | `getSettings()` |
| Component | `PascalCase` | `PackageCard.astro` |
| Interface | `PascalCase` | `HeroProps` |
| Type | `PascalCase` | `PriceTier` |
| Env Variable | `UPPER_CASE` | `DIRECTUS_URL` |
| CSS Class | Tailwind utility | — |

---

## Voice & Copywriting

- Bahasa Indonesia, warm & direct.
- Eyebrows: **ALL CAPS ORANGE** — "PAKET PILIHAN"
- Buttons: verbs — "Lihat Paket", "Cari Paket", "Hubungi Kami"
- Jangan: "Submit", "Klik di sini"
- Body copy: 1-2 sentences, benefit-first, no jargon.
- Satu Playfair italic phrase per page max.

---

## Git Convention

| Branch Prefix | Untuk |
|---------------|-------|
| `feature/` | Fitur baru |
| `bugfix/` | Perbaikan bug |
| `hotfix/` | Perbaikan urgent production |
| `refactor/` | Refaktor kode |
| `docs/` | Update dokumentasi |

**Commit message:** Conventional Commits (English).
```
feat: add search autocomplete
fix: handle empty destination state
docs: update API sample responses
```

---

## File Size Limit

| Tipe | Max Baris |
|------|-----------|
| Component `.astro` | 200 |
| Page `.astro` | 300 |
| Utility `.ts` | 150 |
| Type definition `.ts` | 300 |

Kalo lebih → refactor.

---

## Dilarang

1. ❌ Login/signup/user auth — **gak ada di project ini.**
2. ❌ Payment gateway — **gak ada.**
3. ❌ React/Vue/Svelte — **cuma Astro + vanilla JS.**
4. ❌ `any` di TypeScript — **pake `unknown` atau bikin type.**
5. ❌ Hardcode URL — **pake env variable.**
6. ❌ Orange buat area besar — **orange cuma buat aksen.**
7. ❌ Entrance animation — **cuma hover feedback.**
8. ❌ `console.log` di production.

---

## Source of Truth

Jika implementasi berbeda dengan dokumentasi → **dokumentasi harus diupdate duluan.**
