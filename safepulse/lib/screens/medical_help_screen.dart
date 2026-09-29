import 'package:flutter/material.dart';
import '../theme/sos_theme.dart';

class MedicalHelpScreen extends StatelessWidget {
  const MedicalHelpScreen({super.key});

  Widget _row(IconData i, String title, String body) => Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle),
            child: Icon(i, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: SosText.body(13, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(body, style: SosText.body(12.5, color: SosColors.muted)),
            ]),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SosColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16)),
              IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.phone_outlined, size: 18)),
            ]),
            const SizedBox(height: 26),
            Text('Medical emergency', style: SosText.body(12, color: SosColors.red, weight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text('EXPERT CARE,\nANYWHERE.', style: SosText.display(46)),
            const SizedBox(height: 16),
            Text('Connect instantly with top medical professionals and get the help you need, fast.',
                style: SosText.body(13.5, color: SosColors.muted)),
            const SizedBox(height: 30),
            _row(Icons.medical_services_outlined, '24/7 doctors', 'Access board-certified doctors anytime, anywhere.'),
            _row(Icons.location_on_outlined, 'ER navigation', 'We guide you to the nearest best-suited ER.'),
            _row(Icons.favorite_border_rounded, 'Follow-up care', 'Ongoing support for your recovery and peace of mind.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: SosColors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () {},
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Request medical help', style: SosText.body(14, color: Colors.white, weight: FontWeight.w700)),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_rounded, size: 18, color: SosColors.black),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.lock_outline, size: 13, color: SosColors.muted),
                const SizedBox(width: 6),
                Text('100% private & confidential', style: SosText.body(11, color: SosColors.muted)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
