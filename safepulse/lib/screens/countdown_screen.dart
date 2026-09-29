import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/sos_theme.dart';
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
          HapticFeedback.selectionClick();
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
      backgroundColor: SosColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(children: [
            Text(l10n.fallDetected.toUpperCase(), textAlign: TextAlign.center, style: SosText.display(34, color: Colors.white)),
            const Spacer(),
            SizedBox(
              width: 260,
              height: 260,
              child: Stack(alignment: Alignment.center, children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(end: _secondsLeft / _startSeconds),
                  duration: const Duration(milliseconds: 900),
                  builder: (_, v, _) => SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: v,
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                      color: SosColors.red,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ),
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: SosColors.red.withValues(alpha: 0.35), blurRadius: 60)],
                  ),
                ),
                Semantics(
                  liveRegion: true,
                  label: '$_secondsLeft seconds left',
                  child: Text('$_secondsLeft', style: SosText.display(120, color: Colors.white)),
                ),
              ]),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: SosColors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: _cancelCountdown,
                child: Text(l10n.cancelCountdown, style: SosText.body(15, color: SosColors.black, weight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}