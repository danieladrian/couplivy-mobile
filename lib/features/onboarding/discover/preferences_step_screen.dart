import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_scaffold.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 8/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/09-preferences.html. Semua
/// field OPTIONAL (default cukup masuk akal untuk dilewati begitu saja),
/// tombol utama berlabel "Save Preferences" (bukan "Continue" seperti
/// step lain).
///
/// `age_direction` dan `max_distance_km` ADA di skema `dating_preferences`
/// tapi TIDAK ADA UI-nya di desain HTML sumber — sengaja tidak diisi di
/// sini (kemungkinan diisi di fitur filter Discover terpisah nanti).
class PreferencesStepScreen extends StatefulWidget {
  const PreferencesStepScreen({super.key});

  @override
  State<PreferencesStepScreen> createState() => _PreferencesStepScreenState();
}

const _anyOptionKey = 'any';

class _PreferencesStepScreenState extends State<PreferencesStepScreen> {
  RangeValues _ageRange = const RangeValues(25, 35);
  String? _genderPreference;
  String? _familyPreference;
  Set<String> _religionPreferences = {};
  Set<String> _educationPreferences = {};
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
        _familyPreference = preferences['family_preference'] as String?;
        _religionPreferences =
            (preferences['religion_preference'] as List<dynamic>?)
                ?.cast<String>()
                .toSet() ??
            {};
        _educationPreferences =
            (preferences['education_preference'] as List<dynamic>?)
                ?.cast<String>()
                .toSet() ??
            {};
        _isLoadingDraft = false;
      });
    }
  }

  Future<void> _submit() async {
    await DiscoverOnboardingDraftStorage.savePreferences({
      'age_min': _ageRange.start.round(),
      'age_max': _ageRange.end.round(),
      if (_genderPreference != null) 'gender_preference': _genderPreference,
      if (_familyPreference != null) 'family_preference': _familyPreference,
      if (_religionPreferences.isNotEmpty)
        'religion_preference': _religionPreferences.toList(),
      if (_educationPreferences.isNotEmpty)
        'education_preference': _educationPreferences.toList(),
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
      'everyone': l10n.preferencesGenderAny,
    };
    final selected = await _showPickerSheet(options, _genderPreference);
    if (selected != null) setState(() => _genderPreference = selected);
  }

  Future<void> _pickFamilyPreference() async {
    final l10n = AppLocalizations.of(context);
    final options = {
      'wants_children': l10n.preferencesFamilyWantsChildren,
      'not_wants_children': l10n.preferencesFamilyNotWantsChildren,
      'open_to_children': l10n.preferencesFamilyOpenToChildren,
      'any': l10n.preferencesFamilyAny,
    };
    final selected = await _showPickerSheet(options, _familyPreference);
    if (selected != null) setState(() => _familyPreference = selected);
  }

  // "any" di PALING ATAS (bukan di akhir) — sesuai permintaan, supaya
  // opsi paling umum/exclusive langsung terlihat duluan. Sisanya sama
  // dengan `BioStepScreen._religionOptions` (agama milik user sendiri,
  // TIDAK ADA "any" di sana — beda konteks, itu bukan preferensi).
  Map<String, String> _religionOptions(AppLocalizations l10n) => {
    'any': l10n.preferencesReligionAny,
    'christian': l10n.religionChristian,
    'catholic': l10n.religionCatholic,
    'muslim': l10n.religionMuslim,
    'buddhist': l10n.religionBuddhist,
    'hindu': l10n.religionHindu,
    'jewish': l10n.religionJewish,
    'sikh': l10n.religionSikh,
    'atheist_agnostic': l10n.religionAtheistAgnostic,
    'spiritual': l10n.religionSpiritual,
    'other': l10n.religionOther,
  };

  Future<void> _pickReligionPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await _showMultiSelectSheet(
      _religionOptions(l10n),
      _religionPreferences,
    );
    if (selected != null) setState(() => _religionPreferences = selected);
  }

  // "any" di PALING ATAS, sisanya jenjang terendah ke tertinggi.
  Map<String, String> _educationOptions(AppLocalizations l10n) => {
    'any': l10n.educationAny,
    'no_education': l10n.educationNoEducation,
    'elementary': l10n.educationElementary,
    'high_school': l10n.educationHighSchool,
    'bachelor': l10n.educationBachelor,
    'master': l10n.educationMaster,
    'doctorate': l10n.educationDoctorate,
  };

  Future<void> _pickEducationPreferences() async {
    final l10n = AppLocalizations.of(context);
    final selected = await _showMultiSelectSheet(
      _educationOptions(l10n),
      _educationPreferences,
    );
    if (selected != null) setState(() => _educationPreferences = selected);
  }

  Future<String?> _showPickerSheet(
    Map<String, String> options,
    String? current,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      // Family (4 opsi) bisa lebih tinggi dari layar pendek — tanpa
      // batas tinggi + scroll, Column overflow ("A RenderFlex
      // overflowed", baris terakhir terpotong). Pola sama seperti
      // `BioStepScreen._pickFromOptions`.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final entry in options.entries)
                      ListTile(
                        title: Text(entry.value),
                        trailing: current == entry.key
                            ? const Icon(
                                Icons.check,
                                color: AppColors.deepViolet,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(entry.key),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Bottom sheet MULTI-select (checkbox) — dipakai Religion & Education
  /// preference, KEDUANYA bisa pilih lebih dari satu (mis. "Muslim atau
  /// Christian"). "any" (SELALU opsi pertama, lihat `_religionOptions`/
  /// `_educationOptions`) bersifat EXCLUSIVE — pilih "any" otomatis
  /// uncheck yang lain (karena "any" sudah mencakup semua), dan pilih
  /// opsi spesifik lain otomatis uncheck "any". Mencegah kombinasi
  /// rancu seperti "Any + Christian" yang secara makna sama saja
  /// dengan "Any".
  Future<Set<String>?> _showMultiSelectSheet(
    Map<String, String> options,
    Set<String> current,
  ) {
    var selection = {...current};

    return showModalBottomSheet<Set<String>>(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void toggle(String key) {
              setSheetState(() {
                if (key == _anyOptionKey) {
                  selection = selection.contains(_anyOptionKey)
                      ? {}
                      : {_anyOptionKey};
                } else if (selection.contains(key)) {
                  selection.remove(key);
                } else {
                  selection
                    ..remove(_anyOptionKey)
                    ..add(key);
                }
              });
            }

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final entry in options.entries)
                          CheckboxListTile(
                            title: Text(entry.value),
                            value: selection.contains(entry.key),
                            activeColor: AppColors.deepViolet,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (_) => toggle(entry.key),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: AppButton(
                      label: AppLocalizations.of(context).onboardingContinue,
                      onPressed: () => Navigator.of(context).pop(selection),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        step: 8,
        totalSteps: 9,
        onBack: _backToRelationshipGoal,
        bottomButton: AppButton(
          label: l10n.onboardingContinue,
          onPressed: _submit,
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
                  // Row full-bleed (chevron 0px dari tepi fisik layar)
                  // SEMPAT dicoba (LayoutBuilder+OverflowBox) tapi
                  // ternyata rapuh — kombinasi dengan SingleChildScrollView
                  // (tinggi unbounded) menghasilkan posisi NaN dan
                  // crash. Dibatalkan — murni permintaan visual, tidak
                  // ada dampak fungsional, tidak sepadan dengan
                  // kompleksitas/risiko yang muncul. Row ini ikut
                  // padding 24px standar `OnboardingStepScaffold`, sama
                  // seperti elemen lain di halaman.
                  _PreferenceRow(
                    icon: PhosphorIcons.user(),
                    label: l10n.preferencesGenderLabel,
                    value: _genderPreference != null
                        ? {
                            'female': l10n.genderFemale,
                            'male': l10n.genderMale,
                            'everyone': l10n.preferencesGenderAny,
                          }[_genderPreference]
                        : null,
                    onTap: _pickGenderPreference,
                  ),
                  _PreferenceRow(
                    icon: PhosphorIcons.heart(),
                    label: l10n.preferencesFamilyLabel,
                    value: _familyPreference != null
                        ? {
                            'wants_children':
                                l10n.preferencesFamilyWantsChildren,
                            'not_wants_children':
                                l10n.preferencesFamilyNotWantsChildren,
                            'open_to_children':
                                l10n.preferencesFamilyOpenToChildren,
                            'any': l10n.preferencesFamilyAny,
                          }[_familyPreference]
                        : null,
                    onTap: _pickFamilyPreference,
                  ),
                  _PreferenceRow(
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
                  _PreferenceRow(
                    icon: PhosphorIcons.graduationCap(),
                    label: l10n.preferencesEducationLabel,
                    value: _summaryFor(
                      _educationOptions(l10n),
                      _educationPreferences,
                    ),
                    onTap: _pickEducationPreferences,
                  ),
                ],
              ),
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final PhosphorIconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Full-bleed (chevron 0px dari tepi layar) SEMPAT dicoba tapi
        // dibatalkan (lihat catatan di `_PreferencesStepScreenState.
        // build()`) — padding standar mengikuti 24px yang sudah
        // diterapkan `OnboardingStepScaffold` ke seluruh body.
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.deepViolet),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
            const Spacer(),
            // Flexible + ellipsis — value bisa jadi ringkasan panjang
            // untuk field MULTI-select (mis. "Christian, Muslim,
            // Buddhist"), Text polos tanpa constraint bisa overflow
            // horizontal.
            Flexible(
              child: Text(
                value ?? '—',
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
