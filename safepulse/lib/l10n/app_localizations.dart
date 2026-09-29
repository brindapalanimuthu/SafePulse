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

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'EXPERT HELP. ANYTIME.'**
  String get splashTagline;

  /// No description provided for @featProtection.
  ///
  /// In en, this message translates to:
  /// **'24/7\nPROTECTION'**
  String get featProtection;

  /// No description provided for @featLocation.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME\nLOCATION'**
  String get featLocation;

  /// No description provided for @featPrivate.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE &\nSECURE'**
  String get featPrivate;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @tapFor.
  ///
  /// In en, this message translates to:
  /// **'TAP FOR'**
  String get tapFor;

  /// No description provided for @emergencyCaps.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get emergencyCaps;

  /// No description provided for @sosSemantic.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get sosSemantic;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @activeSos.
  ///
  /// In en, this message translates to:
  /// **'Active SOS'**
  String get activeSos;

  /// No description provided for @tapForHelp.
  ///
  /// In en, this message translates to:
  /// **'TAP FOR HELP'**
  String get tapForHelp;

  /// No description provided for @quickServices.
  ///
  /// In en, this message translates to:
  /// **'Quick services'**
  String get quickServices;

  /// No description provided for @tileSimulateFall.
  ///
  /// In en, this message translates to:
  /// **'Simulate fall'**
  String get tileSimulateFall;

  /// No description provided for @tileSimulateFallSub.
  ///
  /// In en, this message translates to:
  /// **'Test fall detection'**
  String get tileSimulateFallSub;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get tabContacts;

  /// No description provided for @tabActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get tabActivity;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY'**
  String get activityTitle;

  /// No description provided for @clearLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLabel;

  /// No description provided for @activitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recent alerts and tests.'**
  String get activitySubtitle;

  /// No description provided for @nothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get nothingYet;

  /// No description provided for @nothingYetBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts you trigger will show up here.'**
  String get nothingYetBody;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'CONTACTS'**
  String get contactsTitle;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'People who should know when you need help.'**
  String get contactsSubtitle;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No trusted contacts yet'**
  String get noContacts;

  /// No description provided for @noContactsBody.
  ///
  /// In en, this message translates to:
  /// **'Add someone who can be reached in an emergency.'**
  String get noContactsBody;

  /// No description provided for @swipeToRemove.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to remove a contact.'**
  String get swipeToRemove;

  /// No description provided for @addContactTitle.
  ///
  /// In en, this message translates to:
  /// **'ADD CONTACT'**
  String get addContactTitle;

  /// No description provided for @addContactTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContactTooltip;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @invalidContact.
  ///
  /// In en, this message translates to:
  /// **'Enter a name and a valid phone number'**
  String get invalidContact;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save contact'**
  String get saveContact;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shared with responders when you send an alert.'**
  String get profileSubtitle;

  /// No description provided for @bloodGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood group (optional)'**
  String get bloodGroupLabel;

  /// No description provided for @bloodGroupHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. O+'**
  String get bloodGroupHint;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency note (optional)'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Allergies, medication, anything responders should know'**
  String get noteHint;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @backTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backTooltip;

  /// No description provided for @yourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get yourDetails;

  /// No description provided for @detailName.
  ///
  /// In en, this message translates to:
  /// **'Name: {value}'**
  String detailName(String value);

  /// No description provided for @detailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: {value}'**
  String detailPhone(String value);

  /// No description provided for @detailBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood group: {value}'**
  String detailBlood(String value);

  /// No description provided for @detailNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {value}'**
  String detailNote(String value);

  /// No description provided for @callNumber.
  ///
  /// In en, this message translates to:
  /// **'Call {number}  ·  {name}'**
  String callNumber(String number, String name);

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'This device can\'t place calls. {number} copied.'**
  String callFailed(String number);

  /// No description provided for @inDanger112.
  ///
  /// In en, this message translates to:
  /// **'In danger? Call 112'**
  String get inDanger112;

  /// No description provided for @startSosAlert.
  ///
  /// In en, this message translates to:
  /// **'Start SOS alert'**
  String get startSosAlert;

  /// No description provided for @svcMedicalName.
  ///
  /// In en, this message translates to:
  /// **'Medical Emergency'**
  String get svcMedicalName;

  /// No description provided for @svcMedicalSub.
  ///
  /// In en, this message translates to:
  /// **'Call an ambulance'**
  String get svcMedicalSub;

  /// No description provided for @svcMedicalHeadline.
  ///
  /// In en, this message translates to:
  /// **'HELP IS ONE\nCALL AWAY.'**
  String get svcMedicalHeadline;

  /// No description provided for @svcMedicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Call the ambulance service and tell them where you are.'**
  String get svcMedicalDesc;

  /// No description provided for @svcMedicalNumberName.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get svcMedicalNumberName;

  /// No description provided for @svcMedicalR1T.
  ///
  /// In en, this message translates to:
  /// **'Calls 108'**
  String get svcMedicalR1T;

  /// No description provided for @svcMedicalR1B.
  ///
  /// In en, this message translates to:
  /// **'Connects you to emergency ambulance dispatch.'**
  String get svcMedicalR1B;

  /// No description provided for @svcMedicalR2T.
  ///
  /// In en, this message translates to:
  /// **'Share your location'**
  String get svcMedicalR2T;

  /// No description provided for @svcMedicalR2B.
  ///
  /// In en, this message translates to:
  /// **'Tell the operator where you are and what happened.'**
  String get svcMedicalR2B;

  /// No description provided for @svcMedicalR3T.
  ///
  /// In en, this message translates to:
  /// **'Keep your details ready'**
  String get svcMedicalR3T;

  /// No description provided for @svcMedicalR3B.
  ///
  /// In en, this message translates to:
  /// **'Your blood group and notes from Profile are shown below.'**
  String get svcMedicalR3B;

  /// No description provided for @svcSecurityName.
  ///
  /// In en, this message translates to:
  /// **'Security Assistance'**
  String get svcSecurityName;

  /// No description provided for @svcSecuritySub.
  ///
  /// In en, this message translates to:
  /// **'Reach police and rescue'**
  String get svcSecuritySub;

  /// No description provided for @svcSecurityHeadline.
  ///
  /// In en, this message translates to:
  /// **'YOU ARE\nNOT ALONE.'**
  String get svcSecurityHeadline;

  /// No description provided for @svcSecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'The national emergency number reaches police, fire and ambulance.'**
  String get svcSecurityDesc;

  /// No description provided for @svcSecurityNumberName.
  ///
  /// In en, this message translates to:
  /// **'National emergency number'**
  String get svcSecurityNumberName;

  /// No description provided for @svcSecurityR1T.
  ///
  /// In en, this message translates to:
  /// **'Calls 112'**
  String get svcSecurityR1T;

  /// No description provided for @svcSecurityR1B.
  ///
  /// In en, this message translates to:
  /// **'One number for police, fire and ambulance.'**
  String get svcSecurityR1B;

  /// No description provided for @svcSecurityR2T.
  ///
  /// In en, this message translates to:
  /// **'Give your location'**
  String get svcSecurityR2T;

  /// No description provided for @svcSecurityR2B.
  ///
  /// In en, this message translates to:
  /// **'Say where you are and stay on the line until help is confirmed.'**
  String get svcSecurityR2B;

  /// No description provided for @svcSecurityR3T.
  ///
  /// In en, this message translates to:
  /// **'Alert your circle'**
  String get svcSecurityR3T;

  /// No description provided for @svcSecurityR3B.
  ///
  /// In en, this message translates to:
  /// **'Use Start SOS alert below to run the full alert flow.'**
  String get svcSecurityR3B;

  /// No description provided for @svcRoadName.
  ///
  /// In en, this message translates to:
  /// **'Roadside Help'**
  String get svcRoadName;

  /// No description provided for @svcRoadSub.
  ///
  /// In en, this message translates to:
  /// **'Breakdowns and accidents'**
  String get svcRoadSub;

  /// No description provided for @svcRoadHeadline.
  ///
  /// In en, this message translates to:
  /// **'STUCK ON\nTHE ROAD?'**
  String get svcRoadHeadline;

  /// No description provided for @svcRoadDesc.
  ///
  /// In en, this message translates to:
  /// **'The highway helpline covers breakdowns and accidents on national highway toll stretches. On other roads, call 112.'**
  String get svcRoadDesc;

  /// No description provided for @svcRoadNumberName.
  ///
  /// In en, this message translates to:
  /// **'NHAI highway helpline'**
  String get svcRoadNumberName;

  /// No description provided for @svcRoadR1T.
  ///
  /// In en, this message translates to:
  /// **'Calls 1033'**
  String get svcRoadR1T;

  /// No description provided for @svcRoadR1B.
  ///
  /// In en, this message translates to:
  /// **'Toll-free, 24/7 national highway helpline.'**
  String get svcRoadR1B;

  /// No description provided for @svcRoadR2T.
  ///
  /// In en, this message translates to:
  /// **'Breakdowns and accidents'**
  String get svcRoadR2T;

  /// No description provided for @svcRoadR2B.
  ///
  /// In en, this message translates to:
  /// **'Can arrange an ambulance, patrol vehicle or crane.'**
  String get svcRoadR2B;

  /// No description provided for @svcRoadR3T.
  ///
  /// In en, this message translates to:
  /// **'Highways only'**
  String get svcRoadR3T;

  /// No description provided for @svcRoadR3B.
  ///
  /// In en, this message translates to:
  /// **'Not for other roads. Call 112 there.'**
  String get svcRoadR3B;

  /// No description provided for @svcTravelName.
  ///
  /// In en, this message translates to:
  /// **'Travel Assistance'**
  String get svcTravelName;

  /// No description provided for @svcTravelSub.
  ///
  /// In en, this message translates to:
  /// **'Support while you\'re away'**
  String get svcTravelSub;

  /// No description provided for @svcTravelHeadline.
  ///
  /// In en, this message translates to:
  /// **'HELP WHILE\nYOU TRAVEL.'**
  String get svcTravelHeadline;

  /// No description provided for @svcTravelDesc.
  ///
  /// In en, this message translates to:
  /// **'The Ministry of Tourism helpline gives travel guidance in 12 languages.'**
  String get svcTravelDesc;

  /// No description provided for @svcTravelNumberName.
  ///
  /// In en, this message translates to:
  /// **'Tourist helpline'**
  String get svcTravelNumberName;

  /// No description provided for @svcTravelR1T.
  ///
  /// In en, this message translates to:
  /// **'Calls 1363'**
  String get svcTravelR1T;

  /// No description provided for @svcTravelR1B.
  ///
  /// In en, this message translates to:
  /// **'Free, 24/7 tourist helpline.'**
  String get svcTravelR1B;

  /// No description provided for @svcTravelR2T.
  ///
  /// In en, this message translates to:
  /// **'Your language'**
  String get svcTravelR2T;

  /// No description provided for @svcTravelR2B.
  ///
  /// In en, this message translates to:
  /// **'Operators answer in English and eleven other languages.'**
  String get svcTravelR2B;

  /// No description provided for @svcTravelR3T.
  ///
  /// In en, this message translates to:
  /// **'Not an emergency line'**
  String get svcTravelR3T;

  /// No description provided for @svcTravelR3B.
  ///
  /// In en, this message translates to:
  /// **'For anything urgent, call 112 first.'**
  String get svcTravelR3B;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use this photo'**
  String get usePhoto;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Could not access camera/gallery: {error}'**
  String cameraError(String error);

  /// No description provided for @tapMicStart.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic to start'**
  String get tapMicStart;

  /// No description provided for @speechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition unavailable on this device'**
  String get speechUnavailable;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @tapMicRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic to try again, or confirm below'**
  String get tapMicRetry;

  /// No description provided for @speechPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your speech will appear here...'**
  String get speechPlaceholder;

  /// No description provided for @useThis.
  ///
  /// In en, this message translates to:
  /// **'Use this'**
  String get useThis;
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
