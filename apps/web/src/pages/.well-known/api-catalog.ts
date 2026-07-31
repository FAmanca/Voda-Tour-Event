import type { APIRoute } from 'astro';

const SITE = 'https://vodatrip.id';

/**
 * API Catalog — RFC 9727
 *
 * Returns a linkset document describing available APIs and their relations.
 * See: https://www.rfc-editor.org/rfc/rfc9727
 */
export const GET: APIRoute = async () => {
  const linkset = {
    linkset: [
      {
        anchor: SITE,
        'service-meta': [
          {
            href: `${SITE}/sitemap-index.xml`,
            type: 'application/xml',
          },
          {
            href: `${SITE}/llms.txt`,
            type: 'text/plain',
          },
        ],
        collection: [
          {
            href: `${SITE}/paket`,
            type: 'text/markdown',
            title: 'Daftar Paket Wisata Voda Tour',
          },
          {
            href: `${SITE}/artikel`,
            type: 'text/markdown',
            title: 'Daftar Artikel & Blog',
          },
          {
            href: `${SITE}/destinasi`,
            type: 'text/markdown',
            title: 'Daftar Destinasi Populer',
          },
          {
            href: `${SITE}/gathering`,
            type: 'text/markdown',
            title: 'Layanan Corporate Gathering',
          },
        ],
        search: [
          {
            href: `${SITE}/cari?q={query}`,
            type: 'text/markdown',
            title: 'Pencarian Paket Wisata',
          },
        ],
      },
    ],
  };

  return new Response(JSON.stringify(linkset, null, 2), {
    status: 200,
    headers: {
      'Content-Type': 'application/json', // Menggunakan json agar mudah dibaca di browser (Brave/Chrome)
      'Cache-Control': 'public, max-age=3600',
    },
  });
};
