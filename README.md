# Voda Tour & Event

Modern Travel & Event Organizer Platform.

---

## Overview

Voda Tour & Event adalah website Company Profile + Dynamic Catalog berbasis Headless Architecture yang menyajikan informasi paket wisata, destinasi, gathering, dan kegiatan outbound untuk pelanggan korporat maupun perorangan.

Platform dirancang sebagai brosur online interaktif yang terhubung langsung ke WhatsApp inquiry (tanpa online booking/sistem pembayaran) dan dioptimalkan untuk SEO-first serta performa tinggi.

---

## Technology Stack

| Layer         | Teknologi                         |
| ------------- | --------------------------------- |
| Frontend      | Astro 7, Tailwind CSS 4, TypeScript |
| Backend (CMS) | Directus 11 (Headless CMS)        |
| Database      | PostgreSQL 16                     |
| Cache         | Redis 7 (Optional/Idle)           |
| Storage       | Cloudflare R2 (Optional) / Local  |
| Infrastruktur | Docker Compose, Nginx             |
| Paket Manajer | pnpm, TypeScript                  |

---

## Repository Structure

```
voda-tour-event/
├── apps/
│   └── web/          # Astro Frontend — Website & UI (15+ pages)
├── docs/             # Dokumentasi lengkap
│   ├── adr/          # Architecture Decision Records (Directus, Astro, Postgres)
│   ├── architecture/ # System Architecture Specification
│   ├── database/     # Relational Database Schema & Table Specs
│   ├── development/  # Setup Guide, API Specs, Git branching workflow
│   ├── features/     # Feature Spec (Search logic)
│   └── frontend/     # Design System (Colors, Typography), SEO
├── infrastructure/   # Docker config, Dockerfile web, Nginx config
├── mockup/           # Static HTML mockups
└── .ai/              # AI Agent konfigurasi, context, & session memory
```

---

## Documentation

Semua dokumentasi berada pada folder `docs/`.

**Mulai membaca:**

| Dokumen              | Path                                     |
| -------------------- | ---------------------------------------- |
| Product Requirements | `docs/product/product-requirements.md`   |
| System Architecture  | `docs/architecture/architecture.md`      |
| Database Design      | `docs/database/database-design.md`       |
| API Specification    | `docs/development/api-integration.md`    |
| Setup Guide          | `docs/development/setup.md`              |
| Design System        | `docs/frontend/design-system.md`         |
| Frontend Structure   | `docs/frontend/structure.md`             |
| SEO Specification    | `docs/frontend/seo.md`                   |
| Search Feature Specs | `docs/features/search.md`                |

---

## Quick Start

### 1. Prerequisites

- Node.js LTS (v20 atau lebih baru)
- pnpm (`npm install -g pnpm`)
- Docker + Docker Compose

### 2. Setup Environment Variables

Copy template environment variables di level infrastruktur dan web app:

```bash
# 1. Setup Backend / Database
cp infrastructure/.env.example infrastructure/.env

# 2. Setup Astro Frontend
cp apps/web/.env.example apps/web/.env
```

*Sesuaikan isian variabel di dalam berkas `.env` tersebut.*

### 3. Jalankan Database & CMS (Docker)

```bash
cd infrastructure
docker compose up -d
```

Ini akan menginisialisasi:
- **PostgreSQL 16** (Database relasional utama)
- **Directus 11** (Headless CMS pada port `8055`)

*Akses Directus di `http://localhost:8055`. Default login:*
* Email: `admin@vodatrip.id`
* Password: `admin123`

### 4. Jalankan Astro Dev Server

Buka terminal baru di folder root proyek, lalu masuk ke folder web app:

```bash
cd apps/web
pnpm install
pnpm dev
```

Astro dev server akan berjalan di: **`http://localhost:4321`**

---

## Commands

| Perintah | Folder | Efek |
|---|---|---|
| `docker compose up -d` | `infrastructure/` | 🚀 Jalankan Postgres & Directus CMS |
| `docker compose down` | `infrastructure/` | Hentikan PostgreSQL & Directus CMS |
| `pnpm install` | `apps/web/` | Pasang dependensi Astro Frontend |
| `pnpm dev` | `apps/web/` | Jalankan Astro Frontend dalam mode watch |
| `pnpm build` | `apps/web/` | Compile aplikasi Astro untuk production |

