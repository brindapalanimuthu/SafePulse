import 'package:flutter/material.dart';
import '../theme/sos_theme.dart';

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accent;
  const ServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SosColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SosColors.line),
          ),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: SosColors.canvas, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: accent ? SosColors.red : SosColors.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: SosText.body(14, weight: FontWeight.w600)),
                Text(subtitle, style: SosText.body(12, color: SosColors.muted)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: SosColors.muted),
          ]),
        ),
      ),
    );
  }
}
