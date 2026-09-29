import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../theme/sos_theme.dart';
import '../widgets/service_tile.dart';
import 'service_request_screen.dart';

class SosHomeScreen extends StatelessWidget {
  final String userName;
  final VoidCallback onSos;
  const SosHomeScreen({super.key, required this.userName, required this.onSos});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final services = SosService.all(t);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              onSelected: (l) => SafePulseApp.setLocale(context, l),
              itemBuilder: (_) => const {
                'English': Locale('en'),
                'हिन्दी': Locale('hi'),
                'தமிழ்': Locale('ta'),
                'తెలుగు': Locale('te'),
                'ಕನ್ನಡ': Locale('kn'),
                'বাংলা': Locale('bn'),
              }.entries.map((e) => PopupMenuItem(value: e.value, child: Text(e.key))).toList(),
            ),
            Stack(children: [
              const Icon(Icons.notifications_none_rounded),
              Positioned(
                right: 2,
                top: 2,
                child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle)),
              ),
            ]),
          ]),
          const SizedBox(height: 28),
          Text(t.welcomeBack, style: SosText.body(14)),
          const SizedBox(height: 4),
          Text(userName.toUpperCase(), style: SosText.display(56)),
          const SizedBox(height: 22),
          Text(t.howCanWeHelp, style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onSos,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF2E3A), SosColors.redDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: SosColors.red.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.activeSos, style: SosText.body(12, color: Colors.white70, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(t.tapForHelp, style: SosText.display(28, color: Colors.white)),
                  ]),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white38, width: 1.5)),
                  child: Center(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.circle, size: 10, color: SosColors.red),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 26),
          Text(t.quickServices, style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final s in services) ...[
            ServiceTile(
              icon: s.icon,
              accent: s == services.first,
              title: s.name,
              subtitle: s.tileSubtitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ServiceRequestScreen(service: s, onSos: onSos)),
              ),
            ),
            const SizedBox(height: 10),
          ],
          ServiceTile(icon: Icons.sensors_outlined, title: t.tileSimulateFall, subtitle: t.tileSimulateFallSub, onTap: onSos),
        ],
      ),
    );
  }
}
