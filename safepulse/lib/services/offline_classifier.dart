import '../models/classification_result.dart';
import '../screens/emergency_classification_screen.dart';

/// Simple keyword-matching classifier that works fully offline.
/// Used as a fallback when there's no network connectivity, or to give
/// an instant first-pass result while the cloud classifier is pending.
class OfflineClassifier {
  static final Map<EmergencyCategory, List<String>> _keywords = {
    EmergencyCategory.fire: ['fire', 'burning', 'smoke', 'flames'],
    EmergencyCategory.gasLeak: ['gas', 'leak', 'smell gas', 'lpg'],
    EmergencyCategory.roadAccident: [
      'accident',
      'crash',
      'collision',
      'car hit',
      'bike hit',
    ],
    EmergencyCategory.medical: [
      'hurt',
      'pain',
      'bleeding',
      'unconscious',
      'heart',
      'breathe',
      'breathing',
    ],
    EmergencyCategory.flood: ['flood', 'water rising', 'drowning', 'rain'],
  };

  /// Classifies free-text input (e.g. from voice transcription).
  /// Returns EmergencyCategory.other with low confidence if nothing matches.
  ClassificationResult classifyText(String text) {
    final lowerText = text.toLowerCase();

    for (final entry in _keywords.entries) {
      for (final keyword in entry.value) {
        if (lowerText.contains(keyword)) {
          return ClassificationResult(
            category: entry.key,
            confidence: 0.6,
            source: 'offline',
            note: 'Matched keyword "$keyword"',
          );
        }
      }
    }

    return const ClassificationResult(
      category: EmergencyCategory.other,
      confidence: 0.2,
      source: 'offline',
      note: 'No keyword match found',
    );
  }

  /// Classifies a category the user picked manually from the UI.
  /// Manual selection is always high confidence.
  ClassificationResult classifyManualSelection(EmergencyCategory category) {
    return ClassificationResult(
      category: category,
      confidence: 1.0,
      source: 'offline',
      note: 'User-selected category',
    );
  }
}