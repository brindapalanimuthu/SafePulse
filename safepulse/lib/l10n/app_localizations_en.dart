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

  @override
  String get splashTagline => 'EXPERT HELP. ANYTIME.';

  @override
  String get featProtection => '24/7\nPROTECTION';

  @override
  String get featLocation => 'REAL-TIME\nLOCATION';

  @override
  String get featPrivate => 'PRIVATE &\nSECURE';

  @override
  String get continueLabel => 'Continue';

  @override
  String get tapFor => 'TAP FOR';

  @override
  String get emergencyCaps => 'EMERGENCY';

  @override
  String get sosSemantic => 'Emergency SOS';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get activeSos => 'Active SOS';

  @override
  String get tapForHelp => 'TAP FOR HELP';

  @override
  String get quickServices => 'Quick services';

  @override
  String get tileSimulateFall => 'Simulate fall';

  @override
  String get tileSimulateFallSub => 'Test fall detection';

  @override
  String get tabHome => 'Home';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabActivity => 'Activity';

  @override
  String get tabProfile => 'Profile';

  @override
  String get activityTitle => 'ACTIVITY';

  @override
  String get clearLabel => 'Clear';

  @override
  String get activitySubtitle => 'Your recent alerts and tests.';

  @override
  String get nothingYet => 'Nothing yet';

  @override
  String get nothingYetBody => 'Alerts you trigger will show up here.';

  @override
  String get contactsTitle => 'CONTACTS';

  @override
  String get contactsSubtitle => 'People who should know when you need help.';

  @override
  String get noContacts => 'No trusted contacts yet';

  @override
  String get noContactsBody => 'Add someone who can be reached in an emergency.';

  @override
  String get swipeToRemove => 'Swipe left to remove a contact.';

  @override
  String get addContactTitle => 'ADD CONTACT';

  @override
  String get addContactTooltip => 'Add contact';

  @override
  String get nameLabel => 'Name';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get invalidContact => 'Enter a name and a valid phone number';

  @override
  String get saveContact => 'Save contact';

  @override
  String get profileTitle => 'PROFILE';

  @override
  String get profileSubtitle => 'Shared with responders when you send an alert.';

  @override
  String get bloodGroupLabel => 'Blood group (optional)';

  @override
  String get bloodGroupHint => 'e.g. O+';

  @override
  String get noteLabel => 'Emergency note (optional)';

  @override
  String get noteHint => 'Allergies, medication, anything responders should know';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get languageLabel => 'Language';

  @override
  String get backTooltip => 'Back';

  @override
  String get yourDetails => 'Your details';

  @override
  String detailName(String value) {
    return 'Name: $value';
  }

  @override
  String detailPhone(String value) {
    return 'Phone: $value';
  }

  @override
  String detailBlood(String value) {
    return 'Blood group: $value';
  }

  @override
  String detailNote(String value) {
    return 'Note: $value';
  }

  @override
  String callNumber(String number, String name) {
    return 'Call $number  ·  $name';
  }

  @override
  String callFailed(String number) {
    return 'This device can\'t place calls. $number copied.';
  }

  @override
  String get inDanger112 => 'In danger? Call 112';

  @override
  String get startSosAlert => 'Start SOS alert';

  @override
  String get svcMedicalName => 'Medical Emergency';

  @override
  String get svcMedicalSub => 'Call an ambulance';

  @override
  String get svcMedicalHeadline => 'HELP IS ONE\nCALL AWAY.';

  @override
  String get svcMedicalDesc => 'Call the ambulance service and tell them where you are.';

  @override
  String get svcMedicalNumberName => 'Ambulance';

  @override
  String get svcMedicalR1T => 'Calls 108';

  @override
  String get svcMedicalR1B => 'Connects you to emergency ambulance dispatch.';

  @override
  String get svcMedicalR2T => 'Share your location';

  @override
  String get svcMedicalR2B => 'Tell the operator where you are and what happened.';

  @override
  String get svcMedicalR3T => 'Keep your details ready';

  @override
  String get svcMedicalR3B => 'Your blood group and notes from Profile are shown below.';

  @override
  String get svcSecurityName => 'Security Assistance';

  @override
  String get svcSecuritySub => 'Reach police and rescue';

  @override
  String get svcSecurityHeadline => 'YOU ARE\nNOT ALONE.';

  @override
  String get svcSecurityDesc => 'The national emergency number reaches police, fire and ambulance.';

  @override
  String get svcSecurityNumberName => 'National emergency number';

  @override
  String get svcSecurityR1T => 'Calls 112';

  @override
  String get svcSecurityR1B => 'One number for police, fire and ambulance.';

  @override
  String get svcSecurityR2T => 'Give your location';

  @override
  String get svcSecurityR2B => 'Say where you are and stay on the line until help is confirmed.';

  @override
  String get svcSecurityR3T => 'Alert your circle';

  @override
  String get svcSecurityR3B => 'Use Start SOS alert below to run the full alert flow.';

  @override
  String get svcRoadName => 'Roadside Help';

  @override
  String get svcRoadSub => 'Breakdowns and accidents';

  @override
  String get svcRoadHeadline => 'STUCK ON\nTHE ROAD?';

  @override
  String get svcRoadDesc => 'The highway helpline covers breakdowns and accidents on national highway toll stretches. On other roads, call 112.';

  @override
  String get svcRoadNumberName => 'NHAI highway helpline';

  @override
  String get svcRoadR1T => 'Calls 1033';

  @override
  String get svcRoadR1B => 'Toll-free, 24/7 national highway helpline.';

  @override
  String get svcRoadR2T => 'Breakdowns and accidents';

  @override
  String get svcRoadR2B => 'Can arrange an ambulance, patrol vehicle or crane.';

  @override
  String get svcRoadR3T => 'Highways only';

  @override
  String get svcRoadR3B => 'Not for other roads. Call 112 there.';

  @override
  String get svcTravelName => 'Travel Assistance';

  @override
  String get svcTravelSub => 'Support while you\'re away';

  @override
  String get svcTravelHeadline => 'HELP WHILE\nYOU TRAVEL.';

  @override
  String get svcTravelDesc => 'The Ministry of Tourism helpline gives travel guidance in 12 languages.';

  @override
  String get svcTravelNumberName => 'Tourist helpline';

  @override
  String get svcTravelR1T => 'Calls 1363';

  @override
  String get svcTravelR1B => 'Free, 24/7 tourist helpline.';

  @override
  String get svcTravelR2T => 'Your language';

  @override
  String get svcTravelR2B => 'Operators answer in English and eleven other languages.';

  @override
  String get svcTravelR3T => 'Not an emergency line';

  @override
  String get svcTravelR3B => 'For anything urgent, call 112 first.';

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get cancel => 'Cancel';

  @override
  String get usePhoto => 'Use this photo';

  @override
  String cameraError(String error) {
    return 'Could not access camera/gallery: $error';
  }

  @override
  String get tapMicStart => 'Tap the mic to start';

  @override
  String get speechUnavailable => 'Speech recognition unavailable on this device';

  @override
  String get listening => 'Listening...';

  @override
  String get tapMicRetry => 'Tap the mic to try again, or confirm below';

  @override
  String get speechPlaceholder => 'Your speech will appear here...';

  @override
  String get useThis => 'Use this';
}
