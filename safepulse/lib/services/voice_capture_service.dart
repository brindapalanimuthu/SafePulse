import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Wraps speech_to_text for capturing voice input and transcribing it
/// to plain text, which the ClassificationService can then classify.
class VoiceCaptureService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  /// Call once before first use. Returns true if the device supports
  /// speech recognition and permission was granted.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );
    return _isInitialized;
  }

  bool get isListening => _speech.isListening;

  bool get isAvailable => _isInitialized;

  /// Starts listening and streams partial + final transcriptions via
  /// [onResult]. Call [stopListening] to end early.
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: stt.SpeechListenOptions(
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  void dispose() {
    _speech.cancel();
  }
}