// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'SafePulse';

  @override
  String get appTagline => 'आपातकालीन सहायता, ऑफ़लाइन-फर्स्ट।';

  @override
  String get simulateFall => 'गिरने का अनुकरण करें';

  @override
  String get fallDetected => 'गिरना पता चला';

  @override
  String get cancelCountdown => 'मैं ठीक हूँ — रद्द करें';

  @override
  String get whatsHappening => 'क्या हो रहा है?';

  @override
  String get selectCategory => 'श्रेणी चुनें';

  @override
  String get categoryFire => 'आग';

  @override
  String get categoryGasLeak => 'गैस रिसाव';

  @override
  String get categoryRoadAccident => 'सड़क दुर्घटना';

  @override
  String get categoryMedical => 'चिकित्सा';

  @override
  String get categoryFlood => 'बाढ़';

  @override
  String get categoryOther => 'अन्य';

  @override
  String get voiceInput => 'आवाज़';

  @override
  String get photoInput => 'फ़ोटो';

  @override
  String get sendForHelp => 'सहायता भेजें';

  @override
  String get whatToDoNow => 'अभी क्या करें';

  @override
  String get enterCalmMode => 'शांत मोड में जाएं';

  @override
  String get notifyHelp => 'आपातकालीन संपर्क / एनडीएमए को सूचित करें';

  @override
  String get helpNotified => 'आपके स्थान और आपातकाल के प्रकार के साथ सहायता को सूचित कर दिया गया है।';

  @override
  String get locationFetching => 'स्थान प्राप्त किया जा रहा है...';

  @override
  String get calmModeTitle => 'शांत मोड';

  @override
  String get calmModeReady => 'तैयार होने पर स्टार्ट दबाएं';

  @override
  String get calmModeBreathing => 'मेरे साथ सांस लें...';

  @override
  String get calmModeStart => 'शुरू करें';

  @override
  String get calmModeStop => 'रोकें';
}
