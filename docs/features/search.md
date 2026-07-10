# Search Feature

Fitur pencarian multi-step (deep search) untuk membantu visitor menemukan paket yang sesuai.

## Flow

```
┌──────────────────────────────────────────────────┐
│  Step 1: Search Destinasi                       │
│  ┌──────────────────────────────────────────────┐│
│  │  Input: "band"                               ││
│  │  Hasil: ▼ Bandung                            ││
│  │            ├ Bandung (Kota)                  ││
│  │            └ Lembang                         ││
│  └──────────────────────────────────────────────┘│
│                                                  │
│  Step 2: Isi Detail                              │
│  ┌──────────────────────────────────────────────┐│
│  │  Destinasi    : [Lembang] ✓                  ││
│  │  Kegiatan     : [▼ Private Trip]             ││
│  │  Peserta      : [10] orang                   ││
│  │  Tanggal      : [📅 15-08-2026]              ││
│  │                                              ││
│  │  [🔍 Cari Paket]                             ││
│  └──────────────────────────────────────────────┘│
│                                                  │
│  Step 3: Hasil                                   │
│  ┌──────────────────────────────────────────────┐│
│  │  Ditemukan 3 paket di Lembang:               ││
│  │                                              ││
│  │  ┌─────────────────────────────────────┐     ││
│  │  │ Lembang Weekend 2D1N — Rp 850K     │     ││
│  │  │ 🏷 Private Trip · ⭐ Populer        │     ││
│  │  │ [Detail] [WA]                       │     ││
│  │  └─────────────────────────────────────┘     ││
│  └──────────────────────────────────────────────┘│
└──────────────────────────────────────────────────┘
```

## UI Components

### Search Input (Step 1)

Autocomplete input dengan debounce (300ms):

```html
<div class="search-autocomplete relative">
  <input
    type="text"
    id="searchInput"
    placeholder="Cari destinasi..."
    class="w-full px-4 py-3 rounded-lg border"
    autocomplete="off"
  />
  <div id="searchResults" class="absolute top-full left-0 right-0 bg-white border rounded-lg mt-1 shadow-lg hidden">
    <!-- Hasil pencarian di-render oleh JavaScript -->
  </div>
</div>
```

### Search Form (Step 2)

Form yang muncul setelah destinasi dipilih:

| Field | Type | Source Data |
|-------|------|-------------|
| Destinasi | Read-only text | Dari Step 1 |
| Jenis Kegiatan | Dropdown | `GET /items/activity_types` |
| Jumlah Peserta | Input number | — |
| Tanggal Berangkat | Date picker | — |

### Hasil (Step 3)

List paket yang cocok, difilter berdasarkan:
- Destinasi yang dipilih
- Activity type (dari relasi many-to-many)
- Jumlah peserta (dicocokkan dengan `price_tiers`)

## Data Source & Filtering

### Step 1 — Autocomplete

Data destinasi di-load sekali saat page load:

```
GET /items/destinations?fields=id,name,region_id.name,slug&filter[status][_eq]=published&sort=name
```

Filter di sisi client menggunakan **vanilla JS** (search string → cocokkan dengan nama destinasi & region).

### Step 3 — Hasil Pencarian

```
GET /items/packages
  ?fields=*,destination_id.name,duration,price_tiers,gallery
  &filter[destination_id][slug][_eq]={destination_slug}
  &filter[status][_eq]=published
```

Filter activity type dilakukan di frontend atau dengan filter lanjutan via Directus M2M:

```
GET /items/packages
  ?fields=*,...
  &filter[activity_types][activity_types_id][slug][_eq]={activity_slug}
```

## Logging ke Searches

Setiap submit pencarian, data dikirim ke Astro endpoint `/api/search`:

```javascript
// Client-side JavaScript
document.getElementById("searchForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const data = {
    destination_name: selectedDestination,
    region_name: selectedRegion,
    activity_type_name: selectedActivity,
    pax_count: parseInt(paxInput.value),
    travel_date: dateInput.value
  };

  // Simpan ke DB (anonim)
  await fetch("/api/search", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data)
  });

  // Redirect ke halaman hasil atau tampilkan hasil
  window.location.href = `/cari?destinasi=${selectedDestination}&kegiatan=${selectedActivity}`;
});
```

## File Penerapan

| File | Keterangan |
|------|-----------|
| `src/components/SearchForm.astro` | Form step 1 + 2 (autocomplete + detail) |
| `src/components/SearchResult.astro` | Hasil pencarian (step 3) |
| `src/pages/cari.astro` | Halaman hasil pencarian (SSR) |
| `src/pages/api/search.ts` | Endpoint POST untuk simpan log + ambil hasil |
| `src/lib/search.js` | Vanilla JS: autocomplete, debounce, form handler |

## Catatan

- Autocomplete 100% client-side — tidak ada request tambahan saat mengetik.
- Data destinasi di-load saat SSR (embedded di HTML) → instant search.
- Halaman `/cari` menggunakan SSR agar SEO tetap optimal.
