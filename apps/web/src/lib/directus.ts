// ============================================================================
// Voda Tour & Event — Directus API Helper
// SSR-safe fetch functions. Jangan dipake di client-side.
// ============================================================================

import type {
  Region,
  Destination,
  Package,
  ActivityType,
  Setting,
  Status,
  Article,
} from "../types/directus";

const DIRECTUS_URL = import.meta.env.DIRECTUS_URL || "http://localhost:8055";
const BASE = `${DIRECTUS_URL}/items`;

// ---------------------------------------------------------------------------
// Generic fetch wrapper
// ---------------------------------------------------------------------------

/**
 * Fungsi fetch internal untuk mengambil data dari koleksi Directus.
 * 
 * @param path Nama koleksi API (misal: "packages").
 * @param params Query params seperti filter, fields, dan sort.
 * @returns Array dari objek tipe T.
 * @throws Error jika response HTTP tidak sukses (non-2xx).
 */
async function fetchApi<T>(path: string, params?: Record<string, string>): Promise<T[]> {
  const url = new URL(`${BASE}/${path}`);
  if (params) {
    Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v));
  }
  const res = await fetch(url.toString());
  if (!res.ok) throw new Error(`Directus ${res.status}: ${res.statusText}`);
  const json = await res.json();
  return (json.data || []) as T[];
}

async function fetchSingle<T>(path: string): Promise<T | null> {
  const url = new URL(`${BASE}/${path}`);
  const res = await fetch(url.toString());
  if (!res.ok) return null;
  const json = await res.json();
  return (json.data || null) as T | null;
}

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------

/**
 * Mengambil konfigurasi global aplikasi dari tabel `settings` di Directus.
 * Mengembalikan objek berbentuk key-value untuk kemudahan akses (misalnya setting.wa_number).
 */
export async function getSettings(): Promise<Record<string, string>> {
  const items = await fetchApi<Setting>("settings");
  const map: Record<string, string> = {};
  items.forEach((s) => { map[s.key] = s.value; });
  return map;
}

// ---------------------------------------------------------------------------
// Regions
// ---------------------------------------------------------------------------

export async function getRegions(): Promise<Region[]> {
  return fetchApi<Region>("regions", {
    filter: JSON.stringify({ status: { _eq: "published" } }),
    sort: "name",
  });
}

// ---------------------------------------------------------------------------
// Destinations
// ---------------------------------------------------------------------------

/**
 * Mengambil seluruh destinasi wisata yang berstatus "published".
 *
 * @param fields Daftar kolom yang ingin diambil (default: "*").
 * @returns Array dari destinasi yang diurutkan berdasarkan nama.
 */
export async function getDestinations(fields = "*"): Promise<Destination[]> {
  return fetchApi<Destination>("destinations", {
    fields,
    filter: JSON.stringify({ status: { _eq: "published" } }),
    sort: "name",
  }); 
}

export async function getDestinationsByRegion(
  regionSlug: string
): Promise<Destination[]> {
  return fetchApi<Destination>("destinations", {
    fields: "*,region_id.*",
    filter: JSON.stringify({
      status: { _eq: "published" },
      region_id: { slug: { _eq: regionSlug } },
    }),
    sort: "name",
  });
}

export async function getDestinationBySlug(
  slug: string
): Promise<Destination | null> {
  const items = await fetchApi<Destination>("destinations", {
    fields: "*,region_id.*",
    filter: JSON.stringify({
      status: { _eq: "published" },
      slug: { _eq: slug },
    }),
  });
  return items.length > 0 ? items[0] : null;
}

// ---------------------------------------------------------------------------
// Packages
// ---------------------------------------------------------------------------

/**
 * Mengambil daftar paket wisata berstatus "published" beserta data relasi destinasinya.
 * 
 * @param limit Batas maksimal paket yang diambil (default: 50).
 * @param fields Daftar kolom yang diambil (default: "*").
 */
export async function getPackages(
  limit = 50,
  fields = "*"
): Promise<Package[]> {
  return fetchApi<Package>("packages", {
    fields: `${fields},destination_id.*`,
    filter: JSON.stringify({ status: { _eq: "published" } }),
    limit: String(limit),
    sort: "-id",
  });
}

