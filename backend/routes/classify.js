const express = require('express');
const multer = require('multer');
const fs = require('fs');
const {
  classifyText,
  classifyImage,
  classifyAudioPlaceholder,
} = require('../classifier');

const router = express.Router();
const upload = multer({ dest: 'uploads/' });

router.post('/text', (req, res) => {
  const { text } = req.body;
  if (!text || typeof text !== 'string') {
    return res.status(400).json({ error: 'Missing "text" field in request body' });
  }
  const result = classifyText(text);
  res.json(result);
});

router.post('/image', upload.single('image'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'Missing "image" file in request' });
  }

  try {
    const imageBuffer = fs.readFileSync(req.file.path);
    const result = await classifyImage(imageBuffer);
    res.json(result);
  } catch (err) {
    console.error('Image classification failed:', err.message);
    res.status(500).json({ error: 'Image classification failed', detail: err.message });
  } finally {
    fs.unlink(req.file.path, () => {});
  }
});

router.post('/audio', upload.single('audio'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'Missing "audio" file in request' });
  }
  const result = classifyAudioPlaceholder();
  fs.unlink(req.file.path, () => {});
  res.json(result);
});

module.exports = router;
