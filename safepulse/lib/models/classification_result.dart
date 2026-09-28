import '../screens/emergency_classification_screen.dart';

/// Result returned by any classifier (offline or cloud).
class ClassificationResult {
  final EmergencyCategory category;
  final double confidence; // 0.0 - 1.0
  final String source; // 'offline' or 'cloud'
  final String? note; // optional human-readable explanation

  const ClassificationResult({
    required this.category,
    required this.confidence,
    required this.source,
    this.note,
  });

  @override
  String toString() =>
      'ClassificationResult(category: ${category.label}, confidence: $confidence, source: $source)';
}