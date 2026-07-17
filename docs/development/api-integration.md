# API Integration

Directus menyediakan REST API yang langsung bisa digunakan oleh Astro tanpa perlu backend tambahan.

## Base URL

```
http://localhost:8055  (development)
https://api.vodatrip.id  (production)
```

## Public Role

Directus memiliki fitur **Public Role** — role anonim yang dapat membaca data tanpa perlu token.

### Setup

1. Buka Settings → Access Control → Public Role
2. Set permission **Read** untuk collections: `regions`, `destinations`, `packages`, `activity_types`, `settings`
3. Permission **Create** untuk collection `searches`

Dengan ini, Astro bisa fetch data langsung tanpa API key.

> **⚠️ Jangan pernah set permission Create/Update/Delete untuk collections bisnis di Public Role.**

## Fetch Pattern di Astro

### Basic Fetch

```astro
---
// src/pages/destinasi.astro
const API = "http://localhost:8055";

const res = await fetch(`${API}/items/destinations?fields=*,region_id.name&filter[status][_eq]=published&sort=name`);
const { data: destinations } = await res.json();
---

<ul>
  {destinations.map(d => (
    <li>{d.name} — {d.region_id?.name}</li>
  ))}
</ul>
```

### Helper `lib/directus.ts`

Buat file helper agar fetch lebih bersih:

```typescript
// src/lib/directus.ts

const API = import.meta.env.DIRECTUS_URL || "http://localhost:8055";

interface FetchOptions {
  fields?: string;
  filter?: Record<string, any>;
  sort?: string;
  limit?: number;
  search?: string;
}

export async function fetchItems<T>(collection: string, opts: FetchOptions = {}): Promise<T[]> {
  const params = new URLSearchParams();

  if (opts.fields) params.set("fields", opts.fields);
  if (opts.filter) params.set("filter", JSON.stringify(opts.filter));
  if (opts.sort) params.set("sort", opts.sort);
  if (opts.limit) params.set("limit", String(opts.limit));
  if (opts.search) params.set("search", opts.search);

  const url = `${API}/items/${collection}?${params.toString()}`;
  const res = await fetch(url);
  const json = await res.json();
  return json.data ?? [];
}

export async function fetchItem<T>(collection: string, slug: string): Promise<T | null> {
  const res = await fetch(`${API}/items/${collection}?filter[slug][_eq]=${slug}&limit=1`);
  const json = await res.json();
  return json.data?.[0] ?? null;
}
```

### Environment Variable

Buat file `.env` di `apps/web/`:

```
DIRECTUS_URL=http://localhost:8055
```

### Fetch by Slug

Karena routing Astro pake `[slug]`, fetch data pake filter slug:

```astro
---
// src/pages/destinasi/[slug].astro
export async function getStaticPaths() {
  const destinations = await fetchItems("destinations", {
    fields: "slug",
    filter: { status: { _eq: "published" } }
  });
  return destinations.map(d => ({ params: { slug: d.slug } }));
}

const { slug } = Astro.params;
const destination = await fetchItem("destinations", slug);
---
```

## Endpoints yang Digunakan

### Collections (Read)

| Endpoint | Penggunaan | Fields |
|----------|-----------|--------|
| `GET /items/regions` | Nav, filter region | `*,image.data.*` |
| `GET /items/destinations` | List destinasi | `*,region_id.name,image.data.*` |
| `GET /items/packages` | List paket per destinasi | `*,destination_id.name,duration,price_tiers,image.data.*` |
| `GET /items/activity_types` | Dropdown filter kegiatan | `id,name,slug` |
| `GET /items/settings` | Konfigurasi global | `key,value` |

### Collections (Write)

| Endpoint | Penggunaan | Body |
|----------|-----------|------|
| `POST /items/searches` | Simpan pencarian visitor | `{ destination_name, region_name, activity_type_name, pax_count, travel_date }` |

### Files

| Endpoint | Penggunaan |
|----------|-----------|
| `GET /assets/{file_uuid}` | Mendapatkan file/image via Directus |
| `GET /assets/{file_uuid}?key={preset}` | Image dengan transform (resize, crop) |

## Images & Transformations

Directus mendukung image transformation via query parameter:

```astro
<img src={`${API}/assets/${dest.image}?width=600&height=400&fit=cover&format=webp`} />
```

Parameter yang didukung:
- `width` / `height` — Resize
- `fit=cover` / `contain` / `inside` / `outside`
- `format=webp` / `avif` — Konversi format
- `quality=80` — Kualitas

> ✅ Wajib pake `format=webp` + `quality=80` untuk PageSpeed optimal.

## Search (POST)

