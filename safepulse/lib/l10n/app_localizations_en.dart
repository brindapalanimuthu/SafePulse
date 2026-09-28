// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SafePulse';

  @override
  String get appTagline => 'Emergency response, offline-first.';

  @override
  String get simulateFall => 'Simulate fall detected';

  @override
  String get fallDetected => 'Fall detected';

  @override
  String get cancelCountdown => 'I\'m okay — cancel';

  @override
  String get whatsHappening => 'What\'s happening?';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get categoryFire => 'Fire';

  @override
  String get categoryGasLeak => 'Gas leak';

  @override
  String get categoryRoadAccident => 'Road accident';

  @override
  String get categoryMedical => 'Medical';

  @override
  String get categoryFlood => 'Flood';

  @override
  String get categoryOther => 'Other';

  @override
  String get voiceInput => 'Voice';

  @override
  String get photoInput => 'Photo';

  @override
  String get sendForHelp => 'Send for help';

  @override
  String get whatToDoNow => 'What to do now';

  @override
  String get enterCalmMode => 'Enter Calm Mode';

  @override
  String get notifyHelp => 'Notify emergency contacts / NDMA';

  @override
  String get helpNotified => 'Help has been notified with your location and emergency type.';

  @override
  String get locationFetching => 'Fetching location...';

  @override
  String get calmModeTitle => 'Calm Mode';

  @override
  String get calmModeReady => 'Tap start when you\'re ready';

  @override
  String get calmModeBreathing => 'Breathe with me...';

  @override
  String get calmModeStart => 'Start';

  @override
  String get calmModeStop => 'Stop';
}
