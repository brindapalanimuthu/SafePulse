import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';

class ServiceRow {
  final IconData icon;
  final String title;
  final String body;
  const ServiceRow(this.icon, this.title, this.body);
}

class SosService {
  final IconData icon;
  final String name; // tile title
  final String tileSubtitle;
  final String label; // small red label on the detail screen
  final String headline;
  final String description;
  final String number;
  final String numberName;
  final List<ServiceRow> rows;
  final bool showMedicalDetails;

  const SosService({
    required this.icon,
    required this.name,
    required this.tileSubtitle,
    required this.label,
    required this.headline,
    required this.description,
    required this.number,
    required this.numberName,
    required this.rows,
    this.showMedicalDetails = false,
  });

  /// Helpline numbers are for India. Change them here if you target another country.
  static const all = <SosService>[
    SosService(
      icon: Icons.add_rounded,
      name: 'Medical Emergency',
      tileSubtitle: 'Call an ambulance',
      label: 'Medical emergency',
      headline: 'HELP IS ONE\nCALL AWAY.',
      description: 'Call the ambulance service and tell them where you are.',
      number: '108',
      numberName: 'Ambulance',
      showMedicalDetails: true,
      rows: [
        ServiceRow(Icons.phone_in_talk_outlined, 'Calls 108', 'Connects you to emergency ambulance dispatch.'),
        ServiceRow(Icons.location_on_outlined, 'Share your location', 'Tell the operator where you are and what happened.'),
        ServiceRow(Icons.badge_outlined, 'Keep your details ready', 'Your blood group and notes from Profile are shown below.'),
      ],
    ),
    SosService(
      icon: Icons.shield_outlined,
      name: 'Security Assistance',
      tileSubtitle: 'Reach police and rescue',
      label: 'Security assistance',
      headline: 'YOU ARE\nNOT ALONE.',
      description: 'The national emergency number reaches police, fire and ambulance.',
      number: '112',
      numberName: 'National emergency number',
      rows: [
        ServiceRow(Icons.phone_in_talk_outlined, 'Calls 112', 'One number for police, fire and ambulance.'),
        ServiceRow(Icons.location_on_outlined, 'Give your location', 'Say where you are and stay on the line until help is confirmed.'),
        ServiceRow(Icons.notifications_active_outlined, 'Alert your circle', 'Use Start SOS alert below to run the full alert flow.'),
      ],
    ),
    SosService(
      icon: Icons.directions_car_outlined,
      name: 'Roadside Help',
      tileSubtitle: 'Breakdowns and accidents',
      label: 'Roadside help',
      headline: 'STUCK ON\nTHE ROAD?',
      description: 'The highway helpline covers breakdowns and accidents on national highway toll stretches. On other roads, call 112.',
      number: '1033',
      numberName: 'NHAI highway helpline',
      rows: [
        ServiceRow(Icons.phone_in_talk_outlined, 'Calls 1033', 'Toll-free, 24/7 national highway helpline.'),
        ServiceRow(Icons.car_repair_outlined, 'Breakdowns and accidents', 'Can arrange an ambulance, patrol vehicle or crane.'),
        ServiceRow(Icons.info_outline, 'Highways only', 'Not for other roads. Call 112 there.'),
      ],
    ),
    SosService(
      icon: Icons.flight_outlined,
      name: 'Travel Assistance',
      tileSubtitle: "Support while you're away",
      label: 'Travel assistance',
      headline: 'HELP WHILE\nYOU TRAVEL.',
      description: 'The Ministry of Tourism helpline gives travel guidance in 12 languages.',
      number: '1363',
      numberName: 'Tourist helpline',
      rows: [
        ServiceRow(Icons.phone_in_talk_outlined, 'Calls 1363', 'Free, 24/7 tourist helpline.'),
        ServiceRow(Icons.translate_rounded, 'Your language', 'Operators answer in English and eleven other languages.'),
        ServiceRow(Icons.warning_amber_rounded, 'Not an emergency line', 'For anything urgent, call 112 first.'),
      ],
    ),
  ];
}

class ServiceRequestScreen extends StatelessWidget {
  final SosService service;
  final VoidCallback onSos;
  const ServiceRequestScreen({super.key, required this.service, required this.onSos});

  Future<void> _call(BuildContext context, String number, String label) async {
    SosStore.instance.logActivity('$label: called $number');
    var ok = false;
    try {
      ok = await launchUrl(Uri(scheme: 'tel', path: number));
    } catch (_) {}
    if (!ok && context.mounted) {
      await Clipboard.setData(ClipboardData(text: number));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This device can't place calls. $number copied.")),
      );
    }
  }

  Widget _row(ServiceRow r) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle),
            child: Icon(r.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.title, style: SosText.body(13, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(r.body, style: SosText.body(12.5, color: SosColors.muted)),
            ]),
          ),
        ]),
      );

  Widget _details() {
    return ListenableBuilder(
      listenable: SosStore.instance,
      builder: (context, _) {
        final s = SosStore.instance;
        final lines = <String>[
          if (s.name.isNotEmpty) 'Name: ${s.name}',
          if (s.phone.isNotEmpty) 'Phone: ${s.phone}',
          if (s.bloodGroup.isNotEmpty) 'Blood group: ${s.bloodGroup}',
          if (s.note.isNotEmpty) 'Note: ${s.note}',
        ];
        if (lines.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: SosColors.canvas, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your details', style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final l in lines) Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(l, style: SosText.body(13))),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = service;
    return Scaffold(
      backgroundColor: SosColors.surface,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                    tooltip: 'Back',
                  ),
                ),
                const SizedBox(height: 22),
                Text(s.label, style: SosText.body(12, color: SosColors.red, weight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text(s.headline, style: SosText.display(46)),
                const SizedBox(height: 16),
                Text(s.description, style: SosText.body(13.5, color: SosColors.muted)),
                const SizedBox(height: 28),
                for (final r in s.rows) _row(r),
                if (s.showMedicalDetails) _details(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: SosColors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () => _call(context, s.number, s.name),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Call ${s.number}  ·  ${s.numberName}', style: SosText.body(14, color: Colors.white, weight: FontWeight.w700)),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.call, size: 18, color: SosColors.black),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (s.number != '112')
                  TextButton(
                    onPressed: () => _call(context, '112', 'Emergency'),
                    child: Text('In danger? Call 112', style: SosText.body(13, color: SosColors.red, weight: FontWeight.w600)),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onSos();
                  },
                  child: Text('Start SOS alert', style: SosText.body(13, color: SosColors.ink, weight: FontWeight.w600)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
