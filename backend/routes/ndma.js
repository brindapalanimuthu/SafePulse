const express = require('express');
const pool = require('../db');
const router = express.Router();

const TEXTBEE_API_KEY = process.env.TEXTBEE_API_KEY;
const TEXTBEE_DEVICE_ID = process.env.TEXTBEE_DEVICE_ID;
const EMERGENCY_CONTACT_NUMBER = process.env.EMERGENCY_CONTACT_NUMBER;

async function sendEmergencySms({ category, latitude, longitude }) {
  if (!TEXTBEE_API_KEY || !TEXTBEE_DEVICE_ID || !EMERGENCY_CONTACT_NUMBER) {
    return { sent: false, error: 'SMS not configured (missing textbee env vars)' };
  }

  const mapsLink = `https://maps.google.com/?q=${latitude},${longitude}`;
  const message =
    `SafePulse Emergency Alert\n` +
    `Type: ${category}\n` +
    `Location: ${mapsLink}`;

  try {
    const response = await fetch(
      `https://api.textbee.dev/api/v1/gateway/devices/${TEXTBEE_DEVICE_ID}/send-sms`,
      {
        method: 'POST',
        headers: {
          'x-api-key': TEXTBEE_API_KEY,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          recipients: [EMERGENCY_CONTACT_NUMBER],
          message,
        }),
      }
    );

    if (!response.ok) {
      const errText = await response.text();
      return { sent: false, error: `textbee error (${response.status}): ${errText}` };
    }

    return { sent: true };
  } catch (err) {
    return { sent: false, error: err.message };
  }
}

router.post('/notify', async (req, res) => {
  const { category, confidence, latitude, longitude, timestamp } = req.body;

  if (!category || latitude === undefined || longitude === undefined) {
    return res.status(400).json({
      error: 'Missing required fields: category, latitude, longitude',
    });
  }

  let dbResult;
  try {
    dbResult = await pool.query(
      `INSERT INTO emergencies (category, confidence, latitude, longitude, created_at)
       VALUES ($1, $2, $3, $4, COALESCE($5, now()))
       RETURNING id, created_at`,
      [category, confidence ?? null, latitude, longitude, timestamp ?? null]
    );
    console.log('[NDMA notify] Logged emergency', dbResult.rows[0]);
  } catch (err) {
    console.error('Failed to log emergency to database:', err.message);
  }

  const smsResult = await sendEmergencySms({ category, latitude, longitude });
  if (smsResult.sent) {
    console.log('[NDMA notify] SMS alert sent to emergency contact');
  } else {
    console.warn('[NDMA notify] SMS alert not sent:', smsResult.error);
  }

  res.json({
    success: true,
    message: 'Emergency logged and emergency contact notified (NDMA integration pending official API access)',
    id: dbResult?.rows[0]?.id,
    receivedAt: dbResult?.rows[0]?.created_at ?? new Date().toISOString(),
    smsSent: smsResult.sent,
    smsError: smsResult.sent ? undefined : smsResult.error,
  });
});

router.get('/history', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, category, confidence, latitude, longitude, created_at
       FROM emergencies
       ORDER BY created_at DESC
       LIMIT 50`
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
