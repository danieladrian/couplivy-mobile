import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/api/api_exception.dart';
import '../../core/models/my_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/preference_row.dart';
import 'profile_repository.dart';

/// "Edit My Preferences" — UI SAMA PERSIS gaya step 10 onboarding
/// (`PreferencesStepScreen`, lihat dokumentasi class itu untuk arti tiap
/// enum/opsi "open_for_all" exclusive), TAPI:
/// - Nilai AWAL dari `MyProfile.preferences` (profil YANG SUDAH ADA),
///   bukan draft onboarding kosong.
/// - 1 HALAMAN (bukan step onboarding terpisah dengan progress counter)
///   — semua field sekaligus, tombol Save di app bar.
/// - Submit ONLINE-FIRST ke `PATCH /me/preferences`
///   (`ProfileRepository.updatePreferences()`) — TIDAK ADA optimistic
///   write, `ProfileDatabase` lokal baru ter-update kalau request sukses
///   (lihat dokumentasi `ProfileDatabase`).
/// - Partial — cuma field yang diubah dikirim (lihat
///   `UpdatePreferencesRequest` backend), field yang tidak disentuh user
///   TIDAK dikirim sama sekali.
class EditPreferencesScreen extends StatefulWidget {
  const EditPreferencesScreen({super.key, required this.initialPreferences});

  final MyDatingPreferences? initialPreferences;

  @override
  State<EditPreferencesScreen> createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  late RangeValues _ageRange;
  String? _genderPreference;
  late Set<String> _childrenPreferences;
  late Set<String> _marriagePreferences;
  late Set<String> _ethnicityPreferences;
  late Set<String> _religionPreferences;
  late Set<String> _educationPreferences;
  late Set<String> _drinkingPreferences;
  late Set<String> _smokingPreferences;
  late Set<String> _petPreferences;
  bool _isSaving = false;

  // Dibandingkan terhadap nilai AWAL (bukan draft kosong onboarding) —
  // field yang TIDAK berubah dari initialPreferences tidak dikirim sama
  // sekali ke PATCH /me/preferences (lihat _changedFields()).
  late final MyDatingPreferences? _initial;

  @override
  void initState() {
    super.initState();
    _initial = widget.initialPreferences;
    _ageRange = RangeValues(
      (_initial?.ageMin ?? 25).toDouble(),
      (_initial?.ageMax ?? 35).toDouble(),
    );
    _genderPreference = _initial?.genderPreference;
    _childrenPreferences = {...?_initial?.childrenPreference};
    _marriagePreferences = {...?_initial?.marriagePreference};
    _ethnicityPreferences = {...?_initial?.ethnicityPreference};
    _religionPreferences = {...?_initial?.religionPreference};
    _educationPreferences = {...?_initial?.educationPreference};
    _drinkingPreferences = {...?_initial?.drinkingPreference};
    _smokingPreferences = {...?_initial?.smokingPreference};
    _petPreferences = {...?_initial?.petPreference};
  }

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

  bool _setChanged(List<String>? initial, Set<String> current) {
    final initialSet = {...?initial};
    return initialSet.length != current.length ||
        !initialSet.containsAll(current);
  }

  /// Cuma field yang BERUBAH dari nilai awal — partial update, konsisten
  /// `UpdatePreferencesRequest::sometimes` backend (field yang tidak
  /// dikirim TIDAK disentuh sama sekali, beda dari onboarding yang
  /// selalu kirim semua).
  Map<String, dynamic> _changedFields() {
    final fields = <String, dynamic>{};

    if (_ageRange.start.round() != (_initial?.ageMin ?? 25) ||
        _ageRange.end.round() != (_initial?.ageMax ?? 35)) {
      fields['age_min'] = _ageRange.start.round();
      fields['age_max'] = _ageRange.end.round();
    }
    if (_genderPreference != _initial?.genderPreference) {
      fields['gender_preference'] = _genderPreference;
    }
    if (_setChanged(_initial?.childrenPreference, _childrenPreferences)) {
      fields['children_preference'] = _childrenPreferences.toList();
    }
    if (_setChanged(_initial?.marriagePreference, _marriagePreferences)) {
      fields['marriage_preference'] = _marriagePreferences.toList();
    }
    if (_setChanged(_initial?.ethnicityPreference, _ethnicityPreferences)) {
      fields['ethnicity_preference'] = _ethnicityPreferences.toList();
    }
    if (_setChanged(_initial?.religionPreference, _religionPreferences)) {
      fields['religion_preference'] = _religionPreferences.toList();
    }
    if (_setChanged(_initial?.educationPreference, _educationPreferences)) {
      fields['education_preference'] = _educationPreferences.toList();
    }
    if (_setChanged(_initial?.drinkingPreference, _drinkingPreferences)) {
      fields['drinking_preference'] = _drinkingPreferences.toList();
    }
    if (_setChanged(_initial?.smokingPreference, _smokingPreferences)) {
      fields['smoking_preference'] = _smokingPreferences.toList();
    }
    if (_setChanged(_initial?.petPreference, _petPreferences)) {
      fields['pet_preference'] = _petPreferences.toList();
    }

    return fields;
  }

  Future<void> _save() async {
    if (!_isComplete || _isSaving) return;

    final fields = _changedFields();
    if (fields.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSaving = true);
    try {
      await profileRepository.updatePreferences(fields);
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _summaryFor(Map<String, String> options, Set<String> selected) {
    if (selected.isEmpty) return null;
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

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          l10n.myPreferencesTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          TextButton(
            onPressed: _isComplete && !_isSaving ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.editProfileSaveLabel),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
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
              value: _summaryFor(_childrenOptions(l10n), _childrenPreferences),
              onTap: _pickChildrenPreferences,
            ),
            PreferenceRow(
              icon: PhosphorIcons.heartStraight(),
              label: l10n.preferencesMarriageLabel,
              value: _summaryFor(_marriageOptions(l10n), _marriagePreferences),
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
              icon: PhosphorIcons.handsPraying(),
              label: l10n.preferencesReligionLabel,
              value: _summaryFor(_religionOptions(l10n), _religionPreferences),
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
              value: _summaryFor(_drinkingOptions(l10n), _drinkingPreferences),
              onTap: _pickDrinkingPreferences,
            ),
            PreferenceRow(
              icon: PhosphorIcons.cigarette(),
              label: l10n.preferencesSmokingLabel,
              value: _summaryFor(_smokingOptions(l10n), _smokingPreferences),
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
