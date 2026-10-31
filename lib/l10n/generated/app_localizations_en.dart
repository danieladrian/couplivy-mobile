// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Couplivy';

  @override
  String get splashTagline => 'Made for Meaningful Love';

  @override
  String get welcomeGetStarted => 'Sign Up';

  @override
  String get welcomeLogIn => 'Log In';

  @override
  String get welcomeTapBackAgainToExit => 'Tap back again to exit';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authOr => 'or';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authFullNameHint => 'Your full name';

  @override
  String get authNickNameLabel => 'Nickname';

  @override
  String get authNickNameHint => 'What should we call you?';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'name@email.com';

  @override
  String get authPhoneLabel => 'Phone Number';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHintSignUp => 'Create a password';

  @override
  String get authPasswordHelperSignUp =>
      'Min 8 characters, with uppercase, lowercase & a number';

  @override
  String get authPasswordHintLogin => 'Your password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authComingSoon =>
      'Coming soon — set up your Google/Apple Developer credentials first.';

  @override
  String get signUpTitle => 'Create Account';

  @override
  String get signUpSubmit => 'Create Account';

  @override
  String get signUpFooterQuestion => 'Already have an account?';

  @override
  String get signUpFooterAction => 'Log In';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginIdentifierLabel => 'Email / Phone Number';

  @override
  String get loginSubmit => 'Log In';

  @override
  String get loginFooterQuestion => 'Don\'t have an account?';

  @override
  String get loginFooterAction => 'Sign Up';

  @override
  String gatewayChoiceTitle(String nickName) {
    return 'Hello $nickName,';
  }

  @override
  String get gatewayChoiceTitleFallback => 'Hello,';

  @override
  String get gatewayChoiceSubtitle =>
      'What brings you to Couplivy? This shapes the experience you\'ll get — you can change it later from Profile.';

  @override
  String get gatewayChoiceDiscoverTitle => 'Looking for a new connection';

  @override
  String get gatewayChoiceDiscoverDescription =>
      'You\'ll fill out a full profile — bio, interests, relationship goals — then head to Discover to meet new people.';

  @override
  String get gatewayChoiceDiscoverCta => 'Start my profile';

  @override
  String get gatewayChoiceTogetherTitle => 'Already have a partner';

  @override
  String get gatewayChoiceTogetherDescription =>
      'Already dating seriously or married? Link your accounts and go straight to the \"Growing Together\" space — no dating preferences needed.';

  @override
  String get gatewayChoiceTogetherCta => 'Coming soon';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get dobTitle => 'When were you born?';

  @override
  String get dobSubtitle => 'Your age will be calculated automatically.';

  @override
  String get dobFieldLabel => 'Date of birth';

  @override
  String get dobAgeResultLabel => 'You are';

  @override
  String dobAgeResultUnit(int age) {
    return '$age years old';
  }

  @override
  String get dobUnderageError =>
      'You must be at least 18 years old to use Couplivy.';

  @override
  String get genderTitle => 'What\'s your gender?';

  @override
  String get genderSubtitle => 'We\'ll show you better matches based on this.';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get photosTitle => 'Add your photos';

  @override
  String get photosSubtitle =>
      'A few clear photos help you get better matches.';

  @override
  String get photosMainPhotoLabel => 'Main Photo';

  @override
  String get photosMinimumError => 'Add at least 1 photo to continue.';

  @override
  String get photosSourceCamera => 'Take a photo';

  @override
  String get photosSourceGallery => 'Choose from gallery';

  @override
  String get bioTitle => 'Tell us about yourself';

  @override
  String get bioSubtitle =>
      'A few lines about you, plus some details for better matches.';

  @override
  String get bioFieldHint =>
      'e.g. I love good coffee, weekend hikes, and meaningful conversations.';

  @override
  String bioCharCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String get bioHeightLabel => 'Height';

  @override
  String get bioHeightHintCm => 'e.g. 170';

  @override
  String get bioHeightHintFeet => 'Feet';

  @override
  String get bioHeightHintInch => 'Inches';

  @override
  String get bioEthnicityLabel => 'Ethnicity';

  @override
  String get bioEthnicityHint => 'Select ethnicity';

  @override
  String get bioReligionLabel => 'Religion';

  @override
  String get bioReligionHint => 'Select religion';

  @override
  String get ethnicityEastAsian => 'East Asian';

  @override
  String get ethnicitySouthAsian => 'South Asian';

  @override
  String get ethnicitySoutheastAsian => 'Southeast Asian';

  @override
  String get ethnicityMiddleEastern => 'Middle Eastern';

  @override
  String get ethnicityBlackAfrican => 'Black / African';

  @override
  String get ethnicityHispanicLatino => 'Hispanic / Latino';

  @override
  String get ethnicityWhiteEuropean => 'White / European';

  @override
  String get ethnicityJavanese => 'Javanese';

  @override
  String get ethnicitySundanese => 'Sundanese';

  @override
  String get ethnicityBatak => 'Bataknese';

  @override
  String get ethnicityMinangkabau => 'Minangkabau';

  @override
  String get ethnicityBalinese => 'Balinese';

  @override
  String get ethnicityMadurese => 'Madurese';

  @override
  String get ethnicityBetawi => 'Betawi';

  @override
  String get ethnicityBugis => 'Bugis';

  @override
  String get ethnicityDayak => 'Dayak';

  @override
  String get ethnicityPapuan => 'Papuan';

  @override
  String get ethnicityOther => 'Other';

  @override
  String get ethnicityPreferNotToSay => 'Prefer not to say';

  @override
  String get bioLoveLanguageLabel => 'What is your love language? (max 2)';

  @override
  String get loveLanguageWordsOfAffirmation => 'Words of Affirmation';

  @override
  String get loveLanguageQualityTime => 'Quality Time';

  @override
  String get loveLanguageActsOfService => 'Acts of Service';

  @override
  String get loveLanguagePhysicalTouch => 'Physical Touch';

  @override
  String get loveLanguageGifts => 'Gifts';

  @override
  String get loveLanguageDontKnowYet => 'Don\'t know yet';

  @override
  String get bioAllFieldsRequiredError =>
      'Please fill in all fields to continue.';

  @override
  String get workEducationTitle => 'What do you do?';

  @override
  String get workEducationSubtitle => 'Your career and education.';

  @override
  String get workEducationOccupationLabel => 'Occupation';

  @override
  String get workEducationOccupationHint => 'Your occupation';

  @override
  String get workEducationEducationLabel => 'Education';

  @override
  String get workEducationEducationHint => 'Select education';

  @override
  String get educationNoEducation => 'No Education';

  @override
  String get educationElementary => 'Elementary School';

  @override
  String get educationHighSchool => 'High School';

  @override
  String get educationBachelor => 'Bachelor\'s Degree';

  @override
  String get educationMaster => 'Master\'s Degree';

  @override
  String get educationDoctorate => 'Doctorate';

  @override
  String get workEducationAllFieldsRequiredError =>
      'Please fill in occupation and education to continue.';

  @override
  String get interestsTitle => 'What are your interests?';

  @override
  String get interestsSubtitle => 'Choose a few things you enjoy.';

  @override
  String interestsSelectedCount(int count) {
    return '$count/5 selected · choose at least 3';
  }

  @override
  String get interestsMinimumError =>
      'Choose at least 3 interests to continue.';

  @override
  String get interestsMaximumError => 'Choose at most 5 interests.';

  @override
  String get lifestyleTitle => 'Your lifestyle';

  @override
  String get lifestyleSubtitle =>
      'Help others get to know your everyday habits.';

  @override
  String get lifestyleDrinkingLabel => 'Drinking';

  @override
  String get lifestyleSmokingLabel => 'Smoking';

  @override
  String get lifestylePetsLabel => 'Pets';

  @override
  String get drinkingNever => 'Never';

  @override
  String get drinkingOccasionally => 'Occasionally';

  @override
  String get drinkingSocially => 'Socially';

  @override
  String get drinkingRegularly => 'Regularly';

  @override
  String get drinkingPreferNotToSay => 'Prefer not to say';

  @override
  String get smokingNever => 'Never';

  @override
  String get smokingOccasionally => 'Occasionally';

  @override
  String get smokingRegularly => 'Regularly';

  @override
  String get smokingPreferNotToSay => 'Prefer not to say';

  @override
  String get petPreferenceLovePets => 'Love pets';

  @override
  String get petPreferenceNeutral => 'Neutral';

  @override
  String get petPreferenceNotAFan => 'Not a fan';

  @override
  String get lifestyleAllFieldsRequiredError =>
      'Please fill in all fields to continue.';

  @override
  String get futureTitle => 'Looking ahead';

  @override
  String get futureSubtitle => 'Where you stand on children and marriage.';

  @override
  String get futureChildrenLabel => 'Children';

  @override
  String get futureMarriageLabel => 'Marriage';

  @override
  String get childrenPreferenceWantChildren => 'Want children';

  @override
  String get childrenPreferenceNotWantChildren => 'Don\'t want children';

  @override
  String get childrenPreferenceHaveChildren => 'Have children';

  @override
  String get childrenPreferenceOpenToChildren => 'Open to children';

  @override
  String get childrenPreferenceNotSure => 'Not sure';

  @override
  String get childrenPreferencePreferNotToSay => 'Prefer not to say';

  @override
  String get marriagePreferenceWantMarriage => 'Want marriage';

  @override
  String get marriagePreferenceOpenToMarriage => 'Open to marriage';

  @override
  String get marriagePreferenceNotWantMarriage => 'Don\'t want marriage';

  @override
  String get marriagePreferenceNotSure => 'Not sure';

  @override
  String get futureAllFieldsRequiredError =>
      'Please fill in all fields to continue.';

  @override
  String get interestCategoryFood => 'Food';

  @override
  String get interestCategoryTravel => 'Travel';

  @override
  String get interestCategorySports => 'Sports';

  @override
  String get interestCategoryArts => 'Arts';

  @override
  String get interestCategoryEntertainment => 'Entertainment';

  @override
  String get interestCoffeeTea => 'Coffee / Tea';

  @override
  String get interestStreetFood => 'Street Food';

  @override
  String get interestGeneralFood => 'Food';

  @override
  String get interestBeachTrips => 'Beach Trips';

  @override
  String get interestMountainTrips => 'Mountain Trips';

  @override
  String get interestCulturalTrips => 'Cultural Trips';

  @override
  String get interestCityTrips => 'City Trips';

  @override
  String get interestGym => 'Gym';

  @override
  String get interestBallSport => 'Ball Sport';

  @override
  String get interestRacketSport => 'Racket Sport';

  @override
  String get interestRunning => 'Running';

  @override
  String get interestMindBodyExercise => 'Mind & Body Exercise';

  @override
  String get interestCardio => 'Cardio';

  @override
  String get interestArt => 'Art';

  @override
  String get interestMusic => 'Music';

  @override
  String get interestSinging => 'Singing';

  @override
  String get interestDancing => 'Dancing';

  @override
  String get interestPlayingMusic => 'Playing Music';

  @override
  String get interestTvSeries => 'TV Series';

  @override
  String get interestMovies => 'Movies';

  @override
  String get interestAnime => 'Anime';

  @override
  String get interestKDrama => 'K-Drama';

  @override
  String get interestGaming => 'Gaming';

  @override
  String get interestStandUpComedy => 'Stand-up Comedy';

  @override
  String get interestPodcast => 'Podcast';

  @override
  String get interestBooks => 'Books';

  @override
  String get relationshipGoalTitle => 'What are you looking for?';

  @override
  String get relationshipGoalSubtitle =>
      'This helps us show you people with the same intentions.';

  @override
  String get relationshipGoalSeriousTitle => 'Serious Dating';

  @override
  String get relationshipGoalSeriousDescription =>
      'Looking for a long-term relationship';

  @override
  String get relationshipGoalCasualTitle => 'Casual Dating';

  @override
  String get relationshipGoalCasualDescription =>
      'Getting to know people, see where it goes';

  @override
  String get relationshipGoalNewConnectionsTitle => 'New Connections';

  @override
  String get relationshipGoalNewConnectionsDescription =>
      'Open to meeting new people, no pressure';

  @override
  String get relationshipGoalStillFiguringOutTitle => 'Still Figuring It Out';

  @override
  String get relationshipGoalStillFiguringOutDescription =>
      'Not sure yet, just exploring for now';

  @override
  String get preferencesTitle => 'Tell us what you\'re looking for';

  @override
  String preferencesAgeRangeLabel(int min, int max) {
    return '$min – $max years old';
  }

  @override
  String get preferencesOpenForAll => 'Open for all';

  @override
  String get preferencesGenderLabel => 'Gender';

  @override
  String get preferencesChildrenLabel => 'Children';

  @override
  String get preferencesMarriageLabel => 'Marriage';

  @override
  String get preferencesEthnicityLabel => 'Ethnicity';

  @override
  String get preferencesReligionLabel => 'Religion';

  @override
  String get preferencesEducationLabel => 'Education';

  @override
  String get preferencesDrinkingLabel => 'Drinking';

  @override
  String get preferencesSmokingLabel => 'Smoking';

  @override
  String get preferencesPetsLabel => 'Pets';

  @override
  String get religionIslam => 'Islam';

  @override
  String get religionChristianity => 'Christianity';

  @override
  String get religionCatholic => 'Catholic';

  @override
  String get religionHinduism => 'Hinduism';

  @override
  String get religionBuddhism => 'Buddhism';

  @override
  String get religionConfucianism => 'Confucianism';

  @override
  String get religionJudaism => 'Judaism';

  @override
  String get religionSikhism => 'Sikhism';

  @override
  String get religionTaoism => 'Taoism';

  @override
  String get religionOther => 'Other';

  @override
  String get religionAgnostic => 'Agnostic';

  @override
  String get religionAtheist => 'Atheist';

  @override
  String get religionPreferNotToSay => 'Prefer not to say';

  @override
  String get previewTitle => 'Almost there!';

  @override
  String get previewSubtitle => 'Review your profile before continuing.';

  @override
  String previewNameAge(String nickName, int age) {
    return '$nickName, $age';
  }

  @override
  String get previewLookingForTitle => 'Looking for';

  @override
  String get previewSubmit => 'Let\'s Go';

  @override
  String get previewSubmitError =>
      'Something went wrong saving your profile. Please try again.';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navConnections => 'Connections';

  @override
  String get navProfile => 'Profile';

  @override
  String get discoverEmptyMessage =>
      'No more profiles right now — check back later or refresh.';

  @override
  String get discoverRefreshLabel => 'Refresh Recommendations';

  @override
  String discoverDistanceLabel(String occupation, int distanceKm) {
    return '$occupation · $distanceKm km';
  }

  @override
  String get discoverCompatibleLabel => 'COMPATIBLE';

  @override
  String get connectionsTitle => 'Connections';

  @override
  String get connectionsMatchesTab => 'Matches';

  @override
  String get connectionsEmptyMessage =>
      'No matches yet — keep exploring Discover!';

  @override
  String connectionsSharedInterestsLabel(String interests) {
    return 'You both like $interests';
  }

  @override
  String get chatTypeMessageHint => 'Type a message...';

  @override
  String get chatOnlineStatus => 'Online';

  @override
  String get profileCompletenessLabel => 'Profile completeness';

  @override
  String get profileUpgradeTitle => 'Upgrade to Couplivy Plus';

  @override
  String get profileUpgradeSubtitle => 'Unlock more ways to connect';

  @override
  String get profileMenuMyProfile => 'My Profile';

  @override
  String get profileMenuMyPreferences => 'My Preferences';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuPrivacy => 'Privacy & Visibility';

  @override
  String get profileMenuSafety => 'Safety & Reporting';

  @override
  String get profileMenuAppSettings => 'App Settings';

  @override
  String get profileMenuTerms => 'Terms & Privacy';

  @override
  String get profileMenuLogOut => 'Log Out';

  @override
  String get profileLogOutConfirmTitle => 'Log out?';

  @override
  String get profileLogOutConfirmMessage =>
      'You\'ll need to log in again to access your account.';

  @override
  String get profileLogOutConfirmCancel => 'Cancel';

  @override
  String get profileLogOutConfirmConfirm => 'Log Out';

  @override
  String get profileComingSoonTitle => 'Coming soon';

  @override
  String get profileComingSoonMessage =>
      'This section isn\'t ready yet — check back later.';

  @override
  String get myProfileLoveLanguageLabel => 'Love language';

  @override
  String get myProfileRelationshipGoalLabel => 'Relationship goal';

  @override
  String get myPreferencesTitle => 'My Preferences';

  @override
  String get myPreferencesAgeRangeLabel => 'Age range';

  @override
  String get myPreferencesEmptyMessage =>
      'You haven\'t set your preferences yet.';

  @override
  String get myProfileAboutTitle => 'About';

  @override
  String get myProfileInterestsTitle => 'Interests';

  @override
  String get editLabel => 'Edit';

  @override
  String get editProfileSaveLabel => 'Save';

  @override
  String get appSettingsTitle => 'App Settings';

  @override
  String get appSettingsLanguageLabel => 'Language';

  @override
  String get appSettingsLanguageEnglish => 'English';

  @override
  String get appSettingsLanguageIndonesian => 'Indonesian';

  @override
  String get appSettingsVersionLabel => 'App version';

  @override
  String get termsTitle => 'Terms & Privacy';

  @override
  String get termsOfServiceLabel => 'Terms of Service';

  @override
  String get termsPrivacyPolicyLabel => 'Privacy Policy';

  @override
  String get privacyTitle => 'Privacy & Visibility';

  @override
  String get privacyHideProfileLabel => 'Hide my profile';

  @override
  String get privacyHideProfileDescription =>
      'Your profile won\'t appear in Discover to anyone.';

  @override
  String get privacyShowReligionLabel => 'Show religion';

  @override
  String get privacyShowReligionDescription =>
      'Let others see your religion on your profile.';

  @override
  String get privacyShowEthnicityLabel => 'Show ethnicity';

  @override
  String get privacyShowEthnicityDescription =>
      'Let others see your ethnicity on your profile.';

  @override
  String get privacyShowHeightWeightLabel => 'Show height';

  @override
  String get privacyShowHeightWeightDescription =>
      'Let others see your height on your profile.';

  @override
  String get privacyAllowDirectAddLabel => 'Allow direct add';

  @override
  String get privacyAllowDirectAddDescription =>
      'Let others add you directly without matching first.';

  @override
  String get privacyShowOnlineStatusLabel => 'Show online status';

  @override
  String get privacyShowOnlineStatusDescription =>
      'Let others see when you\'re active.';

  @override
  String get privacyAiConversationAssistantLabel => 'AI conversation assistant';

  @override
  String get privacyAiConversationAssistantDescription =>
      'Get AI-suggested icebreakers and replies in chats.';

  @override
  String get privacySaveError =>
      'Couldn\'t save your changes. Please try again.';
}
