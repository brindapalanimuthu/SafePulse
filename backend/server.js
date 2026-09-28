require('dotenv').config();
const express = require('express');
const cors = require('cors');

const classifyRoutes = require('./routes/classify');
const ndmaRoutes = require('./routes/ndma');

const app = express();
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // listen on all interfaces so a real phone can connect

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

app.listen(PORT, HOST, () => {
  console.log(`SafePulse backend listening on port ${PORT} (all interfaces)`);
  console.log(`Local:   http://localhost:${PORT}`);
  console.log(`Network: http://<your-mac-ip>:${PORT}`);
});