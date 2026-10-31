import '../../l10n/generated/app_localizations.dart';

/// Terjemahkan value enum (dari `MyProfile`/`MyDatingPreferences`) ke
/// label tampil — SATU sumber kebenaran dipakai `MyProfileScreen` (data
/// milik sendiri) DAN `MyPreferencesScreen` (preferensi pasangan), supaya
/// tidak duplikasi switch-case yang sudah ada di
/// `BioStepScreen`/`LifestyleStepScreen`/`FutureStepScreen`/
/// `PreferencesStepScreen` (screen ONBOARDING itu tetap simpan salinan
/// sendiri masing-masing — method privat di sana TIDAK di-reuse langsung
/// supaya tidak menambah shared-state lintas fitur yang tidak perlu;
/// helper ini murni untuk fitur BARU, read-only, di luar alur onboarding).
abstract final class ProfileLabels {
  static String gender(AppLocalizations l10n, String key) => switch (key) {
    'female' => l10n.genderFemale,
    'male' => l10n.genderMale,
    'prefer_not_to_say' => l10n.genderPreferNotToSay,
    _ => key,
  };

  static String genderPreference(AppLocalizations l10n, String key) =>
      switch (key) {
        'female' => l10n.genderFemale,
        'male' => l10n.genderMale,
        'open_for_all' => l10n.preferencesOpenForAll,
        _ => key,
      };

  static String ethnicity(AppLocalizations l10n, String key) => switch (key) {
    'east_asian' => l10n.ethnicityEastAsian,
    'south_asian' => l10n.ethnicitySouthAsian,
    'southeast_asian' => l10n.ethnicitySoutheastAsian,
    'middle_eastern' => l10n.ethnicityMiddleEastern,
    'black_african' => l10n.ethnicityBlackAfrican,
    'hispanic_latino' => l10n.ethnicityHispanicLatino,
    'white_european' => l10n.ethnicityWhiteEuropean,
    'javanese' => l10n.ethnicityJavanese,
    'sundanese' => l10n.ethnicitySundanese,
    'batak' => l10n.ethnicityBatak,
    'minangkabau' => l10n.ethnicityMinangkabau,
    'balinese' => l10n.ethnicityBalinese,
    'madurese' => l10n.ethnicityMadurese,
    'betawi' => l10n.ethnicityBetawi,
    'bugis' => l10n.ethnicityBugis,
    'dayak' => l10n.ethnicityDayak,
    'papuan' => l10n.ethnicityPapuan,
    'other' => l10n.ethnicityOther,
    'prefer_not_to_say' => l10n.ethnicityPreferNotToSay,
    'open_for_all' => l10n.preferencesOpenForAll,
    _ => key,
  };

  static String religion(AppLocalizations l10n, String key) => switch (key) {
    'islam' => l10n.religionIslam,
    'christianity' => l10n.religionChristianity,
    'catholic' => l10n.religionCatholic,
    'hinduism' => l10n.religionHinduism,
    'buddhism' => l10n.religionBuddhism,
    'confucianism' => l10n.religionConfucianism,
    'judaism' => l10n.religionJudaism,
    'sikhism' => l10n.religionSikhism,
    'taoism' => l10n.religionTaoism,
    'other' => l10n.religionOther,
    'agnostic' => l10n.religionAgnostic,
    'atheist' => l10n.religionAtheist,
    'prefer_not_to_say' => l10n.religionPreferNotToSay,
    'open_for_all' => l10n.preferencesOpenForAll,
    _ => key,
  };

  static String education(AppLocalizations l10n, String key) => switch (key) {
    'no_education' => l10n.educationNoEducation,
    'elementary' => l10n.educationElementary,
    'high_school' => l10n.educationHighSchool,
    'bachelor' => l10n.educationBachelor,
    'master' => l10n.educationMaster,
    'doctorate' => l10n.educationDoctorate,
    'open_for_all' => l10n.preferencesOpenForAll,
    _ => key,
  };

  static String relationshipGoal(AppLocalizations l10n, String key) =>
      switch (key) {
        'serious_dating' => l10n.relationshipGoalSeriousTitle,
        'casual_dating' => l10n.relationshipGoalCasualTitle,
        'new_connections' => l10n.relationshipGoalNewConnectionsTitle,
        'still_figuring_out' => l10n.relationshipGoalStillFiguringOutTitle,
        _ => key,
      };

  static String drinking(AppLocalizations l10n, String key) => switch (key) {
    'never' => l10n.drinkingNever,
    'occasionally' => l10n.drinkingOccasionally,
    'socially' => l10n.drinkingSocially,
    'regularly' => l10n.drinkingRegularly,
    'prefer_not_to_say' => l10n.drinkingPreferNotToSay,
    'open_for_all' => l10n.preferencesOpenForAll,
    _ => key,
  };

  static String smoking(AppLocalizations l10n, String key) => switch (key) {
    'never' => l10n.smokingNever,
    'occasionally' => l10n.smokingOccasionally,
    'regularly' => l10n.smokingRegularly,
    'prefer_not_to_say' => l10n.smokingPreferNotToSay,
    'open_for_all' => l10n.preferencesOpenForAll,
    _ => key,
  };

  static String petPreference(AppLocalizations l10n, String key) =>
      switch (key) {
        'love_pets' => l10n.petPreferenceLovePets,
        'neutral' => l10n.petPreferenceNeutral,
        'not_a_fan' => l10n.petPreferenceNotAFan,
        'open_for_all' => l10n.preferencesOpenForAll,
        _ => key,
      };

  static String childrenPreference(AppLocalizations l10n, String key) =>
      switch (key) {
        'want_children' => l10n.childrenPreferenceWantChildren,
        'not_want_children' => l10n.childrenPreferenceNotWantChildren,
        'have_children' => l10n.childrenPreferenceHaveChildren,
        'open_to_children' => l10n.childrenPreferenceOpenToChildren,
        'not_sure' => l10n.childrenPreferenceNotSure,
        'prefer_not_to_say' => l10n.childrenPreferencePreferNotToSay,
        'open_for_all' => l10n.preferencesOpenForAll,
        _ => key,
      };

  static String marriagePreference(AppLocalizations l10n, String key) =>
      switch (key) {
        'want_marriage' => l10n.marriagePreferenceWantMarriage,
        'open_to_marriage' => l10n.marriagePreferenceOpenToMarriage,
        'not_want_marriage' => l10n.marriagePreferenceNotWantMarriage,
        'not_sure' => l10n.marriagePreferenceNotSure,
        'open_for_all' => l10n.preferencesOpenForAll,
        _ => key,
      };

  static String loveLanguage(AppLocalizations l10n, String key) =>
      switch (key) {
        'words_of_affirmation' => l10n.loveLanguageWordsOfAffirmation,
        'quality_time' => l10n.loveLanguageQualityTime,
        'acts_of_service' => l10n.loveLanguageActsOfService,
        'physical_touch' => l10n.loveLanguagePhysicalTouch,
        'gifts' => l10n.loveLanguageGifts,
        'dont_know_yet' => l10n.loveLanguageDontKnowYet,
        _ => key,
      };

  static String joinAll(List<String> keys, String Function(String) label) =>
      keys.map(label).join(', ');
}
