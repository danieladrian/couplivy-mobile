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

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authNameHint;

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

  /// Gateway Choice screen headline — first onboarding step, right after Sign Up/Login.
  ///
  /// In en, this message translates to:
  /// **'What brings you to Couplivy?'**
  String get gatewayChoiceTitle;

  /// No description provided for @gatewayChoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This shapes the experience you\'ll get — you can change it later from Profile.'**
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

  /// Discover onboarding step 1/10 (Name) headline.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is how you\'ll appear on Couplivy.'**
  String get onboardingNameSubtitle;

  /// No description provided for @onboardingNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get onboardingNameFieldLabel;

  /// No description provided for @onboardingNameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Your nickname'**
  String get onboardingNameFieldHint;

  /// Primary CTA to advance to the next onboarding step — shared across all Discover onboarding steps.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;
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
