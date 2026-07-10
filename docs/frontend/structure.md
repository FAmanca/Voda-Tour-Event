# Frontend Structure

> Refer to `docs/frontend/design-system.md` untuk warna, font, spacing, shadow.
> Refer to `mockup/landing.html` untuk implementasi layout landing page.
> Refer to `apps/web/src/types/directus.ts` untuk tipe data & props.

---

## Routing

Astro SSR mode. Navigation dari mockup:

| Nav Label | URL | File | Type | Description |
|-----------|-----|------|------|-------------|
| Beranda | `/` | `src/pages/index.astro` | Static | Landing page lengkap |
| Paket Wisata | `/paket` | `src/pages/paket.astro` | SSR | List semua paket (search & filter) |
| Gathering & Event | `/gathering` | `src/pages/gathering.astro` | SSR | List paket filtered activity_type=corporate-gathering |
| Destinasi | `/destinasi` | `src/pages/destinasi.astro` | SSR | List semua destinasi |
| — | `/destinasi/[slug]` | `src/pages/destinasi/[slug].astro` | SSR | Detail destinasi + list paket |
| — | `/paket/[slug]` | `src/pages/paket/[slug].astro` | SSR | Detail paket (itinerary, harga, fasilitas, CTA WA) |
| — | `/cari` | `src/pages/cari.astro` | SSR | Halaman hasil pencarian |
| — | `/galeri` | `src/pages/galeri.astro` | SSR | Galeri foto lengkap (masonry) |
| Tentang Kami | `/tentang` | `src/pages/tentang.astro` | Static | Profil perusahaan |
| Kontak | `/kontak` | `src/pages/kontak.astro` | Static | Informasi kontak + WA link |
| — | `/sitemap.xml` | `src/pages/sitemap.xml.ts` | Static | Sitemap untuk SEO |

### Notes
- `Paket Wisata` + `Gathering & Event` = filter berbeda dari collection `packages`, dipisah berdasarkan `activity_types` M2M.
- Nav dropdown di Header bersifat visual (CSS) — gak perlu page terpisah untuk sub-item.

---

## Layouts

| Layout | File | Description |
|--------|------|-------------|
| Base Layout | `src/layouts/Layout.astro` | HTML shell: meta tags, fonts (Poppins + Playfair + Inter), Font Awesome CDN, global CSS/Tailwind, Header, Footer |

---

## Landing Page — Section Flow

Urutan section di `index.astro` (cocok dengan mockup):

