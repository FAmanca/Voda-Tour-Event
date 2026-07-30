/**
 * publish-cron — Directus Hook Extension
 *
 * Fungsi : Otomatis mengubah status artikel dari "scheduled" menjadi "published"
 *          saat `publish_date` sudah terlewati (berdasarkan zona waktu Asia/Jakarta).
 *
 * Jadwal : Setiap menit (* * * * *)
 *
 * Alasan menggunakan Hook Extension (bukan Directus Flow):
 * - Directus Flow (Visual No-Code) tidak mendukung bulk-update array ID secara
 *   andal pada `item-update` block, sehingga log menunjukkan "sukses" tapi status
 *   tidak berubah di database.
 * - `new Date().toISOString()` di dalam Flow menghasilkan waktu UTC, sedangkan
 *   kolom `publish_date` di tabel `articles` bertipe `timestamp without time zone`
 *   yang menyimpan waktu lokal (WIB) secara literal — sehingga perbandingan
 *   langsung menyebabkan selisih 7 jam.
 * - Hook Extension ini menangani kedua masalah di atas: bulk-update menggunakan
 *   `ItemsService.updateMany()` dan timezone di-format secara eksplisit ke WIB.
 *
 * Deployment:
 *   cd extensions/publish-cron && npm run build
 *   docker cp extensions/publish-cron/dist/. voda-directus:/directus/extensions/publish-cron/dist/
 *   docker exec -u root voda-directus chmod -R 777 /directus/extensions
 *   docker restart voda-directus
 */

// Timezone untuk perbandingan publish_date (kolom disimpan sebagai waktu lokal WIB)
const TIMEZONE = 'Asia/Jakarta';

/**
 * Menghasilkan string datetime dalam format ISO lokal (tanpa offset)
 * sesuai zona waktu yang diberikan.
 * @returns {string} contoh: "2026-07-28T14:05:00"
 */
function getNowInTimezone(tz) {
  const nowRaw = new Date();
  const options = {
    timeZone: tz,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  };
  const parts = new Intl.DateTimeFormat('en-CA', options).formatToParts(nowRaw);
  const p = {};
  parts.forEach((part) => { if (part.type !== 'literal') p[part.type] = part.value; });
  return `${p.year}-${p.month}-${p.day}T${p.hour}:${p.minute}:${p.second}`;
}

export default ({ schedule }, { services, database, getSchema }) => {
  const { ItemsService } = services;

  schedule('* * * * *', async () => {
    try {
      const schema = await getSchema();
      const articlesService = new ItemsService('articles', { schema, knex: database });

      const now = getNowInTimezone(TIMEZONE);

      const scheduledArticles = await articlesService.readByQuery({
        filter: {
          _and: [
            { status: { _eq: 'scheduled' } },
            { publish_date: { _lte: now } },
          ],
        },
        limit: -1,
      });

      if (scheduledArticles && scheduledArticles.length > 0) {
        const keys = scheduledArticles.map((a) => a.id);
        await articlesService.updateMany(keys, { status: 'published' });
        console.log(`[publish-cron] Published ${keys.length} scheduled article(s).`);
      }
    } catch (err) {
      console.error('[publish-cron] Error:', err.message || err);
    }
  });
};
