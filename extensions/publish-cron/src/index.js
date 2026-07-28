export default ({ schedule }, { services, database, getSchema }) => {
  const { ItemsService } = services;
  
  schedule('*/1 * * * *', async () => {
    try {
      const schema = await getSchema();
      const articlesService = new ItemsService('articles', { schema, knex: database });
      
      // Get scheduled articles where publish_date <= now
      // Because publish_date is timestamp without time zone, it stores the local time of the user literally.
      // Assuming user is in Asia/Jakarta (WIB)
      const nowRaw = new Date();
      const options = { timeZone: 'Asia/Jakarta', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
      const formatter = new Intl.DateTimeFormat('en-CA', options);
      const parts = formatter.formatToParts(nowRaw);
      const nowMap = {};
      parts.forEach(p => nowMap[p.type] = p.value);
      const now = `${nowMap.year}-${nowMap.month}-${nowMap.day}T${nowMap.hour}:${nowMap.minute}:${nowMap.second}`;

      const scheduledArticles = await articlesService.readByQuery({
        filter: {
          _and: [
            { status: { _eq: 'scheduled' } },
            { publish_date: { _lte: now } }
          ]
        },
        limit: -1
      });

      if (scheduledArticles && scheduledArticles.length > 0) {
        const keys = scheduledArticles.map(a => a.id);
        await articlesService.updateMany(keys, { status: 'published' });
        console.log(`[publish-cron] Published ${keys.length} scheduled articles.`);
      }

    } catch (err) {
      console.error('[publish-cron] Error:', err);
    }
  });
};
