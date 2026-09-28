import 'dart:io';
import '../models/classification_result.dart';
import '../screens/emergency_classification_screen.dart';
import 'cloud_classifier_client.dart';
import 'offline_classifier.dart';

/// Single entry point the UI calls into for classification.
/// Tries the cloud classifier first (more accurate); if that fails
/// (no network, timeout, server error), falls back to the offline
/// keyword classifier so the app still works without connectivity.
class ClassificationService {
  final CloudClassifierClient _cloudClient;
  final OfflineClassifier _offlineClassifier;

  ClassificationService({
    CloudClassifierClient? cloudClient,
    OfflineClassifier? offlineClassifier,
  })  : _cloudClient = cloudClient ?? CloudClassifierClient(),
        _offlineClassifier = offlineClassifier ?? OfflineClassifier();

  /// Classify from free text (e.g. voice transcription).
  Future<ClassificationResult> classifyText(String text) async {
    try {
      return await _cloudClient.classifyText(text);
    } catch (_) {
      return _offlineClassifier.classifyText(text);
    }
  }

  /// Classify from a photo.
  Future<ClassificationResult> classifyImage(File imageFile) async {
    try {
      return await _cloudClient.classifyImage(imageFile);
    } catch (_) {
      // No offline image classification available yet — fall back to
      // "other" with low confidence so the user isn't blocked.
      return const ClassificationResult(
        category: EmergencyCategory.other,
        confidence: 0.2,
        source: 'offline',
        note: 'Cloud unavailable — could not classify image offline',
      );
    }
  }

  /// Classify from a manually-picked category (grid tap).
  /// This is always trusted as-is — no cloud round trip needed.
  ClassificationResult classifyManualSelection(EmergencyCategory category) {
    return _offlineClassifier.classifyManualSelection(category);
  }

  void dispose() {
    _cloudClient.dispose();
  }
}