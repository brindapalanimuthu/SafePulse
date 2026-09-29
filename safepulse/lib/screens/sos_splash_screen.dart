import 'package:flutter/material.dart';
import '../theme/sos_theme.dart';
import '../widgets/sos_pulse_button.dart';

/// Black hero screen. [onSos] should call your existing alert trigger.
class SosSplashScreen extends StatelessWidget {
  final VoidCallback onSos;
  final VoidCallback onContinue;
  const SosSplashScreen({super.key, required this.onSos, required this.onContinue});

  Widget _feature(IconData i, String t) => Column(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SosColors.red.withOpacity(0.6)),
          ),
          child: Icon(i, color: SosColors.red, size: 20),
        ),
        const SizedBox(height: 8),
        Text(t, textAlign: TextAlign.center, style: SosText.body(10, color: Colors.white70, weight: FontWeight.w600, spacing: 1)),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SosColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
          child: Column(children: [
            Text('SOS', style: SosText.display(96, color: Colors.white)),
            const SizedBox(height: 10),
            Text('EXPERT HELP. ANYTIME.', style: SosText.body(11, color: Colors.white60, weight: FontWeight.w500, spacing: 4)),
            const Spacer(),
            SosPulseButton(onPressed: onSos, size: 300),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _feature(Icons.shield_outlined, '24/7\nPROTECTION'),
              _feature(Icons.location_on_outlined, 'REAL-TIME\nLOCATION'),
              _feature(Icons.lock_outline, 'PRIVATE &\nSECURE'),
            ]),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onContinue,
              child: Text('Continue', style: SosText.body(14, color: Colors.white, weight: FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}
