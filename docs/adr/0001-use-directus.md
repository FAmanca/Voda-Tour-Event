# ADR-0001: Use Directus as Backend & Admin Panel

**Status:** Accepted
**Date:** 2026-07-08

## Context

Dibutuhkan backend API dan admin panel untuk mengelola konten website. Ada dua opsi:
- **Directus** — headless CMS siap pakai dengan admin panel built-in
- **Custom backend (Elysia + Vue)** — bikin sendiri dari nol

## Decision

Gunakan **Directus** sebagai backend + admin panel.

## Rationale

1. **Time to market** — setup cepat, langsung bisa digunakan admin
2. **Admin panel built-in** — atasan/staf bisa langsung edit konten tanpa nunggu Vue selesai
3. **Fitur cukup** — website hanya butuh CRUD region, destinasi, paket, galeri, settings. Tidak ada logika backend kompleks.
4. **Admin non-teknis** — atasan/staf bisa manage sendiri tanpa developer
5. **Self-hosted** — data tetap di server sendiri, tidak SaaS

## Consequences

- Directus lebih berat secara resource (container lebih besar)
- Custom logic di atas Directus lebih terbatas, tapi cukup untuk use case ini

## Related

- Website publik tetap pakai Astro (ADR-0002)
- Database: PostgreSQL (langsung via Directus)