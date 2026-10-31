import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_scaffold.dart';
import '../../../shared/widgets/preference_row.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 10/11 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/09-preferences.html.
/// Gender WAJIB diisi (single-select, Continue disabled sampai
/// terpilih). Age range TIDAK termasuk wajib — RangeSlider selalu punya
/// nilai default (25-35), jadi selalu "terisi" tanpa perlu disentuh
/// user.
///
/// **GANTI TOTAL** — SEMUA field selain Gender/age sekarang MULTI-select
/// dengan opsi "Open for all" (GANTI "Any"/"Everyone" lama, EXCLUSIVE —
/// pilih ini otomatis uncheck opsi lain, sama pola "any" yang sudah ada
/// sebelumnya). `family_preference` lama (kolom tunggal) DIHAPUS TOTAL,
/// digantikan Children DAN Marriage sebagai 2 field terpisah. 4 field
/// BARU ditambah: Ethnicity, Drinking, Smoking, Pets — SEMUA multi-select
/// dengan "Open for all", TANPA opsi "prefer_not_to_say"/"other"/
/// "neutral" (keputusan produk, khusus preferensi pasangan di step ini —
/// beda dari field serupa milik profil sendiri di step Bio/Lifestyle/
/// Future yang TETAP punya opsi itu).
///
/// `age_direction` dan `max_distance_km` ADA di skema `dating_preferences`
/// tapi TIDAK ADA UI-nya di desain HTML sumber — sengaja tidak diisi di
/// sini (kemungkinan diisi di fitur filter Discover terpisah nanti).
class PreferencesStepScreen extends StatefulWidget {
  const PreferencesStepScreen({super.key});

  @override
  State<PreferencesStepScreen> createState() => _PreferencesStepScreenState();
}

