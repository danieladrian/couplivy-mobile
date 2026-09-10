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
  String get authPasswordHintSignUp => 'At least 8 characters';

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
  String get ethnicityAsian => 'Asian';

  @override
  String get ethnicityBlackAfricanDescent => 'Black / African Descent';

  @override
  String get ethnicityHispanicLatino => 'Hispanic / Latino';

  @override
  String get ethnicityMiddleEastern => 'Middle Eastern';

  @override
  String get ethnicityNativeAmerican => 'Native American';

  @override
  String get ethnicityPacificIslander => 'Pacific Islander';

  @override
  String get ethnicitySouthAsian => 'South Asian';

  @override
  String get ethnicityWhiteCaucasian => 'White / Caucasian';

  @override
  String get ethnicityMixedMultiracial => 'Mixed / Multiracial';

  @override
  String get ethnicityOther => 'Other';

  @override
  String get ethnicityChinese => 'Chinese';

  @override
  String get bioWantsChildrenLabel => 'Do you want children?';

  @override
  String get bioWantsChildrenYes => 'Yes';

  @override
  String get bioWantsChildrenNo => 'No';

  @override
  String get bioWantsChildrenNotSure => 'Not sure yet';

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
  String get educationAny => 'Any';

  @override
  String get workEducationAllFieldsRequiredError =>
      'Please fill in occupation and education to continue.';

  @override
  String get interestsTitle => 'What are your interests?';

  @override
  String get interestsSubtitle => 'Choose a few things you enjoy.';

  @override
  String interestsSelectedCount(int count) {
    return '$count selected · choose at least 3';
  }

  @override
  String get interestsMinimumError =>
      'Choose at least 3 interests to continue.';

  @override
  String get interestTravel => 'Travel';

  @override
  String get interestCoffee => 'Coffee / Tea';

  @override
  String get interestHiking => 'Hiking';

  @override
  String get interestFood => 'Food';

  @override
  String get interestMusic => 'Music';

  @override
  String get interestMovies => 'Movies';

  @override
  String get interestSports => 'Sports';

  @override
  String get interestReading => 'Reading';

  @override
  String get interestArt => 'Art';

  @override
  String get interestNature => 'Nature';

  @override
  String get interestGaming => 'Gaming';

  @override
  String get interestPhotography => 'Photography';

  @override
  String get interestFitness => 'Fitness';

  @override
  String get interestCooking => 'Cooking';

  @override
  String get interestDancing => 'Dancing';

  @override
  String get interestPets => 'Pets';

  @override
  String get interestFashion => 'Fashion';

  @override
  String get interestWine => 'Wine';

  @override
  String get interestVolunteering => 'Volunteering';

  @override
  String get interestWriting => 'Writing';

  @override
  String get interestGardening => 'Gardening';

  @override
  String get interestCamping => 'Camping';

  @override
  String get interestYoga => 'Yoga';

  @override
  String get interestTechnology => 'Technology';

  @override
  String get relationshipGoalTitle => 'What are you looking for?';

  @override
  String get relationshipGoalSubtitle =>
      'This helps us show you people with the same intentions.';

  @override
  String get relationshipGoalSeriousTitle => 'Serious Relationship';

  @override
  String get relationshipGoalSeriousDescription =>
      'Looking for a long-term relationship';

  @override
  String get relationshipGoalCasualTitle => 'Casual Dating';

  @override
  String get relationshipGoalCasualDescription =>
      'Getting to know people, see where it goes';

  @override
  String get relationshipGoalFriendshipTitle => 'Friendship';

  @override
  String get relationshipGoalFriendshipDescription =>
      'Looking to make new friends first';

  @override
  String get preferencesTitle => 'Tell us what you\'re looking for';

  @override
  String preferencesAgeRangeLabel(int min, int max) {
    return '$min – $max years old';
  }

  @override
  String get preferencesGenderLabel => 'Gender';

  @override
  String get preferencesGenderAny => 'Everyone';

  @override
  String get preferencesFamilyLabel => 'Family preference';

  @override
  String get preferencesFamilyWantsChildren => 'Wants children';

  @override
  String get preferencesFamilyNotWantsChildren => 'Doesn\'t want children';

  @override
  String get preferencesFamilyOpenToChildren => 'Open to children';

  @override
  String get preferencesFamilyAny => 'Any';

  @override
  String get preferencesReligionLabel => 'Religion';

  @override
  String get preferencesReligionAny => 'Any';

  @override
  String get religionChristian => 'Christian';

  @override
  String get religionCatholic => 'Catholic';

  @override
  String get religionMuslim => 'Muslim';

  @override
  String get religionBuddhist => 'Buddhist';

  @override
  String get religionHindu => 'Hindu';

  @override
  String get religionJewish => 'Jewish';

  @override
  String get religionSikh => 'Sikh';

  @override
  String get religionAtheistAgnostic => 'Atheist / Agnostic';

  @override
  String get religionSpiritual => 'Spiritual (not religious)';

  @override
  String get religionOther => 'Other';

  @override
  String get preferencesEducationLabel => 'Education';

  @override
  String get previewTitle => 'Almost there!';

  @override
  String get previewSubtitle => 'Review your profile before continuing.';

  @override
  String previewNameAge(String nickName, int age) {
    return '$nickName, $age';
  }

  @override
  String get previewSubmit => 'Looks Good';

  @override
  String get previewSubmitError =>
      'Something went wrong saving your profile. Please try again.';
}
