import type { APIRoute } from "astro";

const DIRECTUS_URL = import.meta.env.DIRECTUS_URL || "http://localhost:8055";
const SITE_URL = import.meta.env.SITE_URL || "https://vodatrip.id";

export const GET: APIRoute = async () => {
  let destinations: { slug: string; updated_at: string }[] = [];
  let packages: { slug: string; updated_at: string }[] = [];

  try {
    const [destRes, pkgRes] = await Promise.all([
      fetch(DIRECTUS_URL + "/items/destinations?fields=slug,updated_at&filter[status][_eq]=published"),
      fetch(DIRECTUS_URL + "/items/packages?fields=slug,updated_at&filter[status][_eq]=published"),
    ]);
    if (destRes.ok) { const j = await destRes.json(); destinations = j.data || []; }
    if (pkgRes.ok) { const j = await pkgRes.json(); packages = j.data || []; }
  } catch {}

  const staticPages = [
    { loc: "/", priority: "1.0", changefreq: "weekly" },
    { loc: "/destinasi", priority: "0.9", changefreq: "weekly" },
    { loc: "/paket", priority: "0.9", changefreq: "weekly" },
    { loc: "/gathering", priority: "0.8", changefreq: "weekly" },
    { loc: "/galeri", priority: "0.6", changefreq: "monthly" },
    { loc: "/tentang", priority: "0.7", changefreq: "monthly" },
    { loc: "/kontak", priority: "0.7", changefreq: "monthly" },
  ];

  const NL = "\n";

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  ${staticPages
    .map(
      (p) => `  <url>
    <loc>${SITE_URL}${p.loc}</loc>
    <priority>${p.priority}</priority>
    <changefreq>${p.changefreq}</changefreq>
  </url>`
    )
    .join(NL)}
  ${destinations
    .map(
      (d) => `  <url>
    <loc>${SITE_URL}/destinasi/${d.slug}</loc>
    <lastmod>${d.updated_at}</lastmod>
    <priority>0.7</priority>
    <changefreq>weekly</changefreq>
  </url>`
    )
    .join(NL)}
  ${packages
    .map(
      (p) => `  <url>
    <loc>${SITE_URL}/paket/${p.slug}</loc>
    <lastmod>${p.updated_at}</lastmod>
    <priority>0.6</priority>
    <changefreq>weekly</changefreq>
  </url>`
    )
    .join(NL)}
</urlset>`;

  return new Response(xml, {
    headers: { "Content-Type": "application/xml; charset=utf-8" },
  });
};
