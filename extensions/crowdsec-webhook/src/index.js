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
function escapeHtml(value) {
  if (!value) return '-';
  return String(value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

async function sendAlertEmail(resendApiKey, alertData) {
  const { ip, scenario, duration, message } = alertData;

  const subject = `🚨 [Voda Tour] Security Alert: ${scenario || 'Unknown'} — IP ${ip || 'Unknown'}`;
  
  const textLines = [
    `Severity: CRITICAL`,
    `Host: vodatrip-prod`,
    `Event: ${scenario}`,
    `Source IP: ${ip || '-'}`,
    `Duration: ${duration || '-'}`,
    `Message: ${message || '-'}`,
    `Time: ${new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' })} WIB`
  ];
  const text = textLines.join('\n');

  const html = [
    '<div style="font-family:monospace;max-width:640px;margin:0 auto">',
    `<h2 style="color:#c0392b">${escapeHtml(subject)}</h2>`,
    `<pre style="white-space:pre-wrap;background:#f8f9fa;padding:16px;border-radius:8px">${escapeHtml(text)}</pre>`,
    '<p style="color:#7f8c8d;font-size:12px">Dikirim otomatis oleh sistem keamanan Voda Tour</p>',
    '</div>',
  ].join('\n');

  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${resendApiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: 'Voda Tour Security <noreply@vodatrip.id>',
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

export default {
  id: 'crowdsec-webhook',
  handler: (router, { services, env }) => {
    const { ItemsService } = services;

    /**
     * POST /crowdsec-webhook/
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
        let alerts = [];

        if (typeof req.body === 'string') {
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
  }
};
