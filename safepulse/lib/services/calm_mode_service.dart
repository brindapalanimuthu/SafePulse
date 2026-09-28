import 'package:flutter_tts/flutter_tts.dart';

/// Provides slow, calm spoken guidance during an emergency using
/// text-to-speech. Used by Calm Mode to read breathing guidance and
/// first-aid steps aloud so the user doesn't have to read a screen
/// while panicked.
class CalmModeService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Slower rate and lower pitch for a calming tone.
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(0.95);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
    _tts.setErrorHandler((msg) => _isSpeaking = false);

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    await _tts.speak(text);
  }

  /// Speaks a sequence of lines with a pause between each, so it reads
  /// naturally rather than as one long run-on sentence.
  Future<void> speakSequence(List<String> lines) async {
    if (!_isInitialized) await initialize();
    for (final line in lines) {
      await _tts.speak(line);
      await _tts.awaitSpeakCompletion(true);
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  void dispose() {
    _tts.stop();
  }
}