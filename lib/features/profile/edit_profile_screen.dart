import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/api/api_exception.dart';
import '../../core/models/interest.dart';
import '../../core/models/my_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/interest_chip.dart';
import '../../shared/widgets/preference_row.dart';
import '../onboarding/discover/interest_labels.dart';
import '../onboarding/discover/interest_repository.dart';
import 'profile_repository.dart';

const _minimumInterests = 3;
const _maximumInterests = 5;

/// "Edit My Profile" — UI gaya onboarding (card input/bottom sheet
/// select/choice chip, sama widget dipakai `BioStepScreen`/
/// `WorkEducationStepScreen`/`InterestsStepScreen`/dst), TAPI:
/// - 1 HALAMAN scroll (bukan step onboarding terpisah dengan progress
///   counter) — semua field sekaligus, tombol Save di app bar.
/// - Nilai AWAL dari `MyProfile` (profil YANG SUDAH ADA), bukan draft
///   onboarding kosong.
/// - Submit ONLINE-FIRST ke `PATCH /me` (`ProfileRepository.
///   updateProfile()`) — TIDAK ADA optimistic write, `ProfileDatabase`
///   lokal baru ter-update kalau request sukses.
/// - Partial — cuma field yang diubah dikirim (lihat
///   `UpdateProfileRequest` backend).
///
/// SENGAJA TIDAK termasuk: foto (ganti foto profil domain terpisah,
/// belum dibangun), dating preferences (domain "My Preferences" terpisah,
/// lihat `EditPreferencesScreen`).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.initialProfile});

  final MyProfile initialProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final MyProfile _initial;
  final _bioController = TextEditingController();
  final _occupationController = TextEditingController();
  final _heightController = TextEditingController();
  String? _gender;
  String? _ethnicity;
  String? _religion;
  String? _education;
  String? _drinking;
  String? _smoking;
  String? _petPreference;
  String? _childrenPreference;
  String? _marriagePreference;
  String? _relationshipGoal;
  late Set<String> _loveLanguages;

  List<Interest> _allInterests = [];
  late Set<int> _selectedInterestIds;
  bool _isLoadingInterests = true;

  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initial = widget.initialProfile;
    _bioController.text = _initial.bio ?? '';
    _occupationController.text = _initial.occupation ?? '';
    _heightController.text = _initial.heightCm?.toString() ?? '';
    _gender = _initial.gender;
    _ethnicity = _initial.ethnicity;
    _religion = _initial.religion;
    _education = _initial.education;
    _drinking = _initial.drinking;
    _smoking = _initial.smoking;
    _petPreference = _initial.petPreference;
    _childrenPreference = _initial.childrenPreference;
    _marriagePreference = _initial.marriagePreference;
    _relationshipGoal = _initial.relationshipGoal;
    _loveLanguages = {..._initial.loveLanguages};
    _selectedInterestIds = {};
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    try {
      final interests = await interestRepository.list();
      if (mounted) {
        setState(() {
          _allInterests = interests;
          _selectedInterestIds = interests
              .where((i) => _initial.interestSlugs.contains(i.slug))
              .map((i) => i.id)
              .toSet();
          _isLoadingInterests = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingInterests = false);
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _occupationController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _bioController.text.trim().isNotEmpty &&
      int.tryParse(_heightController.text.trim()) != null &&
      _occupationController.text.trim().isNotEmpty &&
      _gender != null &&
      _ethnicity != null &&
      _religion != null &&
      _education != null &&
      _drinking != null &&
      _smoking != null &&
      _petPreference != null &&
      _childrenPreference != null &&
      _marriagePreference != null &&
      _relationshipGoal != null &&
      _loveLanguages.isNotEmpty &&
      (_selectedInterestIds.isEmpty ||
          _selectedInterestIds.length >= _minimumInterests);

  Map<String, dynamic> _changedFields() {
    final fields = <String, dynamic>{};

    final bio = _bioController.text.trim();
    if (bio != (_initial.bio ?? '')) fields['bio'] = bio;

    final occupation = _occupationController.text.trim();
    if (occupation != (_initial.occupation ?? '')) {
      fields['occupation'] = occupation;
    }

    final heightCm = int.tryParse(_heightController.text.trim());
    if (heightCm != _initial.heightCm) fields['height_cm'] = heightCm;

    if (_gender != _initial.gender) fields['gender'] = _gender;
    if (_ethnicity != _initial.ethnicity) fields['ethnicity'] = _ethnicity;
    if (_religion != _initial.religion) fields['religion'] = _religion;
    if (_education != _initial.education) fields['education'] = _education;
    if (_drinking != _initial.drinking) fields['drinking'] = _drinking;
    if (_smoking != _initial.smoking) fields['smoking'] = _smoking;
    if (_petPreference != _initial.petPreference) {
      fields['pet_preference'] = _petPreference;
    }
    if (_childrenPreference != _initial.childrenPreference) {
      fields['children_preference'] = _childrenPreference;
    }
    if (_marriagePreference != _initial.marriagePreference) {
      fields['marriage_preference'] = _marriagePreference;
    }
    if (_relationshipGoal != _initial.relationshipGoal) {
      fields['relationship_goal'] = _relationshipGoal;
    }

    final initialLoveLanguages = _initial.loveLanguages.toSet();
    if (initialLoveLanguages.length != _loveLanguages.length ||
        !initialLoveLanguages.containsAll(_loveLanguages)) {
      fields['love_languages'] = _loveLanguages.toList();
    }

    final initialInterestSlugs = _initial.interestSlugs.toSet();
    final selectedSlugs = _allInterests
        .where((i) => _selectedInterestIds.contains(i.id))
        .map((i) => i.slug)
        .toSet();
    if (!_isLoadingInterests &&
        (initialInterestSlugs.length != selectedSlugs.length ||
            !initialInterestSlugs.containsAll(selectedSlugs))) {
      fields['interests'] = _selectedInterestIds.toList();
    }

    return fields;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_isComplete) {
      setState(() => _errorText = l10n.bioAllFieldsRequiredError);
      return;
    }
    if (_isSaving) return;

    final fields = _changedFields();
    if (fields.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });
    try {
      await profileRepository.updateProfile(fields);
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorText = e.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Map<String, String> _genderOptions(AppLocalizations l10n) => {
    'female': l10n.genderFemale,
    'male': l10n.genderMale,
    'prefer_not_to_say': l10n.genderPreferNotToSay,
  };

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
    'other': l10n.ethnicityOther,
    'prefer_not_to_say': l10n.ethnicityPreferNotToSay,
  };

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
    'other': l10n.religionOther,
    'agnostic': l10n.religionAgnostic,
    'atheist': l10n.religionAtheist,
    'prefer_not_to_say': l10n.religionPreferNotToSay,
  };

  Map<String, String> _educationOptions(AppLocalizations l10n) => {
    'no_education': l10n.educationNoEducation,
    'elementary': l10n.educationElementary,
    'high_school': l10n.educationHighSchool,
    'bachelor': l10n.educationBachelor,
    'master': l10n.educationMaster,
    'doctorate': l10n.educationDoctorate,
  };

  Map<String, String> _drinkingOptions(AppLocalizations l10n) => {
    'never': l10n.drinkingNever,
    'occasionally': l10n.drinkingOccasionally,
    'socially': l10n.drinkingSocially,
    'regularly': l10n.drinkingRegularly,
    'prefer_not_to_say': l10n.drinkingPreferNotToSay,
  };

  Map<String, String> _smokingOptions(AppLocalizations l10n) => {
    'never': l10n.smokingNever,
    'occasionally': l10n.smokingOccasionally,
    'regularly': l10n.smokingRegularly,
    'prefer_not_to_say': l10n.smokingPreferNotToSay,
  };

  Map<String, String> _petOptions(AppLocalizations l10n) => {
    'love_pets': l10n.petPreferenceLovePets,
    'neutral': l10n.petPreferenceNeutral,
    'not_a_fan': l10n.petPreferenceNotAFan,
  };

  Map<String, String> _childrenOptions(AppLocalizations l10n) => {
    'want_children': l10n.childrenPreferenceWantChildren,
    'not_want_children': l10n.childrenPreferenceNotWantChildren,
    'have_children': l10n.childrenPreferenceHaveChildren,
    'open_to_children': l10n.childrenPreferenceOpenToChildren,
    'not_sure': l10n.childrenPreferenceNotSure,
    'prefer_not_to_say': l10n.childrenPreferencePreferNotToSay,
  };

  Map<String, String> _marriageOptions(AppLocalizations l10n) => {
    'want_marriage': l10n.marriagePreferenceWantMarriage,
    'open_to_marriage': l10n.marriagePreferenceOpenToMarriage,
    'not_want_marriage': l10n.marriagePreferenceNotWantMarriage,
    'not_sure': l10n.marriagePreferenceNotSure,
  };

  Map<String, String> _relationshipGoalOptions(AppLocalizations l10n) => {
    'serious_dating': l10n.relationshipGoalSeriousTitle,
    'casual_dating': l10n.relationshipGoalCasualTitle,
    'new_connections': l10n.relationshipGoalNewConnectionsTitle,
    'still_figuring_out': l10n.relationshipGoalStillFiguringOutTitle,
  };

  Map<String, String> _loveLanguageOptions(AppLocalizations l10n) => {
    'words_of_affirmation': l10n.loveLanguageWordsOfAffirmation,
    'quality_time': l10n.loveLanguageQualityTime,
    'acts_of_service': l10n.loveLanguageActsOfService,
    'physical_touch': l10n.loveLanguagePhysicalTouch,
    'gifts': l10n.loveLanguageGifts,
    'dont_know_yet': l10n.loveLanguageDontKnowYet,
  };

  Future<void> _pick(
    String? current,
    Map<String, String> options,
    ValueChanged<String> onPicked,
  ) async {
    final selected = await showSingleSelectSheet(context, options, current);
    if (selected != null) {
      setState(() {
        onPicked(selected);
        _errorText = null;
      });
    }
  }

  void _toggleInterest(int id) {
    setState(() {
      if (_selectedInterestIds.contains(id)) {
        _selectedInterestIds.remove(id);
      } else if (_selectedInterestIds.length < _maximumInterests) {
        _selectedInterestIds.add(id);
      }
      _errorText = null;
    });
  }

  List<_InterestCategoryGroup> _groupByCategory(List<Interest> interests) {
    final groups = <String, List<Interest>>{};
    for (final interest in interests) {
      groups.putIfAbsent(interest.category, () => []).add(interest);
    }
    return groups.entries
        .map((e) => _InterestCategoryGroup(category: e.key, interests: e.value))
        .toList();
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
          l10n.profileMenuMyProfile,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
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
            if (_errorText != null) ...[
              Text(
                _errorText!,
                style: const TextStyle(fontSize: 12.5, color: AppColors.error),
              ),
              const SizedBox(height: 12),
            ],
            _FieldLabel(l10n.bioFieldHint),
            const SizedBox(height: 6),
            TextField(
              controller: _bioController,
              maxLength: 300,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                counterText: '',
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _FieldLabel(l10n.workEducationOccupationLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _occupationController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _FieldLabel(l10n.bioHeightLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.bioHeightHintCm,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 8),
            PreferenceRow(
              icon: PhosphorIcons.user(),
              label: l10n.preferencesGenderLabel,
              value: _gender != null
                  ? _genderOptions(l10n)[_gender]
                  : null,
              onTap: () => _pick(
                _gender,
                _genderOptions(l10n),
                (v) => _gender = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.globe(),
              label: l10n.bioEthnicityLabel,
              value: _ethnicity != null
                  ? _ethnicityOptions(l10n)[_ethnicity]
                  : null,
              onTap: () => _pick(
                _ethnicity,
                _ethnicityOptions(l10n),
                (v) => _ethnicity = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.handsPraying(),
              label: l10n.bioReligionLabel,
              value: _religion != null
                  ? _religionOptions(l10n)[_religion]
                  : null,
              onTap: () => _pick(
                _religion,
                _religionOptions(l10n),
                (v) => _religion = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.graduationCap(),
              label: l10n.workEducationEducationLabel,
              value: _education != null
                  ? _educationOptions(l10n)[_education]
                  : null,
              onTap: () => _pick(
                _education,
                _educationOptions(l10n),
                (v) => _education = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.wine(),
              label: l10n.lifestyleDrinkingLabel,
              value: _drinking != null
                  ? _drinkingOptions(l10n)[_drinking]
                  : null,
              onTap: () => _pick(
                _drinking,
                _drinkingOptions(l10n),
                (v) => _drinking = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.cigarette(),
              label: l10n.lifestyleSmokingLabel,
              value: _smoking != null
                  ? _smokingOptions(l10n)[_smoking]
                  : null,
              onTap: () => _pick(
                _smoking,
                _smokingOptions(l10n),
                (v) => _smoking = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.pawPrint(),
              label: l10n.lifestylePetsLabel,
              value: _petPreference != null
                  ? _petOptions(l10n)[_petPreference]
                  : null,
              onTap: () => _pick(
                _petPreference,
                _petOptions(l10n),
                (v) => _petPreference = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.babyCarriage(),
              label: l10n.futureChildrenLabel,
              value: _childrenPreference != null
                  ? _childrenOptions(l10n)[_childrenPreference]
                  : null,
              onTap: () => _pick(
                _childrenPreference,
                _childrenOptions(l10n),
                (v) => _childrenPreference = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.heartStraight(),
              label: l10n.futureMarriageLabel,
              value: _marriagePreference != null
                  ? _marriageOptions(l10n)[_marriagePreference]
                  : null,
              onTap: () => _pick(
                _marriagePreference,
                _marriageOptions(l10n),
                (v) => _marriagePreference = v,
              ),
            ),
            PreferenceRow(
              icon: PhosphorIcons.heart(),
              label: l10n.myProfileRelationshipGoalLabel,
              value: _relationshipGoal != null
                  ? _relationshipGoalOptions(l10n)[_relationshipGoal]
                  : null,
              onTap: () => _pick(
                _relationshipGoal,
                _relationshipGoalOptions(l10n),
                (v) => _relationshipGoal = v,
              ),
            ),
            const SizedBox(height: 14),
            _FieldLabel(l10n.bioLoveLanguageLabel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _loveLanguageOptions(l10n).entries.map((entry) {
                final selected = _loveLanguages.contains(entry.key);
                final disabled = !selected && _loveLanguages.length >= 2;
                return InterestChip(
                  label: entry.value,
                  selected: selected,
                  disabled: disabled,
                  onTap: () => setState(() {
                    if (selected) {
                      _loveLanguages.remove(entry.key);
                    } else {
                      _loveLanguages.add(entry.key);
                    }
                    _errorText = null;
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            _FieldLabel(l10n.interestsTitle),
            const SizedBox(height: 8),
            if (_isLoadingInterests)
              const SizedBox.shrink()
            else
              for (final group in _groupByCategory(_allInterests)) ...[
                Text(
                  InterestLabels.categoryLabelFor(l10n, group.category),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final interest in group.interests)
                      InterestChip(
                        label: InterestLabels.labelFor(l10n, interest.slug),
                        selected: _selectedInterestIds.contains(interest.id),
                        disabled:
                            !_selectedInterestIds.contains(interest.id) &&
                            _selectedInterestIds.length >= _maximumInterests,
                        onTap: () => _toggleInterest(interest.id),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _InterestCategoryGroup {
  const _InterestCategoryGroup({
    required this.category,
    required this.interests,
  });

  final String category;
  final List<Interest> interests;
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }
}
