import 'package:flutter/material.dart';
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
          Text('Welcome back,', style: SosText.body(14)),
          const SizedBox(height: 4),
          Text(userName.toUpperCase(), style: SosText.display(56)),
          const SizedBox(height: 22),
          Text('How can we help?', style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
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
                boxShadow: [BoxShadow(color: SosColors.red.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Active SOS', style: SosText.body(12, color: Colors.white70, weight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('TAP FOR HELP', style: SosText.display(28, color: Colors.white)),
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
          Text('Quick services', style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final s in SosService.all) ...[
            ServiceTile(
              icon: s.icon,
              accent: s == SosService.all.first,
              title: s.name,
              subtitle: s.tileSubtitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ServiceRequestScreen(service: s, onSos: onSos)),
              ),
            ),
            const SizedBox(height: 10),
          ],
          ServiceTile(icon: Icons.sensors_outlined, title: 'Simulate fall', subtitle: 'Test fall detection', onTap: onSos),
        ],
      ),
    );
  }
}