```
┌──────────────────────────────────────┐
│ Header (sticky, white, 88px)        │
├──────────────────────────────────────┤
│ Hero                                 │
│ ┌───────────┬──────────────────────┐ │
│ │ Copy left │ SearchCard (navy)    │ │ ← teal gradient BG
│ └───────────┴──────────────────────┘ │
│                                      │
│      ◄── overlap -64px ──►           │
│ ┌──────────────────────────────────┐ │
│ │ FeatureStrip (4 icon+text)      │ │ ← white card, shadow-card
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Section: Paket Pilihan          │ │ ← mist BG
│ │ SectionHeader (eyebrow + h2 +   │ │
│ │   description + CTA kanan)      │ │
│ │ ┌───┬───┬───┬───┐              │ │
│ │ │Pkg│Pkg│Pkg│Pkg│              │ │ ← 4-col grid
│ │ └───┴───┴───┴───┘              │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ StatsBar (navy-900 full-width)  │ │
│ │ ┌─────┬─────┬─────┬──────────┐ │ │
│ │ │Stat1│Stat2│Stat3│Testimonial│ │ │
│ │ └─────┴─────┴─────┴──────────┘ │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ CTABand (gradient dark)         │ │
│ │ ┌──────────────────────┬──────┐ │ │
│ │ │ Heading + p + chips  │ CTA  │ │ │
│ │ └──────────────────────┴──────┘ │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Footer (navy-900)               │ │
│ │ Logo, nav, contact, social,     │ │
│ │ copyright                       │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

---

## Komponen

### A. Landing Page Components

Digunakan di `index.astro` dan halaman lain.

#### Header (`src/components/Header.astro`)

```typescript
interface Props {
  /** Active nav item slug — "beranda", "paket", "gathering", "destinasi", "tentang", "kontak" */
  active?: string;
  /** Data dari settings (whatsapp, phone) */
  settings: { whatsapp: string; phone: string };
}
```

Sticky white header, 88px (76px mobile). Logo lockup (navy square + orange plane icon + "VODA" bold navy / "TOUR & EVENT" tracked orange). Nav links with chevron dropdown indicators. Phone pill (border) + WA pill (solid orange).

#### Hero (`src/components/Hero.astro`)

```typescript
interface Props {
  /** Eyebrow text — default: "VODA TOUR & EVENT" */
  eyebrow?: string;
  /** Headline — support Playfair italic via <span class="accent-italic"> */
  headline: string;
  /** Subheadline */
  subheadline: string;
  /** CTA buttons */
  primaryCta?: { text: string; href: string };
  secondaryCta?: { text: string; href: string };
  /** Destinations data untuk SearchCard */
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
  /** Background gradient class — default teal ocean */
  gradientClass?: string;
}
```

Full-bleed gradient background (teal/ocean default), 2-column grid: copy left, SearchCard right overlapping bottom. `hero::before` untuk decorative circles. `hero::after` untuk bottom gradient fade.

#### SearchCard (`src/components/SearchCard.astro`)

```typescript
interface Props {
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
}
```

Floating navy card (`navy-800` to `navy-900` gradient) inside hero. Title "Cari Paket Impianmu" + orange underline. 2x2 grid fields:
- Destinasi (autocomplete, client-side)
- Kegiatan (dropdown dari activity_types)
- Peserta (input number)
- Tanggal (date picker)

Submit button "Cari Paket" (orange, full-width). Redirect ke `/cari?params...`.

#### FeatureStrip (`src/components/FeatureStrip.astro`)

```typescript
interface Props {
  features: {
    icon: string;    // Font Awesome class, e.g. "fa-route"
    title: string;
    description: string;
  }[];
}
```

White card (`radius-lg`, `shadow-card`) dengan negative margin `-64px` overlap hero. 4-column grid icon + text. Icon = 52px navy circle with orange glyph.

#### SectionHeader (`src/components/SectionHeader.astro`)

```typescript
interface Props {
  eyebrow: string;
  title: string;
  description?: string;
  /** Optional CTA di pojok kanan */
  cta?: { text: string; href: string };
  /** Layout: "default" | "split" — split puts CTA di kanan */
  layout?: "default" | "split";
}
```

Eyebrow (orange, uppercase, 12.5px, 700, `::before` rule 22px) → H2 (Poppins 700, 34px) → description → optional CTA.

#### PackageCard (`src/components/PackageCard.astro`)

```typescript
interface Props {
  package: Package & { destination_id: { name: string } };
  /** Gradient class untuk photo area — "media-seribu", "media-bandung", etc */
  gradientClass?: string;
}
```

Photo gradient area (150px height, `--radius-md` top corners). Circular badge icon pinned top-left (38px). Body: title (15.5px/600), 2-line description (12.8px), dashed divider, price row (`Mulai dari` micro-label + bold orange price + navy circle arrow button that turns orange on hover).

#### StatsBar (`src/components/StatsBar.astro`)

```typescript
interface Props {
  stats: {
    icon: string;
    value: string;    // e.g. "150+"
    label: string;    // e.g. "Paket Tersedia"
  }[];
  testimonial?: {
    quote: string;
    name: string;
    company: string;
    avatar?: string;
    rating: number;   // 1-5
  };
}
```

Full-width navy-900 section. Left: stat clusters in grid (outlined circle icon + bold number + 2-line label, separated by vertical hairline rules). Right: single testimonial with quote icon, 5 orange stars, name/company + circular avatar with orange ring border.

#### CTABand (`src/components/CTABand.astro`)

```typescript
interface Props {
  title: string;
  description: string;
  cta: { text: string; href: string };
  features?: { icon: string; label: string }[];
}
```

Gradient dark section (`#122A3D` → `#356E78`). Top row: heading + description + CTA button, separated by bottom border. Bottom row: feature chips (rounded-square icon + label, 4-column grid).

#### Footer (`src/components/Footer.astro`)

```typescript
interface Props {
  settings: {
    site_name?: string;
    whatsapp?: string;
    phone?: string;
    email?: string;
    address?: string;
    instagram?: string;
  };
}
```

Navy-900 background. 3-column grid: logo + description, navigasi, kontak & sosial media. Bottom bar: copyright.

#### WaButton (`src/components/WaButton.astro`)

```typescript
interface Props {
  phone: string;            // "6281234567890"
  message?: string;         // Prefilled text
  label?: string;           // Default: "Hubungi Kami"
  variant?: "primary" | "outline" | "pill";
  fullWidth?: boolean;
  icon?: boolean;           // Show WA icon
}
```

---

### B. Detail Page Components

Digunakan di halaman detail destinasi & paket.

#### DestinasiHeader (`src/components/DestinasiHeader.astro`)

```typescript
interface Props {
  destination: Destination;
  packageCount: number;
}
```

Hero variant untuk halaman detail destinasi. Gradient bg, nama destinasi, region badge, deskripsi.

#### ItineraryTimeline (`src/components/ItineraryTimeline.astro`)

```typescript
interface Props {
  itinerary: DayActivity[];
}
```

Timeline vertikal dengan day marker + title + list activities.

#### PriceTable (`src/components/PriceTable.astro`)

```typescript
interface Props {
  tiers: PriceTier[];
  /** Highlight baris sesuai pax */
  activePax?: number | null;
}
```

Tabel harga per tier. Kolom: jumlah peserta, harga/pax, keterangan. Baris active di-highlight.

#### GallerySection (`src/components/GallerySection.astro`)

```typescript
interface Props {
  images: string[];      // Array of Directus asset URLs
  columns?: 2 | 3 | 4;
  masonry?: boolean;
}
```

Masonry grid dengan gambar dari Directus assets.

---

### C. Search Page Components

#### SearchForm (`src/components/SearchForm.astro`)