---

## Project Status

| Feature                     | Status |
| --------------------------- | ------ |
| Regions & Destinations      | ✅     |
| Travel Packages List        | ✅     |
| Package Detail (SSR)        | ✅     |
| Outbound & Gathering Catalog| ✅     |
| Directus CMS Integration    | ✅     |
| Dynamic Pricing Logic (Pax) | ✅     |
| Search Engine (Dest & Pkg)  | ✅     |
| Responsive UI (Navy/Orange) | ✅     |
| WhatsApp Inquiry Integration| ✅     |
| SEO & Sitemap Generator     | ✅     |
| WebP Image Processing       | ✅     |

---

## Engineering Principles

- Headless Architecture (Frontend & Backend Terpisah)
- Performance First (Lighthouse Score >= 90)
- Accessibility First (WCAG AA compliant)
- SEO First (JSON-LD & OpenGraph Ready)
- Zero Javascript on Initial Load (Kecuali modul pencarian)
- Documentation First

---

## How to Deploy

Deployment ke **Shared VPS** (Berbagi port 80/443 dengan website lain menggunakan Nginx utama VPS):

### 1. Persiapan Awal
Kloning repository di VPS dan salin env production:
```bash
git clone <repo> && cd voda-tour-event
cp infrastructure/.env.prod.example infrastructure/.env.prod
nano infrastructure/.env.prod # Isi credentials database dan CMS
```

### 2. Jalankan Container (Bypass Nginx Bawaan Docker)
Di VPS, matikan container `nginx` dan `certbot` bawaan Compose agar tidak memperebutkan port 80/443. Hanya jalankan `postgres`, `directus`, dan `web`:
```bash
docker compose --env-file infrastructure/.env.prod -f docker-compose.prod.yml up -d postgres directus web --build
```
* Astro Web akan berjalan di port host **`4322`**.
* Directus CMS akan berjalan di port host **`8055`**.

### 3. Konfigurasi Nginx Utama VPS
Tambahkan server block berikut pada Nginx utama VPS Anda agar me-routing traffic domain ke port Docker:

```nginx
# Astro Web (Frontend)
server {
    listen 80;
    server_name vodatrip.id www.vodatrip.id;
    location / {
        proxy_pass http://127.0.0.1:4322;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Directus CMS (Backend)
server {
    listen 80;
    server_name api.vodatrip.id;
    location / {
        proxy_pass http://127.0.0.1:8055;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 🔗 Local Production Preview (Tunneling)

Untuk memperlihatkan performa website produksi lokal Anda kepada atasan/klien secara *live*, gunakan **LocalTunnel**:

```bash
# 1. Jalankan tunnel Directus
lt --port 8055
# Catat link output (misal: https://voda-api.loca.lt)

# 2. Update 'PUBLIC_DIRECTUS_URL' di file 'infrastructure/.env.prod'
PUBLIC_DIRECTUS_URL=https://voda-api.loca.lt

# 3. Jalankan Docker Compose (wajib rebuild agar env Astro tertanam)
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d postgres directus web --build

# 4. Jalankan tunnel Astro Web
lt --port 4321
# Kirim link output (misal: https://voda-web.loca.lt) ke atasan/klien Anda.
```

## 🤖 CI/CD Deployment Secrets

Untuk mengaktifkan deployment otomatis via GitHub Actions, daftarkan variabel dan rahasia berikut pada repositori GitHub Anda di menu **Settings → Secrets and variables → Actions**:

### Secrets (Repository Secrets)

| Nama | Keterangan / Contoh Nilai |
| --- | --- |
| `VPS_HOST` | Alamat IP VPS Produksi (misal: `202.1xx.xx.xxx`) |
| `VPS_USER` | Nama user SSH untuk deploy (misal: `deploy`) |
| `VPS_SSH_KEY` | Private SSH Key hasil `ssh-keygen` yang authorized di VPS |
| `VPS_PATH` | Lokasi folder project di VPS (misal: `/home/deploy/voda-tour-event`) |

---

## License

Private Repository.
