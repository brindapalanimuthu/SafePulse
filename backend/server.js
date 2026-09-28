require('dotenv').config();
const express = require('express');
const cors = require('cors');

const classifyRoutes = require('./routes/classify');
const ndmaRoutes = require('./routes/ndma');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ status: 'SafePulse backend running' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/classify', classifyRoutes);
app.use('/api/ndma', ndmaRoutes);

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.listen(PORT, () => {
  console.log(`SafePulse backend listening on http://localhost:${PORT}`);
});
