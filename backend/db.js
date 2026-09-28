const { Pool } = require('pg');

// Uses DATABASE_URL from .env, e.g.:
// postgres://username:password@localhost:5432/safepulse
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on('error', (err) => {
  console.error('Unexpected PostgreSQL error on idle client', err);
});

module.exports = pool;