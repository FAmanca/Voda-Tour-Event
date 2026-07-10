# Error Handling & State Management

## Prinsip

Setiap komponen yang menampilkan data dari Directus API **WAJIB** handle 4 state:

```
Data → Loading → Success/Empty/Error
```

### State Matrix

| State | Trigger | UI Component |
|-------|---------|-------------|
| **Loading** | Fetch sedang berjalan | Skeleton (bukan spinner teks) |
| **Success** | Fetch berhasil, data ≥ 1 | Render data normal |
| **Empty** | Fetch berhasil, data = 0 | Empty state (ilustrasi + copy ramah) |
| **Error** | Fetch gagal (network/500/403) | Error alert + retry button |

## Pattern Implementasi

### 1. Loading — Skeleton Component

Jangan pake teks "Loading..." atau spinner generic. Pake skeleton:

```astro
---
// src/components/SkeletonCard.astro
---
<div class="animate-pulse bg-gray-200 rounded-lg h-64 w-full">
  <div class="h-3/4 bg-gray-300 rounded-t-lg"></div>
  <div class="p-4 space-y-3">
    <div class="h-4 bg-gray-300 rounded w-3/4"></div>
    <div class="h-3 bg-gray-300 rounded w-1/2"></div>
  </div>
</div>
```

### 2. Empty State

Ramah, informatif, dengan ilustrasi:

```astro
---
// Pattern untuk empty state
const { title, description, icon, ctaText, ctaLink } = Astro.props;
---
<div class="text-center py-16 px-4">
  <div class="text-6xl mb-4">{icon || "🏝️"}</div>
  <h3 class="text-lg font-semibold text-gray-700 mb-2">
    {title || "Belum ada data"}
  </h3>
  <p class="text-gray-500 max-w-md mx-auto mb-6">
    {description || "Data belum tersedia saat ini. Coba lagi nanti."}
  </p>
  {ctaText && ctaLink && (
    <a href={ctaLink} class="btn-primary">{ctaText}</a>
  )}
</div>
```

### 3. Error State

```astro
---
// Pattern untuk error
const { message, onRetry } = Astro.props;
---
<div class="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
  <div class="text-4xl mb-2">⚠️</div>
  <p class="text-red-700 mb-4">
    {message || "Gagal memuat data. Silakan coba refresh."}
  </p>
  {onRetry && (
    <button onclick={onRetry} class="btn-outline text-red-600 border-red-300 hover:bg-red-100">
      🔄 Muat Ulang
    </button>
  )}
</div>
```

## Fetch Pattern (Astro SSR)

Server-side: error ditangani di page level, data dikirim ke component dengan flag.

```astro
---
// src/pages/destinasi.astro
import DestinasiCard from "../components/DestinasiCard.astro";

let destinations = [];
let fetchError = null;
let loading = true;

try {
  const res = await fetch(`${DIRECTUS_URL}/items/destinations?fields=*,region_id.name&filter[status][_eq]=published&sort=name`);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  const json = await res.json();
  destinations = json.data ?? [];
} catch (e) {
  fetchError = e.message;
} finally {
  loading = false;
}
---

<Layout>
  {loading && <div class="grid grid-cols-3 gap-6">{Array(3).fill(<SkeletonCard />)}</div>}

  {fetchError && (
    <div class="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
      <p class="text-red-700">⚠️ Gagal memuat data destinasi.</p>
    </div>
  )}

  {!loading && !fetchError && destinations.length === 0 && (
    <div class="text-center py-16">
      <div class="text-6xl mb-4">🗺️</div>
      <h3 class="text-lg font-semibold">Belum ada destinasi</h3>
      <p class="text-gray-500">Destinasi akan segera ditambahkan.</p>
    </div>
  )}

  {!loading && !fetchError && destinations.length > 0 && (
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {destinations.map(d => <DestinasiCard destination={d} showRegion />)}
    </div>
  )}
</Layout>
```

## Client-side Fetch (Search)

Untuk search form (client-side), pake pattern:

```typescript
// src/lib/search.js
export async function fetchSearchResults(params) {
  const result = { loading: true, data: null, error: null };

  try {
    const res = await fetch(`/api/search?${new URLSearchParams(params)}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    result.data = json.data;
  } catch (e) {
    result.error = e.message;
  } finally {
    result.loading = false;
  }

  return result;
}
```

## Error Boundary (Astro Component)

Untuk error di Astro component, pake `Astro.error()`:

```astro
---
if (!data || data.length === 0) {
  // Jangan throw error — return empty state via props
  // Atau redirect ke 404 kalo page detail
  return Astro.redirect("/404");
}
---
```

## Format Error Messages

| Bahasa | Pesan |
|--------|-------|
| Default | "Gagal memuat data. Silakan coba lagi." |
| Network | "Koneksi terputus. Periksa koneksi internet." |
| Server (5xx) | "Server sedang sibuk. Coba beberapa saat lagi." |
| Not Found (404) | "Halaman tidak ditemukan." |
| Rate Limit (429) | "Terlalu banyak permintaan. Tunggu sebentar." |
