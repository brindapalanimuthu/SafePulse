import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
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
  static List<SosService> all(AppLocalizations t) => [
        SosService(
          icon: Icons.add_rounded,
          name: t.svcMedicalName,
          tileSubtitle: t.svcMedicalSub,
          label: t.svcMedicalName,
          headline: t.svcMedicalHeadline,
          description: t.svcMedicalDesc,
          number: '108',
          numberName: t.svcMedicalNumberName,
          showMedicalDetails: true,
          rows: [
            ServiceRow(Icons.phone_in_talk_outlined, t.svcMedicalR1T, t.svcMedicalR1B),
            ServiceRow(Icons.location_on_outlined, t.svcMedicalR2T, t.svcMedicalR2B),
            ServiceRow(Icons.badge_outlined, t.svcMedicalR3T, t.svcMedicalR3B),
          ],
        ),
        SosService(
          icon: Icons.shield_outlined,
          name: t.svcSecurityName,
          tileSubtitle: t.svcSecuritySub,
          label: t.svcSecurityName,
          headline: t.svcSecurityHeadline,
          description: t.svcSecurityDesc,
          number: '112',
          numberName: t.svcSecurityNumberName,
          rows: [
            ServiceRow(Icons.phone_in_talk_outlined, t.svcSecurityR1T, t.svcSecurityR1B),
            ServiceRow(Icons.location_on_outlined, t.svcSecurityR2T, t.svcSecurityR2B),
            ServiceRow(Icons.notifications_active_outlined, t.svcSecurityR3T, t.svcSecurityR3B),
          ],
        ),
        SosService(
          icon: Icons.directions_car_outlined,
          name: t.svcRoadName,
          tileSubtitle: t.svcRoadSub,
          label: t.svcRoadName,
          headline: t.svcRoadHeadline,
          description: t.svcRoadDesc,
          number: '1033',
          numberName: t.svcRoadNumberName,
          rows: [
            ServiceRow(Icons.phone_in_talk_outlined, t.svcRoadR1T, t.svcRoadR1B),
            ServiceRow(Icons.car_repair_outlined, t.svcRoadR2T, t.svcRoadR2B),
            ServiceRow(Icons.info_outline, t.svcRoadR3T, t.svcRoadR3B),
          ],
        ),
        SosService(
          icon: Icons.flight_outlined,
          name: t.svcTravelName,
          tileSubtitle: t.svcTravelSub,
          label: t.svcTravelName,
          headline: t.svcTravelHeadline,
          description: t.svcTravelDesc,
          number: '1363',
          numberName: t.svcTravelNumberName,
          rows: [
            ServiceRow(Icons.phone_in_talk_outlined, t.svcTravelR1T, t.svcTravelR1B),
            ServiceRow(Icons.translate_rounded, t.svcTravelR2T, t.svcTravelR2B),
            ServiceRow(Icons.warning_amber_rounded, t.svcTravelR3T, t.svcTravelR3B),
          ],
        ),
      ];
}

class ServiceRequestScreen extends StatelessWidget {
  final SosService service;
  final VoidCallback onSos;
  const ServiceRequestScreen({super.key, required this.service, required this.onSos});

  Future<void> _call(BuildContext context, String number, String label) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    SosStore.instance.logActivity('$label: called $number');
    var ok = false;
    try {
      ok = await launchUrl(Uri(scheme: 'tel', path: number));
    } catch (_) {}
    if (!ok) {
      await Clipboard.setData(ClipboardData(text: number));
      messenger.showSnackBar(
        SnackBar(content: Text(t.callFailed(number))),
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
        final t = AppLocalizations.of(context)!;
        final s = SosStore.instance;
        final lines = <String>[
          if (s.name.isNotEmpty) t.detailName(s.name),
          if (s.phone.isNotEmpty) t.detailPhone(s.phone),
          if (s.bloodGroup.isNotEmpty) t.detailBlood(s.bloodGroup),
          if (s.note.isNotEmpty) t.detailNote(s.note),
        ];
        if (lines.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: SosColors.canvas, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.yourDetails, style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final l in lines) Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(l, style: SosText.body(13))),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                    tooltip: t.backTooltip,
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
                    Text(t.callNumber(s.number, s.numberName), style: SosText.body(14, color: Colors.white, weight: FontWeight.w700)),
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
                    child: Text(t.inDanger112, style: SosText.body(13, color: SosColors.red, weight: FontWeight.w600)),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onSos();
                  },
                  child: Text(t.startSosAlert, style: SosText.body(13, color: SosColors.ink, weight: FontWeight.w600)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}