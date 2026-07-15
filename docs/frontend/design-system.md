# VODA Tour & Event — Design System

A warm, trustworthy travel/corporate-event brand: **deep navy authority** + **sunset-orange energy**, set on clean white/mist surfaces. Built for conversion (search card, package cards, CTA) as much as for storytelling.

---

## 1. Color

| Token | Hex | Use |
|---|---|---|
| `--navy-900` | `#0B2340` | Darkest navy — footer/stats bg, deep gradients |
| `--navy-800` | `#0F2C4C` | Primary navy — search card, icon badges, buttons |
| `--navy-700` | `#173A5E` | Mid navy — gradient stops |
| `--orange-600` | `#EE7D0F` | **Primary accent** — CTAs, links, prices, active states |
| `--orange-500` | `#F5900F` | Secondary accent — icon glyphs, star ratings |
| `--orange-100` | `#FFE9D2` | Tint — rarely used, hover backgrounds |
| `--ink` | `#0B2340` | Heading text |
| `--body` | `#5B6B80` | Paragraph text |
| `--body-light` | `#8A97A8` | Captions, placeholder text, meta labels |
| `--paper` | `#FFFFFF` | Base background |
| `--mist` | `#F5F7FA` | Section background (alternate white) |
| `--line` | `#E6EAF0` | Hairline borders, dividers |

**Rule of thumb:** navy = structure/trust, orange = action/warmth. Never use orange for large fill areas — it's a spark, not a backdrop. Photography areas use ocean/teal, terracotta, or forest gradients depending on subject (beach, city, corporate, outdoor) rather than a single stock tone.

---

## 2. Typography

| Role | Family | Weight | Notes |
|---|---|---|---|
| Display / Headings | **Poppins** | 600–800 | Geometric, confident, friendly. Used for H1–H4, logo, prices. |
| Accent phrase | **Playfair Display** (italic only) | 400 italic | Reserved for **one emotional phrase per hero** (e.g. "Tak Terlupakan"). Never used for full sentences or body copy. |
| Body / UI | **Inter** | 400–700 | Paragraphs, nav, buttons, form labels, captions. |

**Type scale**
- H1 (hero): 48px / 700 / line-height 1.15
- H2 (section): 34px / 700
- H3 (card title in dark panels): 19px / 700
- H4 (feature/package titles): 15.5px / 600
- Body: 14.5–16.5px / 400, line-height 1.6–1.7
- Eyebrow label: 12.5px / 700 / uppercase / letter-spacing 0.14em, always orange, always preceded by a short 22px horizontal rule

---

## 3. Spacing & Shape

- Base spacing unit: **8px** grid (gaps typically 8/14/16/22/28/34/40px)
- Section vertical rhythm: 90–110px top/bottom padding
- Container: max-width `1280px`, side padding `40px` (`24px` ≤1080px)
- Radius scale:
  - `--radius-lg: 20px` — large cards (search card, feature strip)
  - `--radius-md: 14px` — package cards
  - `--radius-sm: 10px` — inputs, small chips
  - `999px` — pill buttons, phone badge
- Icon badges: circular, 38–54px diameter depending on context

## 4. Elevation

- `--shadow-soft`: `0 10px 30px -14px rgba(11,35,64,.18)` — resting cards
- `--shadow-card`: `0 20px 40px -18px rgba(11,35,64,.25)` — floating/overlapping panels (feature strip, search card)
- Hover state on cards/buttons: lift `translateY(-2px to -6px)` + deepen shadow. Never scale — only translate, to keep the grid feeling stable.

---

## 5. Components

### Navigation
White sticky header, 88px tall, bottom hairline border. Logo = optimized small WebP file (`VodaTravelIcon-small.webp`) lockup with orange plane glyph + wordmark. Active nav link is orange with a 2.5px underline offset 10px below text. Header right side: outlined phone pill + solid orange WhatsApp CTA pill.

### Hero
Full-bleed gradient "photo" (never a flat color) with a two-column layout: copy left, floating dark **search/utility card** right, anchored with `margin-top` overlap so the next section's white card physically overlaps the hero bottom edge. This overlap is the page's signature move — it stitches the hero to the content below and gives the layout depth without a hard seam.

### Feature strip
White rounded card (radius-lg, shadow-card) sitting on the overlap, 4-column icon+text row. Icon = orange glyph in solid navy circle. Never bullet points — always icon-led.

### Package / offer cards
Photo top (gradient block + circular icon badge pinned top-left, half-overlapping the photo edge), body with title, 2-line description, dashed divider, then a price row (`Mulai dari` micro-label + bold orange price) paired with a circular navy arrow button that turns orange on hover.

### Stats bar
Navy floating card (`bg-navy-900`, `radius-lg`, `shadow-card`) dengan negative margin overlap. Horizontal grid: section kiri berisi 4-kolom stats (icon outline/circle + bold number + label), section kanan berisi testimonial card (quote, avatar, rating).

### CTA band
Deep navy/teal gradient "photo" section, top border rule, heading + supporting line, a row of small feature chips (rounded-square icon tile + 2-line label), ending in the primary orange CTA button. This is the mirror of the hero — same DNA (gradient photo, orange CTA, icon+label chips) used to close the page.

---

## 6. Motion

- Buttons/cards: 0.18–0.22s ease transitions on transform + shadow/color only.
- No entrance animations by default — this is a conversion-focused, information-dense layout; motion is reserved for hover feedback, not ambience.

## 7. Voice

Bahasa Indonesia, warm and direct. Eyebrows in ALL CAPS orange (e.g. "PAKET PILIHAN"). Headlines mix a confident navy statement with one italic orange emotional word/phrase. Body copy stays short — 1–2 sentences, benefit-first, no jargon. Buttons are verbs: "Lihat Paket", "Cari Paket", "Hubungi Kami" — never "Submit" or "Klik di sini".

---

## 8. Reuse checklist for new pages

1. White sticky nav + navy/orange logo lockup stays identical across all pages.
2. Every new hero: gradient "photo" background + one floating dark utility/info card that overlaps into the next section.
3. Every section needs an eyebrow (orange, ruled) before its H2 — except the hero, which uses eyebrow → H1 directly.
4. Cards default to `--radius-md` + `--shadow-soft`; only hero-adjacent floating panels get `--radius-lg` + `--shadow-card`.
5. One italic Playfair phrase maximum per page — it's a rare accent, not a running style.
6. Icons are always inside a shape (circle or rounded-square), never floating bare next to text.
7. **Grid Layouts:** Ketika `SectionHeader` disandingkan dengan konten (seperti `PackageGrid`), gunakan wrapper `grid-cols-5` pada desktop (`lg`) agar *side-by-side*.

---

## 9. Accessibility (A11y) & Performance Wajib

1. **Screen Reader:** Ikon FontAwesome wajib di-_hide_ secara semantik menggunakan `speak: never` di CSS global, dan semua tombol/link yang hanya berupa ikon wajib memiliki atribut `aria-label`.
2. **Interaktivitas:** Elemen navigasi overlay (seperti menu mobile) wajib menggunakan `role="dialog"` dan `aria-expanded` untuk _toggles_.
3. **Optimasi Gambar (LCP):** Format gambar statis wajib **AVIF** muti-resolusi (di-generate via FFmpeg, mis. `beach-480.avif`). Untuk konten dinamis API Directus, gunakan WebP. Aset LCP di-*preload* menggunakan `fetchpriority="high"`.
