# ADR-0002: Use Astro for Public Website

**Status:** Accepted
**Date:** 2026-07-08

## Context

Website publik Voda Tour & Event perlu menampilkan konten dinamis dari Directus API dengan performa dan SEO optimal.

## Decision

Gunakan **Astro** untuk frontend website publik.

## Rationale

1. **SEO terbaik** — static HTML default, SSR untuk halaman dinamis
2. **Performa** — zero JS by default, island architecture
3. **Content Collections** — cocok untuk katalog destinasi & paket
4. **Integrasi mudah** — fetch dari Directus REST API
5. **Image optimization** — built-in, tanpa tool tambahan

## Consequences

- SSR membutuhkan runtime Node.js di production
- Tidak bisa fully static — content diambil dari database via API