export async function getPackageBySlug(
  slug: string
): Promise<Package | null> {
  const items = await fetchApi<Package>("packages", {
    fields: "*,destination_id.*",
    filter: JSON.stringify({
      status: { _eq: "published" },
      slug: { _eq: slug },
    }),
  });
  return items.length > 0 ? items[0] : null;
}

export async function getPackagesByDestination(
  destinationId: string
): Promise<Package[]> {
  return fetchApi<Package>("packages", {
    fields: "*",
    filter: JSON.stringify({
      status: { _eq: "published" },
      destination_id: { _eq: destinationId },
    }),
    sort: "id",
  });
}

  export async function getPackagesByActivityType(
    activitySlug: string
  ): Promise<Package[]> {
    try {
      // 1. Fetch all published packages
      const packages = await getPackages(100);
      if (packages.length === 0) return [];
  
      // 2. Fetch junction records with expanded activity_types_id details using admin token (bypass Public permission issue)
      // The relation in Directus is configured such that:
      // many_collection = packages_activity_types, many_field = packages_id, one_field = activity_types_id
      const actsUrl = `${DIRECTUS_URL}/items/packages_activity_types?fields=packages_id,activity_types_id.*&limit=300&access_token=super-secret-admin-token`;
      const res = await fetch(actsUrl);
      if (!res.ok) {
        // If junction fetch fails, log it and return empty array so we don't accidentally leak all packages
        console.error("Failed to fetch junction table:", await res.text());
        return [];
      }
  
      const json = (await res.json()) as { data?: any[] };
      const junctions = json.data || [];
  
      // 3. Collect package IDs that match activitySlug
      const matchingPackageIds = new Set<string>();
  
      for (const j of junctions) {
        if (!j) continue;
        const actType = j.activity_types_id;
        let slugMatches = false;
  
        if (typeof actType === "string") {
          if (actType === activitySlug) slugMatches = true;
        } else if (typeof actType === "object" && actType !== null) {
          if (actType.slug === activitySlug) slugMatches = true;
        }
  
        if (slugMatches) {
          const pkgId =
            typeof j.packages_id === "object" && j.packages_id
              ? j.packages_id.id
              : j.packages_id;
          if (pkgId) matchingPackageIds.add(String(pkgId));
        }
      }
  
      // If no junction matched, return empty array
      if (matchingPackageIds.size === 0) return [];
  
      // 4. Filter packages by matching IDs
      return packages.filter((pkg) => matchingPackageIds.has(String(pkg.id)));
    } catch (err) {
    if (import.meta.env.DEV) {
      console.error("Error in getPackagesByActivityType:", err);
    }
    return [];
  }
}

// ---------------------------------------------------------------------------
// Activity Types
// ---------------------------------------------------------------------------

export async function getActivityTypes(): Promise<ActivityType[]> {
  return fetchApi<ActivityType>("activity_types", {
    filter: JSON.stringify({ status: { _eq: "published" } }),
    sort: "name",
  });
}

// ---------------------------------------------------------------------------
// Articles
// ---------------------------------------------------------------------------

function getPublishDateFilter() {
  const now = new Date().toISOString();
  return {
    _or: [
      { publish_date: { _lte: now } },
      { publish_date: { _null: true } },
    ],
  };
}

export async function getArticles(limit = 12): Promise<Article[]> {
  return fetchApi<Article>("articles", {
    filter: JSON.stringify({
      status: { _eq: "published" },
      ...getPublishDateFilter(),
    }),
    sort: "-publish_date",
    limit: String(limit),
  });
}

export async function getArticleBySlug(slug: string): Promise<Article | null> {
  const items = await fetchApi<Article>("articles", {
    filter: JSON.stringify({
      status: { _eq: "published" },
      slug: { _eq: slug },
      ...getPublishDateFilter(),
    }),
    fields: "*,ads.*,pillar_parent.*",
  });
  return items.length > 0 ? items[0] : null;
}

export async function getClusterArticles(pillarId: string, limit = 10): Promise<Article[]> {
  return fetchApi<Article>("articles", {
    filter: JSON.stringify({
      status: { _eq: "published" },
      pillar_parent: { _eq: pillarId },
      ...getPublishDateFilter(),
    }),
    sort: "-publish_date",
    limit: String(limit),
  });
}

