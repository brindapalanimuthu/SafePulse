// Placeholder text classification + real image classification via
// Hugging Face's free Inference API (google/vit-base-patch16-224).
//
// The text classifier mirrors the Flutter app's offline_classifier.dart
// keyword approach. Swap it for a real NLP/LLM call when ready — keep
// the response shape { category, confidence, note } since that's what
// lib/services/cloud_classifier_client.dart expects.

const KEYWORDS = {
  fire: ['fire', 'burning', 'smoke', 'flames'],
  gasLeak: ['gas', 'leak', 'smell gas', 'lpg'],
  roadAccident: ['accident', 'crash', 'collision', 'car hit', 'bike hit'],
  medical: ['hurt', 'pain', 'bleeding', 'unconscious', 'heart', 'breathe', 'breathing'],
  flood: ['flood', 'water rising', 'drowning', 'rain'],
};

function classifyText(text) {
  const lower = (text || '').toLowerCase();

  for (const [category, words] of Object.entries(KEYWORDS)) {
    for (const word of words) {
      if (lower.includes(word)) {
        return {
          category,
          confidence: 0.75,
          note: `Matched keyword "${word}" (server-side placeholder classifier)`,
        };
      }
    }
  }

  return {
    category: 'other',
    confidence: 0.3,
    note: 'No keyword match found (server-side placeholder classifier)',
  };
}

// Maps ImageNet-style labels (from google/vit-base-patch16-224) to
// SafePulse emergency categories. The model wasn't trained specifically
// for emergencies, so we match on related concepts it does know.
const IMAGE_LABEL_KEYWORDS = {
  fire: ['flame', 'fire', 'matchstick', 'volcano', 'lighter', 'torch', 'campfire'],
  gasLeak: ['gas pump', 'gas mask', 'oxygen mask', 'tank, storage tank'],
  roadAccident: [
    'car', 'automobile', 'sports car', 'pickup', 'trailer truck', 'tow truck',
    'wreck', 'ambulance', 'motor scooter', 'moped', 'minibus',
  ],
  medical: [
    'stretcher', 'syringe', 'bandage', 'crutch', 'wheelchair', 'hospital',
    'medicine chest', 'thermometer',
  ],
  flood: ['seashore', 'lakeside', 'boathouse', 'dam', 'breakwater', 'geyser'],
};

/**
 * Calls the Hugging Face Inference API with the given image buffer and
 * returns a SafePulse-shaped classification result.
 */
async function classifyImage(imageBuffer) {
  const apiKey = process.env.HUGGINGFACE_API_KEY;

  if (!apiKey) {
    return {
      category: 'other',
      confidence: 0.2,
      note: 'HUGGINGFACE_API_KEY not set — cannot classify image',
    };
  }

  const response = await fetch(
    'https://router.huggingface.co/hf-inference/models/google/vit-base-patch16-224',
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/octet-stream',
      },
      body: imageBuffer,
    }
  );

  if (!response.ok) {
    const errText = await response.text();
    throw new Error(`Hugging Face API error (${response.status}): ${errText}`);
  }

  const predictions = await response.json();
  // predictions: [{ label: "matchstick", score: 0.87 }, ...]

  if (!Array.isArray(predictions) || predictions.length === 0) {
    return {
      category: 'other',
      confidence: 0.2,
      note: 'No predictions returned from image model',
    };
  }

  // Check top predictions against our keyword map, in order of confidence.
  for (const prediction of predictions) {
    const label = (prediction.label || '').toLowerCase();
    for (const [category, keywords] of Object.entries(IMAGE_LABEL_KEYWORDS)) {
      for (const keyword of keywords) {
        if (label.includes(keyword)) {
          return {
            category,
            confidence: Math.min(prediction.score, 0.85), // cap confidence, model isn't emergency-trained
            note: `Image labeled "${prediction.label}" matched to ${category}`,
          };
        }
      }
    }
  }

  // No match found among top predictions — fall back to "other".
  return {
    category: 'other',
    confidence: 0.25,
    note: `Top image label "${predictions[0].label}" did not match a known emergency type`,
  };
}

// Placeholder audio classifier. The Flutter app already transcribes
// speech on-device and sends text via classifyText(), so this endpoint
// isn't currently used by the app's normal flow — kept for completeness.
function classifyAudioPlaceholder() {
  return {
    category: 'other',
    confidence: 0.2,
    note: 'Audio classification not implemented server-side — app transcribes on-device instead',
  };
}

module.exports = { classifyText, classifyImage, classifyAudioPlaceholder };