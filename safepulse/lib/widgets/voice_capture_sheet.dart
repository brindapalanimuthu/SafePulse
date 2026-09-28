import 'package:flutter/material.dart';
import '../services/voice_capture_service.dart';

/// Bottom sheet that records voice, shows live transcription, and
/// returns the final transcribed text when the user confirms.
class VoiceCaptureSheet extends StatefulWidget {
  const VoiceCaptureSheet({super.key});

  @override
  State<VoiceCaptureSheet> createState() => _VoiceCaptureSheetState();

  /// Convenience to show the sheet and get back the transcribed text
  /// (or null if the user cancelled).
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const VoiceCaptureSheet(),
    );
  }
}

class _VoiceCaptureSheetState extends State<VoiceCaptureSheet> {
  final VoiceCaptureService _voiceService = VoiceCaptureService();
  String _transcript = '';
  bool _isListening = false;
  String _statusText = 'Tap the mic to start';

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Future<void> _startListening() async {
    final available = await _voiceService.initialize();
    if (!available) {
      setState(() => _statusText = 'Speech recognition unavailable on this device');
      return;
    }

    setState(() {
      _isListening = true;
      _statusText = 'Listening...';
    });

    await _voiceService.startListening(
      onResult: (text, isFinal) {
        setState(() {
          _transcript = text;
          if (isFinal) {
            _isListening = false;
            _statusText = 'Tap the mic to try again, or confirm below';
          }
        });
      },
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      await _startListening();
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _statusText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _toggleListening,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: _isListening ? Colors.redAccent : Colors.grey.shade300,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 36,
                color: _isListening ? Colors.white : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _transcript.isEmpty ? 'Your speech will appear here...' : _transcript,
              style: TextStyle(
                color: _transcript.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _transcript.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_transcript),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Use this'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}