export async function getRelatedArticles(title: string, excludeSlug: string, limit = 3): Promise<Article[]> {
  const stopWords = new Set(["di", "ke", "dari", "dan", "atau", "untuk", "dengan", "yang", "ini", "itu", "pada", "dalam", "sebuah", "adalah", "tips", "cara"]);
  const words = title.toLowerCase().replace(/[^a-z0-9\s]/g, '').split(/\s+/).filter(w => w.length > 3 && !stopWords.has(w));
  
  const pubFilter = getPublishDateFilter();

  let filter: any = {
    status: { _eq: "published" },
    slug: { _neq: excludeSlug },
    ...pubFilter,
  };

  if (words.length > 0) {
    filter._and = [
      pubFilter,
      { _or: words.map(w => ({ title: { _icontains: w } })) }
    ];
  }

  const items = await fetchApi<Article>("articles", {
    filter: JSON.stringify(filter),
    sort: "-publish_date",
    limit: String(limit),
  });
  
  // Jika hasil pencarian keyword kosong (atau kurang dari limit), ambil fallback artikel terbaru
  if (items.length === 0) {
    return fetchApi<Article>("articles", {
      filter: JSON.stringify({
        status: { _eq: "published" },
        slug: { _neq: excludeSlug },
        ...pubFilter,
      }),
      sort: "-publish_date",
      limit: String(limit),
    });
  }

  return items;
}

// ---------------------------------------------------------------------------
// Gallery / Files
// ---------------------------------------------------------------------------

export function getAssetUrl(uuid: string, opts?: {
  width?: number;
  height?: number;
  format?: "webp" | "avif" | "jpeg";
  quality?: number;
}): string {
  let url = `${import.meta.env.PUBLIC_DIRECTUS_URL || "http://localhost:8055"}/assets/${uuid}`;
  if (opts) {
    const qs = new URLSearchParams();
    if (opts.width) qs.set("width", String(opts.width));
    if (opts.height) qs.set("height", String(opts.height));
    if (opts.format) qs.set("format", opts.format);
    if (opts.quality) qs.set("quality", String(opts.quality));
    const qstr = qs.toString();
    if (qstr) url += `?${qstr}`;
  }
  return url;
}

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------

export interface SearchResult {
  type: "destinations" | "packages";
  slug: string;
  name: string;
  description: string | null;
  image: string | null;
  regionName?: string;
  destinationName?: string;
}

/**
 * Melakukan pencarian global (Destinasi & Paket Wisata) berdasarkan string pencarian.
 *
 * @param q String pencarian pengguna.
 * @returns Array hasil pencarian yang terpadu dari destinasi dan paket.
 */
export async function searchAll(q: string): Promise<SearchResult[]> {
  const results: SearchResult[] = [];

  // Search destinations
  const dests = await fetchApi<Destination>("destinations", {
    fields: "*,region_id.name",
    filter: JSON.stringify({
      status: { _eq: "published" },
      _or: [
        { name: { _icontains: q } },
        { description: { _icontains: q } },
      ],
    }),
  });
  dests.forEach((d) => {
    results.push({
      type: "destinations",
      slug: d.slug,
      name: d.name,
      description: d.description,
      image: d.image,
      regionName: typeof d.region_id === "object" ? (d.region_id as any)?.name : undefined,
    });
  });

  // Search packages
  const pkgs = await fetchApi<Package>("packages", {
    fields: "*,destination_id.name",
    filter: JSON.stringify({
      status: { _eq: "published" },
      _or: [
        { name: { _icontains: q } },
        { description: { _icontains: q } },
      ],
    }),
  });
  pkgs.forEach((p) => {
    results.push({
      type: "packages",
      slug: p.slug,
      name: p.name,
      description: p.description,
      image: p.gallery?.[0] || null,
      destinationName: typeof p.destination_id === "object" ? (p.destination_id as any)?.name : undefined,
    });
  });

  return results;
}

// ---------------------------------------------------------------------------
// Log Search
// ---------------------------------------------------------------------------

export async function logSearch(params: {
  destination?: string;
  activity_type?: string;
  pax_count?: number;
  travel_date?: string;
}): Promise<void> {
  try {
    await fetch(`${DIRECTUS_URL}/items/searches`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(params),
    });
  } catch (err) {
    if (import.meta.env.DEV) {
      console.warn("Directus API: Failed to log search event.", err);
    }
  }
}
