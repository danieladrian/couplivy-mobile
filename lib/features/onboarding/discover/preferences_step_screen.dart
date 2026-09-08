import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
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

class _PreferencesStepScreenState extends State<PreferencesStepScreen> {
  RangeValues _ageRange = const RangeValues(25, 35);
  String? _genderPreference;
  String? _familyPreference;
  final _religionController = TextEditingController();
  String? _educationPreference;
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
        _religionController.text =
            preferences['religion_preference'] as String? ?? '';
        _educationPreference = preferences['education_preference'] as String?;
        _isLoadingDraft = false;
      });
    }
  }

  @override
  void dispose() {
    _religionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await DiscoverOnboardingDraftStorage.savePreferences({
      'age_min': _ageRange.start.round(),
      'age_max': _ageRange.end.round(),
      if (_genderPreference != null) 'gender_preference': _genderPreference,
      if (_familyPreference != null) 'family_preference': _familyPreference,
      if (_religionController.text.trim().isNotEmpty)
        'religion_preference': _religionController.text.trim(),
      if (_educationPreference != null)
        'education_preference': _educationPreference,
    });
    if (mounted) context.go('/onboarding/discover/preview');
  }

  void _backToRelationshipGoal() =>
      context.go('/onboarding/discover/relationship-goal');

  Future<void> _pickGenderPreference() async {
    final l10n = AppLocalizations.of(context);
    final options = {
      'female': l10n.genderFemale,
      'male': l10n.genderMale,
      'non_binary': l10n.genderNonBinary,
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

  Future<void> _pickEducationPreference() async {
    final l10n = AppLocalizations.of(context);
    final options = {
      'high_school': l10n.educationHighSchool,
      'bachelor': l10n.educationBachelor,
      'master': l10n.educationMaster,
      'doctorate': l10n.educationDoctorate,
      'any': l10n.educationAny,
    };
    final selected = await _showPickerSheet(options, _educationPreference);
    if (selected != null) setState(() => _educationPreference = selected);
  }

  Future<String?> _showPickerSheet(
    Map<String, String> options,
    String? current,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              for (final entry in options.entries)
                ListTile(
                  title: Text(entry.value),
                  trailing: current == entry.key
                      ? const Icon(Icons.check, color: AppColors.deepViolet)
                      : null,
                  onTap: () => Navigator.of(context).pop(entry.key),
                ),
              const SizedBox(height: 12),
            ],
          ),
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
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 8,
                totalSteps: 9,
                onBack: _backToRelationshipGoal,
              ),
              Expanded(
                child: _isLoadingDraft
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
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
                              onChanged: (values) =>
                                  setState(() => _ageRange = values),
                            ),
                            const SizedBox(height: 12),
                            _PreferenceRow(
                              icon: PhosphorIcons.user(),
                              label: l10n.preferencesGenderLabel,
                              value: _genderPreference != null
                                  ? {
                                      'female': l10n.genderFemale,
                                      'male': l10n.genderMale,
                                      'non_binary': l10n.genderNonBinary,
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
                                      'not_wants_children': l10n
                                          .preferencesFamilyNotWantsChildren,
                                      'open_to_children':
                                          l10n.preferencesFamilyOpenToChildren,
                                      'any': l10n.preferencesFamilyAny,
                                    }[_familyPreference]
                                  : null,
                              onTap: _pickFamilyPreference,
                            ),
                            _PreferenceRow(
                              icon: PhosphorIcons.cross(),
                              label: l10n.preferencesReligionLabel,
                              value: _religionController.text.isNotEmpty
                                  ? _religionController.text
                                  : null,
                              onTap: () async {
                                final result = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController(
                                      text: _religionController.text,
                                    );
                                    return AlertDialog(
                                      content: TextField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          hintText:
                                              l10n.preferencesReligionLabel,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            context,
                                          ).pop(controller.text),
                                          child: Text(l10n.onboardingContinue),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (result != null) {
                                  setState(
                                    () => _religionController.text = result,
                                  );
                                }
                              },
                            ),
                            _PreferenceRow(
                              icon: PhosphorIcons.graduationCap(),
                              label: l10n.preferencesEducationLabel,
                              value: _educationPreference != null
                                  ? {
                                      'high_school': l10n.educationHighSchool,
                                      'bachelor': l10n.educationBachelor,
                                      'master': l10n.educationMaster,
                                      'doctorate': l10n.educationDoctorate,
                                      'any': l10n.educationAny,
                                    }[_educationPreference]
                                  : null,
                              onTap: _pickEducationPreference,
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.preferencesSubmit,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.deepViolet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            Text(
              value ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
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
