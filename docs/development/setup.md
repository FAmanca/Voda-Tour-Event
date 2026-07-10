# Development Setup

## Prerequisites

- Node.js (latest LTS)
- Docker + Docker Compose
- Git
- pnpm (`npm install -g pnpm`)
- Akun Cloudflare (untuk R2 storage) — opsional, pake local dulu

## Clone & Install

```bash
git clone <repo-url>
cd voda-tour-event
pnpm install --filter web
```

## Environment Variables

Project ini pake **2 file `.env`** — satu untuk infra, satu untuk frontend.
Template udah tersedia, tinggal copy:

```bash
# 1. Infra (PostgreSQL + Directus)
cp infrastructure/.env.example infrastructure/.env

# 2. Frontend (Astro)
cp apps/web/.env.example apps/web/.env
```

Edit sesuai kebutuhan. File `.env.example` adalah **single source of truth** — semua
environment variable yg dipake project ada di sana.

## Run Infrastructure (Database + Backend)

```bash
cd infrastructure
docker compose up -d
```

Container akan jalan:
- **PostgreSQL 16** — database
- **Directus 11** — headless CMS + admin panel

Tunggu sampai kedua container healthy:
```bash
docker ps --filter "name=voda-"
```

Akses Directus admin: `http://localhost:8055`
Login: `admin@vodaevent.id` / `admin123`

## Run Astro (Frontend)

```bash
cd apps/web
pnpm dev
```

Akses website di `http://localhost:4321`

## Ports

| Service | Port | Catatan |
|---------|------|---------|
| Astro (dev) | 4321 | Frontend |
| Directus | 8055 | CMS Admin |
| PostgreSQL | 5432 | Database |
| Nginx (prod) | 80 / 443 | Reverse proxy |

## Directus Collections Setup

1. Login ke `http://localhost:8055` (admin@vodaevent.id / admin123)
2. Buat Collections sesuai `docs/database/tables/*.md`:

| Collection | Type | Note |
|-----------|------|------|
| `regions` | Standalone | — |
| `destinations` | M2O → regions | — |
| `packages` | M2O → destinations | — |
| `activity_types` | Standalone | — |
| `packages_activity_types` | M2M junction | package_id M2O + activity_type_id M2O |
| `settings` | Standalone | Key-value |
| `searches` | Standalone | Log pencarian, no status field |

3. Set **Public Role**:
   - Semua collection: Read
   - `searches`: Create only (no Read)
   - Settings: Read

4. Test public access:
   ```bash
   curl http://localhost:8055/items/destinations
   # Harus return data tanpa token
   ```

## Tips

- **Local storage** dulu. R2 tinggal uncomment nanti pas deploy.
- Gambar dari Directus: selalu pake `?format=webp&quality=80`.
- `infrastructure/.env.example` jangan diedit langsung — copy ke `.env` dulu.
