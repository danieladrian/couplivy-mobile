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
  /// **'At least 8 characters'**
  String get authPasswordHintSignUp;

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

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

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
  /// **'Height (cm)'**
  String get bioHeightLabel;

  /// No description provided for @bioHeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 170'**
  String get bioHeightHint;

  /// No description provided for @bioEthnicityLabel.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get bioEthnicityLabel;

  /// No description provided for @bioEthnicityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Javanese'**
  String get bioEthnicityHint;

  /// No description provided for @bioWantsChildrenLabel.
  ///
  /// In en, this message translates to:
  /// **'Do you want children?'**
  String get bioWantsChildrenLabel;

  /// No description provided for @bioWantsChildrenYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get bioWantsChildrenYes;

  /// No description provided for @bioWantsChildrenNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get bioWantsChildrenNo;

  /// No description provided for @bioWantsChildrenNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure yet'**
  String get bioWantsChildrenNotSure;

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

  /// No description provided for @educationAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get educationAny;

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
  /// **'{count} selected · choose at least 3'**
  String interestsSelectedCount(int count);

  /// No description provided for @interestsMinimumError.
  ///
  /// In en, this message translates to:
  /// **'Choose at least 3 interests, or skip this step.'**
  String get interestsMinimumError;

  /// No description provided for @interestTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get interestTravel;

  /// No description provided for @interestCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get interestCoffee;

  /// No description provided for @interestHiking.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get interestHiking;

  /// No description provided for @interestFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get interestFood;

  /// No description provided for @interestMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get interestMusic;

  /// No description provided for @interestMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get interestMovies;

  /// No description provided for @interestSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get interestSports;

  /// No description provided for @interestReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get interestReading;

  /// No description provided for @interestArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get interestArt;

  /// No description provided for @interestNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get interestNature;

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
  /// **'Serious Relationship'**
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

  /// No description provided for @relationshipGoalFriendshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Friendship'**
  String get relationshipGoalFriendshipTitle;

  /// No description provided for @relationshipGoalFriendshipDescription.
  ///
  /// In en, this message translates to:
  /// **'Looking to make new friends first'**
  String get relationshipGoalFriendshipDescription;

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

  /// No description provided for @preferencesGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get preferencesGenderLabel;

  /// No description provided for @preferencesGenderAny.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get preferencesGenderAny;

  /// No description provided for @preferencesFamilyLabel.
  ///
  /// In en, this message translates to:
  /// **'Family preference'**
  String get preferencesFamilyLabel;

  /// No description provided for @preferencesFamilyWantsChildren.
  ///
  /// In en, this message translates to:
  /// **'Wants children'**
  String get preferencesFamilyWantsChildren;

  /// No description provided for @preferencesFamilyNotWantsChildren.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t want children'**
  String get preferencesFamilyNotWantsChildren;

  /// No description provided for @preferencesFamilyOpenToChildren.
  ///
  /// In en, this message translates to:
  /// **'Open to children'**
  String get preferencesFamilyOpenToChildren;

  /// No description provided for @preferencesFamilyAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get preferencesFamilyAny;

  /// No description provided for @preferencesReligionLabel.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get preferencesReligionLabel;

  /// No description provided for @preferencesReligionAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get preferencesReligionAny;

  /// No description provided for @preferencesEducationLabel.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get preferencesEducationLabel;

  /// No description provided for @preferencesSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get preferencesSubmit;

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

  /// No description provided for @previewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Looks Good'**
  String get previewSubmit;

  /// No description provided for @previewSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong saving your profile. Please try again.'**
  String get previewSubmitError;
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
