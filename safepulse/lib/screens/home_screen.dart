import 'package:flutter/material.dart';
import 'countdown_screen.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Map<String, Locale> _languages = {
    'English': Locale('en'),
    'हिन्दी': Locale('hi'),
    'தமிழ்': Locale('ta'),
    'తెలుగు': Locale('te'),
    'ಕನ್ನಡ': Locale('kn'),
    'বাংলা': Locale('bn'),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafePulse'),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) => SafePulseApp.setLocale(context, locale),
            itemBuilder: (context) => _languages.entries
                .map((entry) => PopupMenuItem(
                      value: entry.value,
                      child: Text(entry.key),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'SafePulse',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.appTagline),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CountdownScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(l10n.simulateFall),
            ),
          ],
        ),
      ),
    );
  }
}
