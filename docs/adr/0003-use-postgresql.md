# ADR-0003: Use PostgreSQL via Directus

**Status:** Accepted
**Date:** 2026-07-08

## Context

Database diperlukan untuk menyimpan region, destinasi, paket, settings, dan data Directus internal. Database berjalan langsung di bawah Directus, tanpa ORM terpisah.

## Decision

Gunakan **PostgreSQL** sebagai database (dikelola oleh Directus).

## Rationale

1. **Standar Directus** — Directus native support PostgreSQL
2. **JSON field** — price tiers bisa disimpan sebagai JSON
3. **Kebutuhan sederhana** — query standar, tidak perlu search engine special
4. **Docker** — satu service PostgreSQL di docker-compose