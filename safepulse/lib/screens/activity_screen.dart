import 'package:flutter/material.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static String _fmt(DateTime t) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final mm = t.minute.toString().padLeft(2, '0');
    return '${t.day} ${m[t.month - 1]}, $h:$mm ${t.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SosStore.instance,
      builder: (context, _) {
        final list = SosStore.instance.activity;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('ACTIVITY', style: SosText.display(44)),
                if (list.isNotEmpty)
                  TextButton(
                    onPressed: SosStore.instance.clearActivity,
                    child: Text('Clear', style: SosText.body(13, color: SosColors.red, weight: FontWeight.w600)),
                  ),
              ]),
              const SizedBox(height: 6),
              Text('Your recent alerts and tests.', style: SosText.body(13, color: SosColors.muted)),
              const SizedBox(height: 20),
              if (list.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SosColors.line)),
                  child: Column(children: [
                    const Icon(Icons.receipt_long_outlined, size: 32, color: SosColors.muted),
                    const SizedBox(height: 10),
                    Text('Nothing yet', style: SosText.body(14, weight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Alerts you trigger will show up here.', style: SosText.body(12.5, color: SosColors.muted)),
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
                          Text(_fmt(a.time), style: SosText.body(12, color: SosColors.muted)),
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