Standalone search form untuk halaman `/cari`. Mirip SearchCard tapi full-width.

```typescript
interface Props {
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
  initialValues?: {
    destination?: string;
    activityType?: string;
    paxCount?: number;
    travelDate?: string;
  };
}
```

#### SearchResult (`src/components/SearchResult.astro`)

```typescript
interface Props {
  packages: (Package & { destination_id: { name: string } })[];
  searchParams: SearchFormProps["initialValues"];
  loading?: boolean;
  error?: string | null;
}
```

List hasil pencarian. Tiap item: PackageCard variant (horizontal, with price calculation).

---

### D. Shared / Utility Components

#### Eyebrow (`src/components/Eyebrow.astro`)

```typescript
interface Props {
  text: string;
}
```
`<div class="eyebrow">{{text}}</div>` — orange uppercase with `::before` rule.

#### IconBadge (`src/components/IconBadge.astro`)

```typescript
interface Props {
  icon: string;      // FA class
  size?: "sm" | "md" | "lg";  // 38 | 52 | 54px
  shape?: "circle" | "rounded-square";
  variant?: "navy" | "outline" | "glass";
}
```

#### PriceDisplay (`src/components/PriceDisplay.astro`)

```typescript
interface Props {
  amount: number;
  prefix?: string;      // Default: "Rp "
  format?: "short" | "full";  // "850rb" | "Rp 850.000"
  perPax?: boolean;     // Show "/pax" suffix
  size?: "sm" | "md" | "lg";
}
```

#### SkeletonCard (`src/components/SkeletonCard.astro`)

```typescript
interface Props {
  type?: "package" | "destinasi" | "feature";
}
```

Animated pulse placeholder.

---

## Struktur Folder

```
apps/web/src/
├── layouts/
│   └── Layout.astro              # Base layout (meta, fonts, FA, Header, Footer)
├── components/
│   ├── landing/                   # Landing page components
│   │   ├── Hero.astro
│   │   ├── SearchCard.astro
│   │   ├── FeatureStrip.astro
│   │   ├── SectionHeader.astro
│   │   ├── PackageCard.astro
│   │   ├── PackageGrid.astro
│   │   ├── StatsBar.astro
│   │   ├── CTABand.astro
│   │   └── TestimonialCard.astro
│   ├── Header.astro
│   ├── Footer.astro
│   ├── WaButton.astro
│   ├── Eyebrow.astro
│   ├── IconBadge.astro
│   ├── PriceDisplay.astro
│   ├── SkeletonCard.astro
│   ├── SearchForm.astro           # /cari page
│   ├── SearchResult.astro         # /cari page
│   ├── DestinasiHeader.astro      # /destinasi/[slug]
│   ├── ItineraryTimeline.astro    # /paket/[slug]
│   ├── PriceTable.astro           # /paket/[slug]
│   └── GallerySection.astro       # /galeri & detail
├── pages/
│   ├── index.astro                # Landing page
│   ├── paket.astro                # List paket
│   ├── gathering.astro            # List gathering
│   ├── destinasi.astro            # List destinasi
│   ├── destinasi/
│   │   └── [slug].astro
│   ├── paket/
│   │   └── [slug].astro
│   ├── cari.astro                 # Search results
│   ├── galeri.astro
│   ├── tentang.astro
│   ├── kontak.astro
│   └── sitemap.xml.ts
├── lib/
│   ├── directus.ts                # Helper fetch functions
│   ├── search.js                  # Client-side autocomplete
│   └── utils.ts                   # Formatting, price, date
├── types/
│   └── directus.ts                # Type definitions
└── styles/
    └── global.css                 # Tailwind directives + custom theme
```

---

## Data Flow

```
Directus API (public read)
       │
       ▼
┌──────────────┐
│  Astro SSR   │ ← fetch di page level
│  (pages/*)   │
└──────┬───────┘
       │ props
       ▼
┌──────────────┐
│  Components  │ ← render data
│  (.astro)    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Browser     │ ← vanilla JS untuk:
│  (client)    │   • Search autocomplete
│              │   • Form submission
│              │   • Mobile menu toggle
│              │   • Price calculator
└──────────────┘
```

### Fetch Pattern

```astro
---
// Setiap page SSR fetch data dari Directus
import { getSettings, getDestinations, getPackages } from "../lib/directus";

const settings = await getSettings();
const destinations = await getDestinations();
const packages = await getPackages();
const error = !settings || !destinations ? "Gagal memuat data" : null;
---

<Layout settings={settings}>
  {error && <ErrorAlert message={error} />}
  {!error && (
    <Hero destinations={destinations} />
    <FeatureStrip />
    <PackageGrid packages={packages} />
    ...
  )}
</Layout>
```

---

## Responsive Breakpoints

| Breakpoint | Container Padding | Notes |
|-----------|------------------|-------|
| >1080px | 40px sides | Desktop layout |
| ≤1080px | 24px sides | Tablet: nav hidden (burger), 2-col grids |
| ≤640px | 24px sides | Mobile: 1-col grids, phone-pill hidden, smaller font |

Lihat `mockup/landing.html` media queries untuk implementasi detail.
