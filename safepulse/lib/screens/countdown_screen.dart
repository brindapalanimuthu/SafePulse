import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'emergency_classification_screen.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  static const int _startSeconds = 10;
  int _secondsLeft = _startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
          _triggerEmergency();
        }
      });
    });
  }

  void _cancelCountdown() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  void _triggerEmergency() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const EmergencyClassificationScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.fallDetected,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              '$_secondsLeft',
              style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _cancelCountdown,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(l10n.cancelCountdown),
            ),
          ],
        ),
      ),
    );
  }
}
