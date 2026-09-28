import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/classification_result.dart';
import '../screens/emergency_classification_screen.dart';
import '../config.dart';

/// Talks to the SafePulse backend (Node.js/Express) for AI-driven
/// emergency classification. Falls back gracefully (throws) if the
/// network is unavailable — callers should catch and use
/// OfflineClassifier instead.
class CloudClassifierClient {
  static const String _baseUrl = '${Config.backendUrl}/api/classify';

  final http.Client _client;

  CloudClassifierClient({http.Client? client}) : _client = client ?? http.Client();

  Future<ClassificationResult> classifyText(String text) async {
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/text'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'text': text}),
        )
        .timeout(const Duration(seconds: 8));

    return _parseResponse(response);
  }

  Future<ClassificationResult> classifyImage(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/image'));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);

    return _parseResponse(response);
  }

  Future<ClassificationResult> classifyAudio(File audioFile) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/audio'));
    request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);

    return _parseResponse(response);
  }

  ClassificationResult _parseResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw HttpException(
        'Cloud classifier failed with status ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final categoryName = data['category'] as String? ?? 'other';
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.5;

    return ClassificationResult(
      category: _parseCategory(categoryName),
      confidence: confidence,
      source: 'cloud',
      note: data['note'] as String?,
    );
  }

  EmergencyCategory _parseCategory(String name) {
    switch (name) {
      case 'fire':
        return EmergencyCategory.fire;
      case 'gasLeak':
        return EmergencyCategory.gasLeak;
      case 'roadAccident':
        return EmergencyCategory.roadAccident;
      case 'medical':
        return EmergencyCategory.medical;
      case 'flood':
        return EmergencyCategory.flood;
      default:
        return EmergencyCategory.other;
    }
  }

  void dispose() {
    _client.close();
  }
}