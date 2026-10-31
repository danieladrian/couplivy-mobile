import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The application name, used as app title/switcher label. Not shown as separate text on splash — the wordmark is baked into the logo image there.
  ///
  /// In en, this message translates to:
  /// **'Couplivy'**
  String get appName;

  /// Tagline shown under the logo on the splash screen.
  ///
  /// In en, this message translates to:
  /// **'Made for Meaningful Love'**
  String get splashTagline;

  /// Primary CTA button on the welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get welcomeGetStarted;

  /// Secondary CTA button on the welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get welcomeLogIn;

  /// Snackbar shown when user presses back once on the Welcome screen (root screen, no page to pop to) — must tap again within a short window to actually exit the app.
  ///
  /// In en, this message translates to:
  /// **'Tap back again to exit'**
  String get welcomeTapBackAgainToExit;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOr;

  /// No description provided for @authFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameLabel;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get authFullNameHint;

  /// No description provided for @authNickNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get authNickNameLabel;

  /// No description provided for @authNickNameHint.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get authNickNameHint;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@email.com'**
  String get authEmailHint;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhoneLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHintSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get authPasswordHintSignUp;

  /// No description provided for @authPasswordHelperSignUp.
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters, with uppercase, lowercase & a number'**
  String get authPasswordHelperSignUp;

  /// No description provided for @authPasswordHintLogin.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get authPasswordHintLogin;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — set up your Google/Apple Developer credentials first.'**
  String get authComingSoon;

  /// Sign Up screen header title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpTitle;

  /// Primary submit button on Sign Up screen.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpSubmit;

  /// No description provided for @signUpFooterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signUpFooterQuestion;

  /// No description provided for @signUpFooterAction.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get signUpFooterAction;

  /// Login screen header title.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Email / Phone Number'**
  String get loginIdentifierLabel;

  /// Primary submit button on Login screen.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginSubmit;

  /// No description provided for @loginFooterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginFooterQuestion;

  /// No description provided for @loginFooterAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginFooterAction;

  /// Gateway Choice screen headline — first onboarding step, right after Sign Up/Login. Personalized with the user's nickname.
  ///
  /// In en, this message translates to:
  /// **'Hello {nickName},'**
  String gatewayChoiceTitle(String nickName);

  /// Gateway Choice headline shown for the 1 frame before nickname finishes loading from local storage — avoids a layout jump once it's ready.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get gatewayChoiceTitleFallback;

  /// No description provided for @gatewayChoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to Couplivy? This shapes the experience you\'ll get — you can change it later from Profile.'**
  String get gatewayChoiceSubtitle;

  /// No description provided for @gatewayChoiceDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for a new connection'**
  String get gatewayChoiceDiscoverTitle;

  /// No description provided for @gatewayChoiceDiscoverDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ll fill out a full profile — bio, interests, relationship goals — then head to Discover to meet new people.'**
  String get gatewayChoiceDiscoverDescription;

  /// No description provided for @gatewayChoiceDiscoverCta.
  ///
  /// In en, this message translates to:
  /// **'Start my profile'**
  String get gatewayChoiceDiscoverCta;

  /// No description provided for @gatewayChoiceTogetherTitle.
  ///
  /// In en, this message translates to:
  /// **'Already have a partner'**
  String get gatewayChoiceTogetherTitle;

  /// No description provided for @gatewayChoiceTogetherDescription.
  ///
  /// In en, this message translates to:
  /// **'Already dating seriously or married? Link your accounts and go straight to the \"Growing Together\" space — no dating preferences needed.'**
  String get gatewayChoiceTogetherDescription;

  /// CTA shown on the disabled 'Already have a partner' option — backend doesn't support this path yet.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get gatewayChoiceTogetherCta;

  /// Primary CTA to advance to the next onboarding step — shared across all Discover onboarding steps.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Skip button shown on optional onboarding steps.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @dobTitle.
  ///
  /// In en, this message translates to:
  /// **'When were you born?'**
  String get dobTitle;

  /// No description provided for @dobSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your age will be calculated automatically.'**
  String get dobSubtitle;

  /// No description provided for @dobFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dobFieldLabel;

  /// No description provided for @dobAgeResultLabel.
  ///
  /// In en, this message translates to:
  /// **'You are'**
  String get dobAgeResultLabel;

  /// No description provided for @dobAgeResultUnit.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String dobAgeResultUnit(int age);

  /// No description provided for @dobUnderageError.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old to use Couplivy.'**
  String get dobUnderageError;

  /// No description provided for @genderTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your gender?'**
  String get genderTitle;

  /// No description provided for @genderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show you better matches based on this.'**
  String get genderSubtitle;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your photos'**
  String get photosTitle;

  /// No description provided for @photosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few clear photos help you get better matches.'**
  String get photosSubtitle;

  /// No description provided for @photosMainPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Photo'**
  String get photosMainPhotoLabel;

  /// No description provided for @photosMinimumError.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 photo to continue.'**
  String get photosMinimumError;

  /// No description provided for @photosSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photosSourceCamera;

  /// No description provided for @photosSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photosSourceGallery;

  /// No description provided for @bioTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get bioTitle;

  /// No description provided for @bioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few lines about you, plus some details for better matches.'**
  String get bioSubtitle;

  /// No description provided for @bioFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I love good coffee, weekend hikes, and meaningful conversations.'**
  String get bioFieldHint;

  /// No description provided for @bioCharCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String bioCharCount(int current, int max);

  /// No description provided for @bioHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get bioHeightLabel;

  /// No description provided for @bioHeightHintCm.
  ///
  /// In en, this message translates to:
  /// **'e.g. 170'**
  String get bioHeightHintCm;

  /// No description provided for @bioHeightHintFeet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get bioHeightHintFeet;

  /// No description provided for @bioHeightHintInch.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get bioHeightHintInch;

  /// No description provided for @bioEthnicityLabel.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get bioEthnicityLabel;

  /// No description provided for @bioEthnicityHint.
  ///
  /// In en, this message translates to:
  /// **'Select ethnicity'**
  String get bioEthnicityHint;

  /// No description provided for @bioReligionLabel.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get bioReligionLabel;

  /// No description provided for @bioReligionHint.
  ///
  /// In en, this message translates to:
  /// **'Select religion'**
  String get bioReligionHint;

  /// No description provided for @ethnicityEastAsian.
  ///
  /// In en, this message translates to:
  /// **'East Asian'**
  String get ethnicityEastAsian;

  /// No description provided for @ethnicitySouthAsian.
  ///
  /// In en, this message translates to:
  /// **'South Asian'**
  String get ethnicitySouthAsian;

  /// No description provided for @ethnicitySoutheastAsian.
  ///
  /// In en, this message translates to:
  /// **'Southeast Asian'**
  String get ethnicitySoutheastAsian;

  /// No description provided for @ethnicityMiddleEastern.
  ///
  /// In en, this message translates to:
  /// **'Middle Eastern'**
  String get ethnicityMiddleEastern;

  /// No description provided for @ethnicityBlackAfrican.
  ///
  /// In en, this message translates to:
  /// **'Black / African'**
  String get ethnicityBlackAfrican;

  /// No description provided for @ethnicityHispanicLatino.
  ///
  /// In en, this message translates to:
  /// **'Hispanic / Latino'**
  String get ethnicityHispanicLatino;

  /// No description provided for @ethnicityWhiteEuropean.
  ///
  /// In en, this message translates to:
  /// **'White / European'**
  String get ethnicityWhiteEuropean;

  /// No description provided for @ethnicityJavanese.
  ///
  /// In en, this message translates to:
  /// **'Javanese'**
  String get ethnicityJavanese;

  /// No description provided for @ethnicitySundanese.
  ///
  /// In en, this message translates to:
  /// **'Sundanese'**
  String get ethnicitySundanese;

  /// No description provided for @ethnicityBatak.
  ///
  /// In en, this message translates to:
  /// **'Bataknese'**
  String get ethnicityBatak;

  /// No description provided for @ethnicityMinangkabau.
  ///
  /// In en, this message translates to:
  /// **'Minangkabau'**
  String get ethnicityMinangkabau;

  /// No description provided for @ethnicityBalinese.
  ///
  /// In en, this message translates to:
  /// **'Balinese'**
  String get ethnicityBalinese;

  /// No description provided for @ethnicityMadurese.
  ///
  /// In en, this message translates to:
  /// **'Madurese'**
  String get ethnicityMadurese;

  /// No description provided for @ethnicityBetawi.
  ///
  /// In en, this message translates to:
  /// **'Betawi'**
  String get ethnicityBetawi;

  /// No description provided for @ethnicityBugis.
  ///
  /// In en, this message translates to:
  /// **'Bugis'**
  String get ethnicityBugis;

  /// No description provided for @ethnicityDayak.
  ///
  /// In en, this message translates to:
  /// **'Dayak'**
  String get ethnicityDayak;

  /// No description provided for @ethnicityPapuan.
  ///
  /// In en, this message translates to:
  /// **'Papuan'**
  String get ethnicityPapuan;

  /// No description provided for @ethnicityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get ethnicityOther;

  /// No description provided for @ethnicityPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get ethnicityPreferNotToSay;

  /// No description provided for @bioLoveLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'What is your love language? (max 2)'**
  String get bioLoveLanguageLabel;

  /// No description provided for @loveLanguageWordsOfAffirmation.
  ///
  /// In en, this message translates to:
  /// **'Words of Affirmation'**
  String get loveLanguageWordsOfAffirmation;

  /// No description provided for @loveLanguageQualityTime.
  ///
  /// In en, this message translates to:
  /// **'Quality Time'**
  String get loveLanguageQualityTime;

  /// No description provided for @loveLanguageActsOfService.
  ///
  /// In en, this message translates to:
  /// **'Acts of Service'**
  String get loveLanguageActsOfService;

  /// No description provided for @loveLanguagePhysicalTouch.
  ///
  /// In en, this message translates to:
  /// **'Physical Touch'**
  String get loveLanguagePhysicalTouch;

  /// No description provided for @loveLanguageGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get loveLanguageGifts;

  /// No description provided for @loveLanguageDontKnowYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t know yet'**
  String get loveLanguageDontKnowYet;

  /// No description provided for @bioAllFieldsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields to continue.'**
  String get bioAllFieldsRequiredError;

  /// No description provided for @workEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you do?'**
  String get workEducationTitle;

  /// No description provided for @workEducationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your career and education.'**
  String get workEducationSubtitle;

  /// No description provided for @workEducationOccupationLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get workEducationOccupationLabel;

  /// No description provided for @workEducationOccupationHint.
  ///
  /// In en, this message translates to:
  /// **'Your occupation'**
  String get workEducationOccupationHint;

  /// No description provided for @workEducationEducationLabel.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get workEducationEducationLabel;

  /// No description provided for @workEducationEducationHint.
  ///
  /// In en, this message translates to:
  /// **'Select education'**
  String get workEducationEducationHint;

  /// No description provided for @educationNoEducation.
  ///
  /// In en, this message translates to:
  /// **'No Education'**
  String get educationNoEducation;

  /// No description provided for @educationElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary School'**
  String get educationElementary;

  /// No description provided for @educationHighSchool.
  ///
  /// In en, this message translates to:
  /// **'High School'**
  String get educationHighSchool;

  /// No description provided for @educationBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor\'s Degree'**
  String get educationBachelor;

  /// No description provided for @educationMaster.
  ///
  /// In en, this message translates to:
  /// **'Master\'s Degree'**
  String get educationMaster;

  /// No description provided for @educationDoctorate.
  ///
  /// In en, this message translates to:
  /// **'Doctorate'**
  String get educationDoctorate;

  /// No description provided for @workEducationAllFieldsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in occupation and education to continue.'**
  String get workEducationAllFieldsRequiredError;

  /// No description provided for @interestsTitle.
  ///
  /// In en, this message translates to:
  /// **'What are your interests?'**
  String get interestsTitle;

  /// No description provided for @interestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a few things you enjoy.'**
  String get interestsSubtitle;

  /// No description provided for @interestsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/5 selected · choose at least 3'**
  String interestsSelectedCount(int count);

  /// No description provided for @interestsMinimumError.
  ///
  /// In en, this message translates to:
  /// **'Choose at least 3 interests to continue.'**
  String get interestsMinimumError;

  /// No description provided for @interestsMaximumError.
  ///
  /// In en, this message translates to:
  /// **'Choose at most 5 interests.'**
  String get interestsMaximumError;

  /// No description provided for @lifestyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your lifestyle'**
  String get lifestyleTitle;

  /// No description provided for @lifestyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help others get to know your everyday habits.'**
  String get lifestyleSubtitle;

  /// No description provided for @lifestyleDrinkingLabel.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get lifestyleDrinkingLabel;

  /// No description provided for @lifestyleSmokingLabel.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get lifestyleSmokingLabel;

  /// No description provided for @lifestylePetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get lifestylePetsLabel;

  /// No description provided for @drinkingNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get drinkingNever;

  /// No description provided for @drinkingOccasionally.
  ///
  /// In en, this message translates to:
  /// **'Occasionally'**
  String get drinkingOccasionally;

  /// No description provided for @drinkingSocially.
  ///
  /// In en, this message translates to:
  /// **'Socially'**
  String get drinkingSocially;

  /// No description provided for @drinkingRegularly.
  ///
  /// In en, this message translates to:
  /// **'Regularly'**
  String get drinkingRegularly;

  /// No description provided for @drinkingPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get drinkingPreferNotToSay;

  /// No description provided for @smokingNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get smokingNever;

  /// No description provided for @smokingOccasionally.
  ///
  /// In en, this message translates to:
  /// **'Occasionally'**
  String get smokingOccasionally;

  /// No description provided for @smokingRegularly.
  ///
  /// In en, this message translates to:
  /// **'Regularly'**
  String get smokingRegularly;

  /// No description provided for @smokingPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get smokingPreferNotToSay;

  /// No description provided for @petPreferenceLovePets.
  ///
  /// In en, this message translates to:
  /// **'Love pets'**
  String get petPreferenceLovePets;

  /// No description provided for @petPreferenceNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get petPreferenceNeutral;

  /// No description provided for @petPreferenceNotAFan.
  ///
  /// In en, this message translates to:
  /// **'Not a fan'**
  String get petPreferenceNotAFan;

  /// No description provided for @lifestyleAllFieldsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields to continue.'**
  String get lifestyleAllFieldsRequiredError;

  /// No description provided for @futureTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking ahead'**
  String get futureTitle;

  /// No description provided for @futureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where you stand on children and marriage.'**
  String get futureSubtitle;

  /// No description provided for @futureChildrenLabel.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get futureChildrenLabel;

  /// No description provided for @futureMarriageLabel.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get futureMarriageLabel;

  /// No description provided for @childrenPreferenceWantChildren.
  ///
  /// In en, this message translates to:
  /// **'Want children'**
  String get childrenPreferenceWantChildren;

  /// No description provided for @childrenPreferenceNotWantChildren.
  ///
  /// In en, this message translates to:
  /// **'Don\'t want children'**
  String get childrenPreferenceNotWantChildren;

  /// No description provided for @childrenPreferenceHaveChildren.
  ///
  /// In en, this message translates to:
  /// **'Have children'**
  String get childrenPreferenceHaveChildren;

  /// No description provided for @childrenPreferenceOpenToChildren.
  ///
  /// In en, this message translates to:
  /// **'Open to children'**
  String get childrenPreferenceOpenToChildren;

  /// No description provided for @childrenPreferenceNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get childrenPreferenceNotSure;

  /// No description provided for @childrenPreferencePreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get childrenPreferencePreferNotToSay;

  /// No description provided for @marriagePreferenceWantMarriage.
  ///
  /// In en, this message translates to:
  /// **'Want marriage'**
  String get marriagePreferenceWantMarriage;

  /// No description provided for @marriagePreferenceOpenToMarriage.
  ///
  /// In en, this message translates to:
  /// **'Open to marriage'**
  String get marriagePreferenceOpenToMarriage;

  /// No description provided for @marriagePreferenceNotWantMarriage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t want marriage'**
  String get marriagePreferenceNotWantMarriage;

  /// No description provided for @marriagePreferenceNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get marriagePreferenceNotSure;

  /// No description provided for @futureAllFieldsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields to continue.'**
  String get futureAllFieldsRequiredError;

  /// No description provided for @interestCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get interestCategoryFood;

  /// No description provided for @interestCategoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get interestCategoryTravel;

  /// No description provided for @interestCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get interestCategorySports;

  /// No description provided for @interestCategoryArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get interestCategoryArts;

  /// No description provided for @interestCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get interestCategoryEntertainment;

  /// No description provided for @interestCoffeeTea.
  ///
  /// In en, this message translates to:
  /// **'Coffee / Tea'**
  String get interestCoffeeTea;

  /// No description provided for @interestStreetFood.
  ///
  /// In en, this message translates to:
  /// **'Street Food'**
  String get interestStreetFood;

  /// No description provided for @interestGeneralFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get interestGeneralFood;

  /// No description provided for @interestBeachTrips.
  ///
  /// In en, this message translates to:
  /// **'Beach Trips'**
  String get interestBeachTrips;

  /// No description provided for @interestMountainTrips.
  ///
  /// In en, this message translates to:
  /// **'Mountain Trips'**
  String get interestMountainTrips;

  /// No description provided for @interestCulturalTrips.
  ///
  /// In en, this message translates to:
  /// **'Cultural Trips'**
  String get interestCulturalTrips;

  /// No description provided for @interestCityTrips.
  ///
  /// In en, this message translates to:
  /// **'City Trips'**
  String get interestCityTrips;

  /// No description provided for @interestGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get interestGym;

  /// No description provided for @interestBallSport.
  ///
  /// In en, this message translates to:
  /// **'Ball Sport'**
  String get interestBallSport;

  /// No description provided for @interestRacketSport.
  ///
  /// In en, this message translates to:
  /// **'Racket Sport'**
  String get interestRacketSport;

  /// No description provided for @interestRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get interestRunning;

  /// No description provided for @interestMindBodyExercise.
  ///
  /// In en, this message translates to:
  /// **'Mind & Body Exercise'**
  String get interestMindBodyExercise;

  /// No description provided for @interestCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get interestCardio;

  /// No description provided for @interestArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get interestArt;

  /// No description provided for @interestMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get interestMusic;

  /// No description provided for @interestSinging.
  ///
  /// In en, this message translates to:
  /// **'Singing'**
  String get interestSinging;

  /// No description provided for @interestDancing.
  ///
  /// In en, this message translates to:
  /// **'Dancing'**
  String get interestDancing;

  /// No description provided for @interestPlayingMusic.
  ///
  /// In en, this message translates to:
  /// **'Playing Music'**
  String get interestPlayingMusic;

  /// No description provided for @interestTvSeries.
  ///
  /// In en, this message translates to:
  /// **'TV Series'**
  String get interestTvSeries;

  /// No description provided for @interestMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get interestMovies;

  /// No description provided for @interestAnime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get interestAnime;

  /// No description provided for @interestKDrama.
  ///
  /// In en, this message translates to:
  /// **'K-Drama'**
  String get interestKDrama;

  /// No description provided for @interestGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get interestGaming;

  /// No description provided for @interestStandUpComedy.
  ///
  /// In en, this message translates to:
  /// **'Stand-up Comedy'**
  String get interestStandUpComedy;

  /// No description provided for @interestPodcast.
  ///
  /// In en, this message translates to:
  /// **'Podcast'**
  String get interestPodcast;

  /// No description provided for @interestBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get interestBooks;

  /// No description provided for @relationshipGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get relationshipGoalTitle;

  /// No description provided for @relationshipGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us show you people with the same intentions.'**
  String get relationshipGoalSubtitle;

  /// No description provided for @relationshipGoalSeriousTitle.
  ///
  /// In en, this message translates to:
  /// **'Serious Dating'**
  String get relationshipGoalSeriousTitle;

  /// No description provided for @relationshipGoalSeriousDescription.
  ///
  /// In en, this message translates to:
  /// **'Looking for a long-term relationship'**
  String get relationshipGoalSeriousDescription;

  /// No description provided for @relationshipGoalCasualTitle.
  ///
  /// In en, this message translates to:
  /// **'Casual Dating'**
  String get relationshipGoalCasualTitle;

  /// No description provided for @relationshipGoalCasualDescription.
  ///
  /// In en, this message translates to:
  /// **'Getting to know people, see where it goes'**
  String get relationshipGoalCasualDescription;

  /// No description provided for @relationshipGoalNewConnectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Connections'**
  String get relationshipGoalNewConnectionsTitle;

  /// No description provided for @relationshipGoalNewConnectionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Open to meeting new people, no pressure'**
  String get relationshipGoalNewConnectionsDescription;

  /// No description provided for @relationshipGoalStillFiguringOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Still Figuring It Out'**
  String get relationshipGoalStillFiguringOutTitle;

  /// No description provided for @relationshipGoalStillFiguringOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Not sure yet, just exploring for now'**
  String get relationshipGoalStillFiguringOutDescription;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you\'re looking for'**
  String get preferencesTitle;

  /// No description provided for @preferencesAgeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'{min} – {max} years old'**
  String preferencesAgeRangeLabel(int min, int max);

  /// No description provided for @preferencesOpenForAll.
  ///
  /// In en, this message translates to:
  /// **'Open for all'**
  String get preferencesOpenForAll;

  /// No description provided for @preferencesGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get preferencesGenderLabel;

  /// No description provided for @preferencesChildrenLabel.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get preferencesChildrenLabel;

  /// No description provided for @preferencesMarriageLabel.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get preferencesMarriageLabel;

  /// No description provided for @preferencesEthnicityLabel.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get preferencesEthnicityLabel;

  /// No description provided for @preferencesReligionLabel.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get preferencesReligionLabel;

  /// No description provided for @preferencesEducationLabel.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get preferencesEducationLabel;

  /// No description provided for @preferencesDrinkingLabel.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get preferencesDrinkingLabel;

  /// No description provided for @preferencesSmokingLabel.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get preferencesSmokingLabel;

  /// No description provided for @preferencesPetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get preferencesPetsLabel;

  /// No description provided for @religionIslam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get religionIslam;

  /// No description provided for @religionChristianity.
  ///
  /// In en, this message translates to:
  /// **'Christianity'**
  String get religionChristianity;

  /// No description provided for @religionCatholic.
  ///
  /// In en, this message translates to:
  /// **'Catholic'**
  String get religionCatholic;

  /// No description provided for @religionHinduism.
  ///
  /// In en, this message translates to:
  /// **'Hinduism'**
  String get religionHinduism;

  /// No description provided for @religionBuddhism.
  ///
  /// In en, this message translates to:
  /// **'Buddhism'**
  String get religionBuddhism;

  /// No description provided for @religionConfucianism.
  ///
  /// In en, this message translates to:
  /// **'Confucianism'**
  String get religionConfucianism;

  /// No description provided for @religionJudaism.
  ///
  /// In en, this message translates to:
  /// **'Judaism'**
  String get religionJudaism;

  /// No description provided for @religionSikhism.
  ///
  /// In en, this message translates to:
  /// **'Sikhism'**
  String get religionSikhism;

  /// No description provided for @religionTaoism.
  ///
  /// In en, this message translates to:
  /// **'Taoism'**
  String get religionTaoism;

  /// No description provided for @religionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get religionOther;

  /// No description provided for @religionAgnostic.
  ///
  /// In en, this message translates to:
  /// **'Agnostic'**
  String get religionAgnostic;

  /// No description provided for @religionAtheist.
  ///
  /// In en, this message translates to:
  /// **'Atheist'**
  String get religionAtheist;

  /// No description provided for @religionPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get religionPreferNotToSay;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get previewTitle;

  /// No description provided for @previewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your profile before continuing.'**
  String get previewSubtitle;

  /// No description provided for @previewNameAge.
  ///
  /// In en, this message translates to:
  /// **'{nickName}, {age}'**
  String previewNameAge(String nickName, int age);

  /// No description provided for @previewLookingForTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking for'**
  String get previewLookingForTitle;

  /// No description provided for @previewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get previewSubmit;

  /// No description provided for @previewSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong saving your profile. Please try again.'**
  String get previewSubmitError;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get navConnections;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @discoverEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No more profiles right now — check back later or refresh.'**
  String get discoverEmptyMessage;

  /// No description provided for @discoverRefreshLabel.
  ///
  /// In en, this message translates to:
  /// **'Refresh Recommendations'**
  String get discoverRefreshLabel;

  /// No description provided for @discoverDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'{occupation} · {distanceKm} km'**
  String discoverDistanceLabel(String occupation, int distanceKm);

  /// No description provided for @discoverCompatibleLabel.
  ///
  /// In en, this message translates to:
  /// **'COMPATIBLE'**
  String get discoverCompatibleLabel;

  /// No description provided for @connectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connectionsTitle;

  /// No description provided for @connectionsMatchesTab.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get connectionsMatchesTab;

  /// No description provided for @connectionsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No matches yet — keep exploring Discover!'**
  String get connectionsEmptyMessage;

  /// No description provided for @connectionsSharedInterestsLabel.
  ///
  /// In en, this message translates to:
  /// **'You both like {interests}'**
  String connectionsSharedInterestsLabel(String interests);

  /// No description provided for @chatTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatTypeMessageHint;

  /// No description provided for @chatOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chatOnlineStatus;

  /// No description provided for @profileCompletenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile completeness'**
  String get profileCompletenessLabel;

  /// No description provided for @profileUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Couplivy Plus'**
  String get profileUpgradeTitle;

  /// No description provided for @profileUpgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock more ways to connect'**
  String get profileUpgradeSubtitle;

  /// No description provided for @profileMenuMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileMenuMyProfile;

  /// No description provided for @profileMenuMyPreferences.
  ///
  /// In en, this message translates to:
  /// **'My Preferences'**
  String get profileMenuMyPreferences;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Visibility'**
  String get profileMenuPrivacy;

  /// No description provided for @profileMenuSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety & Reporting'**
  String get profileMenuSafety;

  /// No description provided for @profileMenuAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get profileMenuAppSettings;

  /// No description provided for @profileMenuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get profileMenuTerms;

  /// No description provided for @profileMenuLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileMenuLogOut;

  /// No description provided for @profileLogOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get profileLogOutConfirmTitle;

  /// No description provided for @profileLogOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to access your account.'**
  String get profileLogOutConfirmMessage;

  /// No description provided for @profileLogOutConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogOutConfirmCancel;

  /// No description provided for @profileLogOutConfirmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOutConfirmConfirm;

  /// No description provided for @profileComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileComingSoonTitle;

  /// No description provided for @profileComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This section isn\'t ready yet — check back later.'**
  String get profileComingSoonMessage;

  /// No description provided for @myProfileLoveLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Love language'**
  String get myProfileLoveLanguageLabel;

  /// No description provided for @myProfileRelationshipGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship goal'**
  String get myProfileRelationshipGoalLabel;

  /// No description provided for @myPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Preferences'**
  String get myPreferencesTitle;

  /// No description provided for @myPreferencesAgeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get myPreferencesAgeRangeLabel;

  /// No description provided for @myPreferencesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t set your preferences yet.'**
  String get myPreferencesEmptyMessage;

  /// No description provided for @myProfileAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get myProfileAboutTitle;

  /// No description provided for @myProfileInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get myProfileInterestsTitle;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @editProfileSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editProfileSaveLabel;

  /// No description provided for @appSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettingsTitle;

  /// No description provided for @appSettingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appSettingsLanguageLabel;

  /// No description provided for @appSettingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get appSettingsLanguageEnglish;

  /// No description provided for @appSettingsLanguageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get appSettingsLanguageIndonesian;

  /// No description provided for @appSettingsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appSettingsVersionLabel;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsTitle;

  /// No description provided for @termsOfServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceLabel;

  /// No description provided for @termsPrivacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get termsPrivacyPolicyLabel;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Visibility'**
  String get privacyTitle;

  /// No description provided for @privacyHideProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide my profile'**
  String get privacyHideProfileLabel;

  /// No description provided for @privacyHideProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Your profile won\'t appear in Discover to anyone.'**
  String get privacyHideProfileDescription;

  /// No description provided for @privacyShowReligionLabel.
  ///
  /// In en, this message translates to:
  /// **'Show religion'**
  String get privacyShowReligionLabel;

  /// No description provided for @privacyShowReligionDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others see your religion on your profile.'**
  String get privacyShowReligionDescription;

  /// No description provided for @privacyShowEthnicityLabel.
  ///
  /// In en, this message translates to:
  /// **'Show ethnicity'**
  String get privacyShowEthnicityLabel;

  /// No description provided for @privacyShowEthnicityDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others see your ethnicity on your profile.'**
  String get privacyShowEthnicityDescription;

  /// No description provided for @privacyShowHeightWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Show height'**
  String get privacyShowHeightWeightLabel;

  /// No description provided for @privacyShowHeightWeightDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others see your height on your profile.'**
  String get privacyShowHeightWeightDescription;

  /// No description provided for @privacyAllowDirectAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow direct add'**
  String get privacyAllowDirectAddLabel;

  /// No description provided for @privacyAllowDirectAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others add you directly without matching first.'**
  String get privacyAllowDirectAddDescription;

  /// No description provided for @privacyShowOnlineStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Show online status'**
  String get privacyShowOnlineStatusLabel;

  /// No description provided for @privacyShowOnlineStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Let others see when you\'re active.'**
  String get privacyShowOnlineStatusDescription;

  /// No description provided for @privacyAiConversationAssistantLabel.
  ///
  /// In en, this message translates to:
  /// **'AI conversation assistant'**
  String get privacyAiConversationAssistantLabel;

  /// No description provided for @privacyAiConversationAssistantDescription.
  ///
  /// In en, this message translates to:
  /// **'Get AI-suggested icebreakers and replies in chats.'**
  String get privacyAiConversationAssistantDescription;

  /// No description provided for @privacySaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your changes. Please try again.'**
  String get privacySaveError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
