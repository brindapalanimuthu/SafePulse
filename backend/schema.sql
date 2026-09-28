-- Run this once against your safepulse database to create the schema.
-- e.g.: psql -U your_user -d safepulse -f schema.sql

CREATE TABLE IF NOT EXISTS emergencies (
  id SERIAL PRIMARY KEY,
  category TEXT NOT NULL,
  confidence REAL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_emergencies_created_at ON emergencies (created_at);