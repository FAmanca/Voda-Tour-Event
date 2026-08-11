/**
 * crowdsec-webhook — Directus Endpoint Extension
 *
 * Fungsi : Menerima alert dari CrowdSec via HTTP POST,
 *          menyimpan ke collection `security_alerts`,
 *          dan mengirim notifikasi email via Resend API.
 *
 * Endpoint : POST /custom/crowdsec-webhook
 *
 * Environment variables yang dibutuhkan (di .env.prod):
 *   CROWDSEC_WEBHOOK_SECRET  — Secret key untuk validasi header X-Crowdsec-Key
 *   RESEND_API_KEY           — API key dari resend.com
 *
 * Deployment:
 *   cd extensions/crowdsec-webhook && npm install && npm run build
 *   docker cp extensions/crowdsec-webhook/dist/. voda-directus-prod:/directus/extensions/crowdsec-webhook/dist/
 *   docker exec -u root voda-directus-prod chmod -R 777 /directus/extensions
 *   docker restart voda-directus-prod
 */

// Email tujuan notifikasi — pindahkan ke env variable bila perlu
const ALERT_EMAIL_TO = 'voda.event.organizer@gmail.com';
const ALERT_EMAIL_FROM = 'noreply@vodatrip.id';

/**
 * Kirim email notifikasi via Resend API
 */
async function sendAlertEmail(resendApiKey, alertData) {
  const { ip, scenario, duration, message } = alertData;

  const html = `
    <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
      <div style="background: #dc2626; color: white; padding: 16px 24px; border-radius: 8px 8px 0 0;">
        <h2 style="margin: 0;">🚨 Security Alert — Voda Tour</h2>
      </div>
      <div style="background: #f9fafb; padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;">
        <table style="width: 100%; border-collapse: collapse;">
          <tr>
            <td style="padding: 8px 0; color: #6b7280; width: 120px;">IP Address</td>
            <td style="padding: 8px 0; font-weight: bold; color: #111827;">${ip || '-'}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; color: #6b7280;">Scenario</td>
            <td style="padding: 8px 0; font-weight: bold; color: #111827;">${scenario || '-'}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; color: #6b7280;">Durasi Ban</td>
            <td style="padding: 8px 0; font-weight: bold; color: #111827;">${duration || '-'}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; color: #6b7280;">Pesan</td>
            <td style="padding: 8px 0; color: #111827;">${message || '-'}</td>
          </tr>
          <tr>
            <td style="padding: 8px 0; color: #6b7280;">Waktu</td>
            <td style="padding: 8px 0; color: #111827;">${new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' })} WIB</td>
          </tr>
        </table>
        <p style="margin-top: 16px; color: #6b7280; font-size: 13px;">
          IP tersebut telah otomatis diblokir oleh CrowdSec firewall bouncer.
        </p>
      </div>
    </div>
  `;

  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${resendApiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: ALERT_EMAIL_FROM,
      to: [ALERT_EMAIL_TO],
      subject: `🚨 [Voda Tour] Security Alert: ${scenario || 'Unknown'} — IP ${ip || 'Unknown'}`,
      html,
    }),
  });

  if (!response.ok) {
    const err = await response.text();
    throw new Error(`Resend API error: ${err}`);
  }

  return response.json();
}

export default (router, { services, env }) => {
  const { ItemsService } = services;

  /**
   * POST /custom/crowdsec-webhook
   * Dipanggil oleh CrowdSec saat ada IP yang terkena decision (ban).
   */
  router.post('/', async (req, res) => {
    try {
      // 1. Validasi secret key dari header
      const webhookSecret = env['CROWDSEC_WEBHOOK_SECRET'];
      const incomingKey = req.headers['x-crowdsec-key'];

      if (!webhookSecret || incomingKey !== webhookSecret) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      // 2. Parse payload dari CrowdSec
      // CrowdSec mengirim satu JSON per baris (newline-delimited)
      // Body bisa berupa string multi-baris atau object langsung
      let alerts = [];

      if (typeof req.body === 'string') {
        // Parse newline-delimited JSON
        alerts = req.body
          .split('\n')
          .map((line) => line.trim())
          .filter((line) => line.length > 0)
          .map((line) => {
            try { return JSON.parse(line); } catch { return null; }
          })
          .filter(Boolean);
      } else if (Array.isArray(req.body)) {
        alerts = req.body;
      } else if (req.body && typeof req.body === 'object') {
        alerts = [req.body];
      }

      if (alerts.length === 0) {
        return res.status(400).json({ error: 'No valid alert payload found' });
      }

      const resendApiKey = env['RESEND_API_KEY'];
      const schema = req.schema;

      // 3. Proses setiap alert
      for (const alert of alerts) {
        const alertData = {
          ip: alert.ip || null,
          scenario: alert.scenario || null,
          duration: alert.duration || null,
          message: alert.message || null,
          source: alert.source || 'crowdsec',
          raw: alert,
        };

        // 3a. Simpan ke collection security_alerts
        try {
          const alertsService = new ItemsService('security_alerts', { schema });
          await alertsService.createOne(alertData);
        } catch (dbErr) {
          console.error('[crowdsec-webhook] DB error:', dbErr.message);
          // Lanjutkan ke email meski DB gagal
        }

        // 3b. Kirim email via Resend
        if (resendApiKey) {
          try {
            await sendAlertEmail(resendApiKey, alertData);
          } catch (emailErr) {
            console.error('[crowdsec-webhook] Email error:', emailErr.message);
          }
        } else {
          console.warn('[crowdsec-webhook] RESEND_API_KEY tidak ada, email tidak terkirim');
        }
      }

      return res.status(200).json({ received: alerts.length });

    } catch (err) {
      console.error('[crowdsec-webhook] Unexpected error:', err.message || err);
      return res.status(500).json({ error: 'Internal server error' });
    }
  });
};
