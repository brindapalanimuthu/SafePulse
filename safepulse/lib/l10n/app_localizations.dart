import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SafePulse'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Emergency response, offline-first.'**
  String get appTagline;

  /// No description provided for @simulateFall.
  ///
  /// In en, this message translates to:
  /// **'Simulate fall detected'**
  String get simulateFall;

  /// No description provided for @fallDetected.
  ///
  /// In en, this message translates to:
  /// **'Fall detected'**
  String get fallDetected;

  /// No description provided for @cancelCountdown.
  ///
  /// In en, this message translates to:
  /// **'I\'m okay — cancel'**
  String get cancelCountdown;

  /// No description provided for @whatsHappening.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening?'**
  String get whatsHappening;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @categoryFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get categoryFire;

  /// No description provided for @categoryGasLeak.
  ///
  /// In en, this message translates to:
  /// **'Gas leak'**
  String get categoryGasLeak;

  /// No description provided for @categoryRoadAccident.
  ///
  /// In en, this message translates to:
  /// **'Road accident'**
  String get categoryRoadAccident;

  /// No description provided for @categoryMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get categoryMedical;

  /// No description provided for @categoryFlood.
  ///
  /// In en, this message translates to:
  /// **'Flood'**
  String get categoryFlood;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceInput;

  /// No description provided for @photoInput.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoInput;

  /// No description provided for @sendForHelp.
  ///
  /// In en, this message translates to:
  /// **'Send for help'**
  String get sendForHelp;

  /// No description provided for @whatToDoNow.
  ///
  /// In en, this message translates to:
  /// **'What to do now'**
  String get whatToDoNow;

  /// No description provided for @enterCalmMode.
  ///
  /// In en, this message translates to:
  /// **'Enter Calm Mode'**
  String get enterCalmMode;

  /// No description provided for @notifyHelp.
  ///
  /// In en, this message translates to:
  /// **'Notify emergency contacts / NDMA'**
  String get notifyHelp;

  /// No description provided for @helpNotified.
  ///
  /// In en, this message translates to:
  /// **'Help has been notified with your location and emergency type.'**
  String get helpNotified;

  /// No description provided for @locationFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get locationFetching;

  /// No description provided for @calmModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm Mode'**
  String get calmModeTitle;

  /// No description provided for @calmModeReady.
  ///
  /// In en, this message translates to:
  /// **'Tap start when you\'re ready'**
  String get calmModeReady;

  /// No description provided for @calmModeBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathe with me...'**
  String get calmModeBreathing;

  /// No description provided for @calmModeStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get calmModeStart;

  /// No description provided for @calmModeStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get calmModeStop;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en', 'hi', 'kn', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