class _PreferencesStepScreenState extends State<PreferencesStepScreen> {
  RangeValues _ageRange = const RangeValues(25, 35);
  String? _genderPreference;
  Set<String> _childrenPreferences = {};
  Set<String> _marriagePreferences = {};
  Set<String> _ethnicityPreferences = {};
  Set<String> _religionPreferences = {};
  Set<String> _educationPreferences = {};
  Set<String> _drinkingPreferences = {};
  Set<String> _smokingPreferences = {};
  Set<String> _petPreferences = {};
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final preferences = await DiscoverOnboardingDraftStorage.readPreferences();
    if (mounted) {
      setState(() {
        final ageMin = preferences['age_min'] as int?;
        final ageMax = preferences['age_max'] as int?;
        if (ageMin != null && ageMax != null) {
          _ageRange = RangeValues(ageMin.toDouble(), ageMax.toDouble());
        }
        _genderPreference = preferences['gender_preference'] as String?;
        _childrenPreferences = _asStringSet(preferences['children_preference']);
        _marriagePreferences = _asStringSet(preferences['marriage_preference']);
        _ethnicityPreferences = _asStringSet(
          preferences['ethnicity_preference'],
        );
        _religionPreferences = _asStringSet(preferences['religion_preference']);
        _educationPreferences = _asStringSet(
          preferences['education_preference'],
        );
        _drinkingPreferences = _asStringSet(preferences['drinking_preference']);
        _smokingPreferences = _asStringSet(preferences['smoking_preference']);
        _petPreferences = _asStringSet(preferences['pet_preference']);
        _isLoadingDraft = false;
      });
    }
  }

  Set<String> _asStringSet(Object? value) =>
      (value as List<dynamic>?)?.cast<String>().toSet() ?? {};

  // Gender WAJIB diisi — Continue disabled sampai terpilih. SEMUA field
  // multi-select lain JUGA wajib (min 1 pilihan, termasuk "Open for
  // all" sebagai pilihan valid) — konsisten field lain di step ini.
  // Age range TIDAK dicek (selalu punya nilai default).
  bool get _isComplete =>
      _genderPreference != null &&
      _childrenPreferences.isNotEmpty &&
      _marriagePreferences.isNotEmpty &&
      _ethnicityPreferences.isNotEmpty &&
      _religionPreferences.isNotEmpty &&
      _educationPreferences.isNotEmpty &&
      _drinkingPreferences.isNotEmpty &&
      _smokingPreferences.isNotEmpty &&
      _petPreferences.isNotEmpty;

  Future<void> _submit() async {
    if (!_isComplete) return;

    await DiscoverOnboardingDraftStorage.savePreferences({
      'age_min': _ageRange.start.round(),
      'age_max': _ageRange.end.round(),
      'gender_preference': _genderPreference,
      'children_preference': _childrenPreferences.toList(),
      'marriage_preference': _marriagePreferences.toList(),
      'ethnicity_preference': _ethnicityPreferences.toList(),
      'religion_preference': _religionPreferences.toList(),
      'education_preference': _educationPreferences.toList(),
      'drinking_preference': _drinkingPreferences.toList(),
      'smoking_preference': _smokingPreferences.toList(),
      'pet_preference': _petPreferences.toList(),
    });
    if (mounted) context.go('/onboarding/discover/preview');
  }

  void _backToRelationshipGoal() =>
      context.go('/onboarding/discover/relationship-goal');

  /// Ringkasan row untuk field MULTI-select — tampilkan SEMUA yang
  /// dipilih (dipisah koma), bukan cuma 1 nilai seperti field single-
  /// select lain. null kalau belum ada yang dipilih (row tampilkan "—").
  String? _summaryFor(Map<String, String> options, Set<String> selected) {
    if (selected.isEmpty) return null;
    // Urutan sesuai urutan Map options (bukan urutan Set, yang tidak
    // stabil) — supaya tampilan konsisten tiap kali dibuka.
    return options.entries
        .where((entry) => selected.contains(entry.key))
        .map((entry) => entry.value)
        .join(', ');
  }

  Future<void> _pickGenderPreference() async {
    final l10n = AppLocalizations.of(context);
    final options = {
      'female': l10n.genderFemale,
      'male': l10n.genderMale,
      'open_for_all': l10n.preferencesOpenForAll,
    };
    final selected = await showSingleSelectSheet(
      context,
      options,
      _genderPreference,
    );
    if (selected != null) setState(() => _genderPreference = selected);
  }

  // "open_for_all" SELALU opsi TERAKHIR (beda dari "any" lama yang di
  // paling atas) — keputusan produk kali ini, opsi spesifik didahulukan.
  Map<String, String> _childrenOptions(AppLocalizations l10n) => {
    'want_children': l10n.childrenPreferenceWantChildren,
    'not_want_children': l10n.childrenPreferenceNotWantChildren,
    'have_children': l10n.childrenPreferenceHaveChildren,
    'open_to_children': l10n.childrenPreferenceOpenToChildren,
    'not_sure': l10n.childrenPreferenceNotSure,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickChildrenPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _childrenOptions(l10n),
      _childrenPreferences,
    );
    if (selected != null) setState(() => _childrenPreferences = selected);
  }

  Map<String, String> _marriageOptions(AppLocalizations l10n) => {
    'want_marriage': l10n.marriagePreferenceWantMarriage,
    'open_to_marriage': l10n.marriagePreferenceOpenToMarriage,
    'not_want_marriage': l10n.marriagePreferenceNotWantMarriage,
    'not_sure': l10n.marriagePreferenceNotSure,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickMarriagePreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _marriageOptions(l10n),
      _marriagePreferences,
    );
    if (selected != null) setState(() => _marriagePreferences = selected);
  }

  // Enum SAMA dengan `BioStepScreen._ethnicityOptions` MINUS
  // "other"/"prefer_not_to_say" (tidak masuk akal sebagai preferensi
  // siapa yang dicari), PLUS "open_for_all".
  Map<String, String> _ethnicityOptions(AppLocalizations l10n) => {
    'east_asian': l10n.ethnicityEastAsian,
    'south_asian': l10n.ethnicitySouthAsian,
    'southeast_asian': l10n.ethnicitySoutheastAsian,
    'middle_eastern': l10n.ethnicityMiddleEastern,
    'black_african': l10n.ethnicityBlackAfrican,
    'hispanic_latino': l10n.ethnicityHispanicLatino,
    'white_european': l10n.ethnicityWhiteEuropean,
    'javanese': l10n.ethnicityJavanese,
    'sundanese': l10n.ethnicitySundanese,
    'batak': l10n.ethnicityBatak,
    'minangkabau': l10n.ethnicityMinangkabau,
    'balinese': l10n.ethnicityBalinese,
    'madurese': l10n.ethnicityMadurese,
    'betawi': l10n.ethnicityBetawi,
    'bugis': l10n.ethnicityBugis,
    'dayak': l10n.ethnicityDayak,
    'papuan': l10n.ethnicityPapuan,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickEthnicityPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _ethnicityOptions(l10n),
      _ethnicityPreferences,
    );
    if (selected != null) setState(() => _ethnicityPreferences = selected);
  }

  // "other" DIHAPUS (beda dari `religion` milik profil sendiri yang
  // punya opsi itu) — "open_for_all" GANTI "any" lama.
  Map<String, String> _religionOptions(AppLocalizations l10n) => {
    'islam': l10n.religionIslam,
    'christianity': l10n.religionChristianity,
    'catholic': l10n.religionCatholic,
    'hinduism': l10n.religionHinduism,
    'buddhism': l10n.religionBuddhism,
    'confucianism': l10n.religionConfucianism,
    'judaism': l10n.religionJudaism,
    'sikhism': l10n.religionSikhism,
    'taoism': l10n.religionTaoism,
    'agnostic': l10n.religionAgnostic,
    'atheist': l10n.religionAtheist,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickReligionPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _religionOptions(l10n),
      _religionPreferences,
    );
    if (selected != null) setState(() => _religionPreferences = selected);
  }

  Map<String, String> _educationOptions(AppLocalizations l10n) => {
    'no_education': l10n.educationNoEducation,
    'elementary': l10n.educationElementary,
    'high_school': l10n.educationHighSchool,
    'bachelor': l10n.educationBachelor,
    'master': l10n.educationMaster,
    'doctorate': l10n.educationDoctorate,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickEducationPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _educationOptions(l10n),
      _educationPreferences,
    );
    if (selected != null) setState(() => _educationPreferences = selected);
  }

  // Enum SAMA dengan `LifestyleStepScreen._drinkingOptions` MINUS
  // "prefer_not_to_say", PLUS "open_for_all".
  Map<String, String> _drinkingOptions(AppLocalizations l10n) => {
    'never': l10n.drinkingNever,
    'occasionally': l10n.drinkingOccasionally,
    'socially': l10n.drinkingSocially,
    'regularly': l10n.drinkingRegularly,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickDrinkingPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _drinkingOptions(l10n),
      _drinkingPreferences,
    );
    if (selected != null) setState(() => _drinkingPreferences = selected);
  }

  Map<String, String> _smokingOptions(AppLocalizations l10n) => {
    'never': l10n.smokingNever,
    'occasionally': l10n.smokingOccasionally,
    'regularly': l10n.smokingRegularly,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickSmokingPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _smokingOptions(l10n),
      _smokingPreferences,
    );
    if (selected != null) setState(() => _smokingPreferences = selected);
  }

  // TANPA "neutral" — dianggap setara "open_for_all" untuk preferensi
  // pasangan (keputusan produk), beda dari `pet_preference` milik
  // profil sendiri di step Lifestyle yang PUNYA opsi neutral.
  Map<String, String> _petOptions(AppLocalizations l10n) => {
    'love_pets': l10n.petPreferenceLovePets,
    'not_a_fan': l10n.petPreferenceNotAFan,
    'open_for_all': l10n.preferencesOpenForAll,
  };

  Future<void> _pickPetPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showMultiSelectSheet(
      context,
      _petOptions(l10n),
      _petPreferences,
    );
    if (selected != null) setState(() => _petPreferences = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToRelationshipGoal();
      },
      child: OnboardingStepScaffold(
        step: 10,
        totalSteps: 11,
        onBack: _backToRelationshipGoal,
        bottomButton: AppButton(
          label: l10n.onboardingContinue,
          onPressed: _isComplete ? _submit : null,
        ),
        body: _isLoadingDraft
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.preferencesTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.preferencesAgeRangeLabel(
                        _ageRange.start.round(),
                        _ageRange.end.round(),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepViolet,
                      ),
                    ),
                  ),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 80,
                    activeColor: AppColors.lilac,
                    inactiveColor: AppColors.border,
                    onChanged: (values) => setState(() => _ageRange = values),
                  ),
                  const SizedBox(height: 12),
                  PreferenceRow(
                    icon: PhosphorIcons.user(),
                    label: l10n.preferencesGenderLabel,
                    value: _genderPreference != null
                        ? {
                            'female': l10n.genderFemale,
                            'male': l10n.genderMale,
                            'open_for_all': l10n.preferencesOpenForAll,
                          }[_genderPreference]
                        : null,
                    onTap: _pickGenderPreference,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.babyCarriage(),
                    label: l10n.preferencesChildrenLabel,
                    value: _summaryFor(
                      _childrenOptions(l10n),
                      _childrenPreferences,
                    ),
                    onTap: _pickChildrenPreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.heartStraight(),
                    label: l10n.preferencesMarriageLabel,
                    value: _summaryFor(
                      _marriageOptions(l10n),
                      _marriagePreferences,
                    ),
                    onTap: _pickMarriagePreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.globe(),
                    label: l10n.preferencesEthnicityLabel,
                    value: _summaryFor(
                      _ethnicityOptions(l10n),
                      _ethnicityPreferences,
                    ),
                    onTap: _pickEthnicityPreferences,
                  ),
                  PreferenceRow(
                    // handsPraying, BUKAN cross — simbol salib spesifik
                    // Kristen/Katolik, tidak netral untuk agama lain
                    // (lihat riwayat percakapan).
                    icon: PhosphorIcons.handsPraying(),
                    label: l10n.preferencesReligionLabel,
                    value: _summaryFor(
                      _religionOptions(l10n),
                      _religionPreferences,
                    ),
                    onTap: _pickReligionPreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.graduationCap(),
                    label: l10n.preferencesEducationLabel,
                    value: _summaryFor(
                      _educationOptions(l10n),
                      _educationPreferences,
                    ),
                    onTap: _pickEducationPreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.wine(),
                    label: l10n.preferencesDrinkingLabel,
                    value: _summaryFor(
                      _drinkingOptions(l10n),
                      _drinkingPreferences,
                    ),
                    onTap: _pickDrinkingPreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.cigarette(),
                    label: l10n.preferencesSmokingLabel,
                    value: _summaryFor(
                      _smokingOptions(l10n),
                      _smokingPreferences,
                    ),
                    onTap: _pickSmokingPreferences,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.pawPrint(),
                    label: l10n.preferencesPetsLabel,
                    value: _summaryFor(_petOptions(l10n), _petPreferences),
                    onTap: _pickPetPreferences,
                  ),
                ],
              ),
      ),
    );
  }
}
