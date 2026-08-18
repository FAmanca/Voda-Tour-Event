import type { APIRoute } from "astro";

const DIRECTUS_URL = import.meta.env.DIRECTUS_URL || "http://localhost:8055";
const SITE_URL = import.meta.env.SITE_URL || "https://vodatrip.id";

/**
 * Formats a date string into a valid W3C DateTime format for sitemaps.
 * Fallback to dateCreated if dateUpdated is null/empty.
 */
function formatLastmod(dateUpdated?: string | null, dateCreated?: string | null): string {
  const dateStr = dateUpdated || dateCreated;
  if (!dateStr) return "";
  try {
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return "";
    return d.toISOString();
  } catch {
    return "";
  }
}

export const GET: APIRoute = async () => {
  let destinations: { slug: string; date_created?: string | null; date_updated?: string | null }[] = [];
  let packages: { slug: string; date_created?: string | null; date_updated?: string | null }[] = [];
  let articles: { slug: string; date_created?: string | null; date_updated?: string | null }[] = [];
  let transportRegions: { slug: string; date_created?: string | null; date_updated?: string | null }[] = [];

  const [destRes, pkgRes, articleRes, transportRes] = await Promise.all([
    fetch(DIRECTUS_URL + "/items/destinations?fields=slug,date_created,date_updated&filter[status][_eq]=published", { cache: "no-store" }).catch(() => null),
    fetch(DIRECTUS_URL + "/items/packages?fields=slug,date_created,date_updated&filter[status][_eq]=published", { cache: "no-store" }).catch(() => null),
    fetch(DIRECTUS_URL + "/items/articles?fields=slug,date_created,date_updated&filter[status][_eq]=published", { cache: "no-store" }).catch(() => null),
    fetch(DIRECTUS_URL + "/items/transport_regions?fields=slug,date_created,date_updated&filter[status][_eq]=published", { cache: "no-store" }).catch(() => null),
  ]);
  if (destRes?.ok) { try { const data = await destRes.json(); destinations = data.data || []; } catch {} }
  if (pkgRes?.ok) { try { const data = await pkgRes.json(); packages = data.data || []; } catch {} }
  if (articleRes?.ok) { try { const data = await articleRes.json(); articles = data.data || []; } catch {} }
  if (transportRes?.ok) { try { const data = await transportRes.json(); transportRegions = data.data || []; } catch {} }

  const staticPages = [
    { loc: "/", priority: "1.0", changefreq: "weekly" },
    { loc: "/destinasi", priority: "0.9", changefreq: "weekly" },
    { loc: "/paket", priority: "0.9", changefreq: "weekly" },
    { loc: "/transport", priority: "0.9", changefreq: "weekly" },
    { loc: "/gathering", priority: "0.8", changefreq: "weekly" },
    { loc: "/galeri", priority: "0.6", changefreq: "monthly" },
    { loc: "/tentang", priority: "0.7", changefreq: "monthly" },
    { loc: "/kontak", priority: "0.7", changefreq: "monthly" },
    { loc: "/artikel", priority: "0.9", changefreq: "daily" },
  ];

  const NL = "\n";

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  ${staticPages
    .map(
      (page) => `  <url>
    <loc>${SITE_URL}${page.loc}</loc>
    <priority>${page.priority}</priority>
    <changefreq>${page.changefreq}</changefreq>
  </url>`
    )
    .join(NL)}
  ${destinations
    .map((dest) => {
      const lastmod = formatLastmod(dest.date_updated, dest.date_created);
      return `  <url>
    <loc>${SITE_URL}/destinasi/${dest.slug}</loc>${lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : ""}
    <priority>0.7</priority>
    <changefreq>weekly</changefreq>
  </url>`;
    })
    .join(NL)}
  ${packages
    .map((pkg) => {
      const lastmod = formatLastmod(pkg.date_updated, pkg.date_created);
      return `  <url>
    <loc>${SITE_URL}/paket/${pkg.slug}</loc>${lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : ""}
    <priority>0.6</priority>
    <changefreq>weekly</changefreq>
  </url>`;
    })
    .join(NL)}
  ${articles
    .map((art) => {
      const lastmod = formatLastmod(art.date_updated, art.date_created);
      return `  <url>
    <loc>${SITE_URL}/artikel/${art.slug}</loc>${lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : ""}
    <priority>0.8</priority>
    <changefreq>daily</changefreq>
  </url>`;
    })
    .join(NL)}
  ${transportRegions
    .map((region) => {
      const lastmod = formatLastmod(region.date_updated, region.date_created);
      return `  <url>
    <loc>${SITE_URL}/transport/${region.slug}</loc>${lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : ""}
    <priority>0.7</priority>
    <changefreq>weekly</changefreq>
  </url>`;
    })
    .join(NL)}
</urlset>`;

  return new Response(xml, {
    headers: { "Content-Type": "application/xml; charset=utf-8" },
  });
};
