import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/calm_mode_service.dart';

class CalmModeScreen extends StatefulWidget {
  final List<String> firstAidSteps;

  const CalmModeScreen({super.key, required this.firstAidSteps});

  @override
  State<CalmModeScreen> createState() => _CalmModeScreenState();
}

class _CalmModeScreenState extends State<CalmModeScreen>
    with SingleTickerProviderStateMixin {
  final CalmModeService _calmModeService = CalmModeService();
  late AnimationController _breathController;
  bool _isGuiding = false;
  String? _statusOverride;

  static const List<String> _breathingLines = [
    'Let\'s take a slow breath together.',
    'Breathe in... two... three... four.',
    'Hold... two... three.',
    'Breathe out... two... three... four.',
    'Good. You\'re doing fine.',
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  Future<void> _startGuidance(AppLocalizations l10n) async {
    setState(() {
      _isGuiding = true;
      _statusOverride = l10n.calmModeBreathing;
    });

    await _calmModeService.speakSequence(_breathingLines);

    if (!mounted) return;
    setState(() => _statusOverride = null);

    await _calmModeService.speakSequence(widget.firstAidSteps);

    if (!mounted) return;
    setState(() {
      _isGuiding = false;
      _statusOverride = null;
    });
  }

  Future<void> _stopGuidance() async {
    await _calmModeService.stop();
    setState(() {
      _isGuiding = false;
      _statusOverride = null;
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _calmModeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusText = _statusOverride ?? l10n.calmModeReady;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2A4A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(l10n.calmModeTitle, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, child) {
                final scale = 0.8 + (_breathController.value * 0.4);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlueAccent.withValues(alpha: 0.3),
                      border: Border.all(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _isGuiding ? _stopGuidance : () => _startGuidance(l10n),
              icon: Icon(_isGuiding ? Icons.stop : Icons.play_arrow),
              label: Text(_isGuiding ? l10n.calmModeStop : l10n.calmModeStart),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B2A4A),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}