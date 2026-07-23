import type { APIRoute } from "astro";

const DIRECTUS_URL = import.meta.env.DIRECTUS_URL || "http://localhost:8055";
const SITE_URL = import.meta.env.SITE_URL || "https://vodatrip.id";

export const GET: APIRoute = async () => {
  let destinations: { slug: string; date_updated: string }[] = [];
  let packages: { slug: string; date_updated: string }[] = [];
  let articles: { slug: string; date_updated: string }[] = [];

  try {
    const [destRes, pkgRes, articleRes] = await Promise.all([
      fetch(DIRECTUS_URL + "/items/destinations?fields=slug,date_updated&filter[status][_eq]=published"),
      fetch(DIRECTUS_URL + "/items/packages?fields=slug,date_updated&filter[status][_eq]=published"),
      fetch(DIRECTUS_URL + "/items/articles?fields=slug,date_updated&filter[status][_eq]=published&filter[_or][0][publish_date][_lte]=" + encodeURIComponent(new Date().toISOString()) + "&filter[_or][1][publish_date][_null]=true"),
    ]);
    if (destRes.ok) { const data = await destRes.json(); destinations = data.data || []; }
    if (pkgRes.ok) { const data = await pkgRes.json(); packages = data.data || []; }
    if (articleRes.ok) { const data = await articleRes.json(); articles = data.data || []; }
  } catch {}

  const staticPages = [
    { loc: "/", priority: "1.0", changefreq: "weekly" },
    { loc: "/destinasi", priority: "0.9", changefreq: "weekly" },
    { loc: "/paket", priority: "0.9", changefreq: "weekly" },
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
    .map(
      (dest) => `  <url>
    <loc>${SITE_URL}/destinasi/${dest.slug}</loc>
    <lastmod>${dest.date_updated}</lastmod>
    <priority>0.7</priority>
    <changefreq>weekly</changefreq>
  </url>`
    )
    .join(NL)}
  ${packages
    .map(
      (pkg) => `  <url>
    <loc>${SITE_URL}/paket/${pkg.slug}</loc>
    <lastmod>${pkg.date_updated}</lastmod>
    <priority>0.6</priority>
    <changefreq>weekly</changefreq>
  </url>`
    )
    .join(NL)}
  ${articles
    .map(
      (art) => `  <url>
    <loc>${SITE_URL}/artikel/${art.slug}</loc>
    <lastmod>${art.date_updated}</lastmod>
    <priority>0.8</priority>
    <changefreq>daily</changefreq>
  </url>`
    )
    .join(NL)}
</urlset>`;

  return new Response(xml, {
    headers: { "Content-Type": "application/xml; charset=utf-8" },
  });
};