Frontend mengirim pencarian visitor via Astro endpoint (biar tidak expose Directus langsung):

```typescript
// src/pages/api/search.ts
export async function POST({ request }) {
  const body = await request.json();
  
  // Hash IP untuk anonimitas
  const ip = request.headers.get("x-forwarded-for") || "unknown";
  const ipHash = crypto.createHash("sha256").update(ip).digest("hex").slice(0, 16);
  
  await fetch(`${DIRECTUS_URL}/items/searches`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ ...body, ip_hash: ipHash })
  });
  
  return new Response(JSON.stringify({ ok: true }), { status: 200 });
}
```

## Sample API Responses

### Regions

```json
// GET /items/regions?fields=*,image.data.*&filter[status][_eq]=published&sort=name
{
  "data": [
    {
      "id": "a1b2c3d4-...",
      "name": "Bandung",
      "slug": "bandung",
      "description": "Kota kembang dengan pesona alam pegunungan...",
      "image": "file-uuid-here",
      "status": "published",
      "created_at": "2026-07-01T00:00:00.000Z",
      "updated_at": "2026-07-01T00:00:00.000Z"
    }
  ]
}
```

### Destinations (with nested region)

```json
// GET /items/destinations?fields=*,region_id.name,image.data.*&filter[status][_eq]=published&sort=name
{
  "data": [
    {
      "id": "b2c3d4e5-...",
      "region_id": { "name": "Bandung" },
      "name": "Lembang",
      "slug": "lembang",
      "description": "Kawasan pegunungan sejuk dengan view perkebunan...",
      "image": "file-uuid-here",
      "gallery": ["file-uuid-1", "file-uuid-2"],
      "status": "published",
      "created_at": "2026-07-01T00:00:00.000Z",
      "updated_at": "2026-07-01T00:00:00.000Z"
    }
  ]
}
```

### Packages (with price_tiers & nested destination)

```json
// GET /items/packages?fields=*,destination_id.name,duration,price_tiers&filter[status][_eq]=published
{
  "data": [
    {
      "id": "c3d4e5f6-...",
      "destination_id": { "name": "Lembang" },
      "name": "Lembang Weekend Escape",
      "slug": "lembang-weekend-escape",
      "description": "Akomodasi hotel bintang 3, transportasi AC, makan 3x...",
      "duration": "2D1N",
      "price_tiers": [
        {
          "table_title": "Harga Domestik (WNI)",
          "tiers": [
            { "min_pax": 2, "max_pax": 4, "price_per_pax": 850000, "description": "Hotel Bintang 3" },
            { "min_pax": 5, "max_pax": 10, "price_per_pax": 750000, "description": "Hotel Bintang 3" }
          ]
        }
      ],
      "addons": [
        {
          "addon_name": "Banana Boat",
          "price": 300000,
          "description": "Tambahan wahana air Banana Boat selama 15 menit"
        }
      ],
      "facilities": ["Hotel bintang 3", "Transportasi AC", "Guide lokal", "Dokumentasi"],
      "itinerary": [
        { "day": 1, "title": "Check-in & City Tour", "activities": ["08:00 - Breakfast", "09:00 - City Tour", "12:00 - Lunch", "14:00 - Check-in Hotel", "19:00 - Dinner"] },
        { "day": 2, "title": "Outbound & Check-out", "activities": ["07:00 - Breakfast", "08:00 - Outbound Games", "12:00 - Lunch", "14:00 - Check-out"] }
      ],
      "status": "published",
      "created_at": "2026-07-01T00:00:00.000Z"
    }
  ]
}
```

### Settings (Key-Value)

```json
// GET /items/settings?fields=key,value
{
  "data": [
    { "key": "site_name", "value": "Voda Tour & Event" },
    { "key": "whatsapp", "value": "6281234567890" },
    { "key": "email", "value": "hello@vodatrip.id" },
    { "key": "address", "value": "Jakarta, Indonesia" },
    { "key": "instagram", "value": "@vodatrip" }
  ]
}
```

### Activity Types

```json
// GET /items/activity_types?fields=id,name,slug&filter[status][_eq]=published
{
  "data": [
    { "id": "d4e5f6a7-...", "name": "Private Trip", "slug": "private-trip" },
    { "id": "e5f6a7b8-...", "name": "Corporate Gathering", "slug": "corporate-gathering" },
    { "id": "f6a7b8c9-...", "name": "Team Building", "slug": "team-building" },
    { "id": "a7b8c9d0-...", "name": "Family Vacation", "slug": "family-vacation" }
  ]
}
```

### Image Asset URL

```
GET /assets/{file_uuid}?width=600&height=400&fit=cover&format=webp&quality=80
```
