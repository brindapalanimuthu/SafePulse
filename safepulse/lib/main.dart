import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart'; // your existing theme (unchanged)
import 'screens/sos_splash_screen.dart';
import 'screens/app_shell.dart';
import 'screens/countdown_screen.dart';
import 'services/sos_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SosStore.instance.load();
  runApp(const SafePulseApp());
}

class SafePulseApp extends StatefulWidget {
  const SafePulseApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_SafePulseAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<SafePulseApp> createState() => _SafePulseAppState();
}

class _SafePulseAppState extends State<SafePulseApp> {
  Locale? _locale;
  final _navKey = GlobalKey<NavigatorState>();

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  // Starts your existing flow: CountdownScreen -> EmergencyClassificationScreen
  void _triggerSos() {
    SosStore.instance.logActivity('SOS triggered');
    _navKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const CountdownScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'SafePulse',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ta'),
        Locale('te'),
        Locale('kn'),
        Locale('bn'),
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (ctx) => SosSplashScreen(
          onSos: _triggerSos,
          onContinue: () => Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(
              builder: (_) => AppShell(userName: 'Brinda', onSos: _triggerSos),
            ),
          ),
        ),
      ),
    );
  }
}