import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static String _fmt(DateTime time, String locale) => DateFormat('d MMM, h:mm a', locale).format(time);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SosStore.instance,
      builder: (context, _) {
        final l = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context).toString();
        final list = SosStore.instance.activity;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(l.activityTitle, style: SosText.display(44)),
                if (list.isNotEmpty)
                  TextButton(
                    onPressed: SosStore.instance.clearActivity,
                    child: Text(l.clearLabel, style: SosText.body(13, color: SosColors.red, weight: FontWeight.w600)),
                  ),
              ]),
              const SizedBox(height: 6),
              Text(l.activitySubtitle, style: SosText.body(13, color: SosColors.muted)),
              const SizedBox(height: 20),
              if (list.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SosColors.line)),
                  child: Column(children: [
                    const Icon(Icons.receipt_long_outlined, size: 32, color: SosColors.muted),
                    const SizedBox(height: 10),
                    Text(l.nothingYet, style: SosText.body(14, weight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(l.nothingYetBody, style: SosText.body(12.5, color: SosColors.muted)),
                  ]),
                ),
              for (final a in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SosColors.line)),
                    child: Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: SosColors.canvas, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.notifications_active_outlined, size: 20, color: SosColors.red),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a.title, style: SosText.body(14, weight: FontWeight.w600)),
                          Text(_fmt(a.time, locale), style: SosText.body(12, color: SosColors.muted)),
                        ]),
                      ),
                    ]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
