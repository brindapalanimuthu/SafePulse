import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';
import 'activity_screen.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';
import 'sos_home_screen.dart';

/// Home + floating bottom bar.
class AppShell extends StatefulWidget {
  final String userName; // fallback until the user saves a name in Profile
  final VoidCallback onSos;
  const AppShell({super.key, required this.userName, required this.onSos});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _i = 0;

  static const _icons = [
    Icons.home_rounded,
    Icons.people_outline_rounded,
    Icons.receipt_long_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final labels = [t.tabHome, t.tabContacts, t.tabActivity, t.tabProfile];
    return Scaffold(
      backgroundColor: SosColors.canvas,
      body: Stack(children: [
        ListenableBuilder(
          listenable: SosStore.instance,
          builder: (context, _) {
            final saved = SosStore.instance.name;
            return IndexedStack(index: _i, children: [
              SosHomeScreen(userName: saved.isEmpty ? widget.userName : saved, onSos: widget.onSos),
              const ContactsScreen(),
              const ActivityScreen(),
              const ProfileScreen(),
            ]);
          },
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var k = 0; k < _icons.length; k++)
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(() => _i = k),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_icons[k], color: _i == k ? SosColors.red : SosColors.muted),
                          const SizedBox(height: 2),
                          Text(labels[k],
                              style: SosText.body(10, color: _i == k ? SosColors.red : SosColors.muted, weight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
