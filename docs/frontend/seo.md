# SEO Strategy

## Target

- **Lighthouse Performance:** 95+
- **Lighthouse SEO:** 100
- **Core Web Vitals:** Pass

## Implementation

### Global (setiap halaman)
- Meta title: `Nama Halaman | Voda Tour & Event`
- Meta description: unik per halaman
- OG tags: title, description, image, url
- Twitter Cards
- Canonical URL
- Semantic HTML (`<header>`, `<main>`, `<nav>`, `<article>`, `<footer>`)

### Home
- H1: nama brand + tagline
- JSON-LD: Organization + Website
- Breadcrumb JSON-LD

### Detail Halaman (Region, Destinasi, Paket)
- H1: nama entitas
- JSON-LD: Product / Place (sesuai konteks)
- JSON-LD BreadcrumbList
- Alt text semua gambar

### Global
- Sitemap.xml otomatis dari Astro
- robots.txt
- Responsive images (srcset)
- Gzip / Brotli compression (Nginx)
- Lazy loading untuk gambar di bawah fold