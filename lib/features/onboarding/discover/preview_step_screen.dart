import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/storage/user_session_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/matching_loading_overlay.dart';
import '../../../shared/widgets/onboarding_step_scaffold.dart';
import '../../profile/profile_repository.dart';
import '../discover_onboarding_repository.dart';
import 'discover_onboarding_draft_storage.dart';
import 'interest_labels.dart';
import 'interest_repository.dart';

/// Step 11/11 onboarding Discover (TERAKHIR) — sumber:
/// couplivy-docs/flow/01-discover/onboarding/10-preview.html. Read-only
/// summary dari semua draft step 1-10 — TIDAK ada input baru di sini,
/// TERMASUK section "Looking for" (preferences step 10) yang sekarang
/// ditampilkan lengkap di sini juga.
///
/// Tombol "Let's Go" (dulu "Looks Good") adalah SATU-SATUNYA titik yang
/// benar-benar mengirim data ke server — memanggil `complete()` (field
/// profil, JSON) DAN `uploadPhotos()` (file foto, multipart) sekaligus.
/// Setelah keduanya sukses, draft lokal dihapus dan user masuk ke
/// Discover.
class PreviewStepScreen extends StatefulWidget {
  const PreviewStepScreen({super.key});

  @override
  State<PreviewStepScreen> createState() => _PreviewStepScreenState();
}

class _PreviewStepScreenState extends State<PreviewStepScreen> {
  bool _isLoadingDraft = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  String? _nickName;
  String? _bio;
  String? _occupation;
  String? _education;
  String? _gender;
  String? _relationshipGoal;
  List<String> _photoPaths = [];
  List<String> _interestSlugs = [];
  int? _age;
  List<String> _loveLanguages = [];

  // Step 7 (Lifestyle) & Step 8 (Future) — fact-pill di grup yang sama
  // dengan gender/relationship goal/interests (semuanya "siapa saya"),
  // beda dari section "Looking for" (preferences, "siapa yang saya
  // cari").
  String? _drinking;
  String? _smoking;
  String? _petPreference;
  String? _childrenPreference;
  String? _marriagePreference;

  // Step 10 (Preferences) — ditampilkan di section "Looking for" terpisah
  // (lihat build()), BUKAN digabung ke Wrap fact-pill yang sudah ada
  // (gender/relationship goal/interests) karena beda kategori — yang
  // satu "siapa saya", yang ini "siapa yang saya cari". SEMUA field
  // selain gender_preference multi-select (List), termasuk opsi
  // "open_for_all" yang GANTI "any"/"everyone" lama.
  int? _ageRangeMin;
  int? _ageRangeMax;
  String? _genderPreference;
  List<String> _childrenPreferences = [];
  List<String> _marriagePreferences = [];
  List<String> _ethnicityPreferences = [];
  List<String> _religionPreferences = [];
  List<String> _educationPreferences = [];
  List<String> _drinkingPreferences = [];
  List<String> _smokingPreferences = [];
  List<String> _petPreferences = [];

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  List<String> _asStringList(Object? value) =>
      (value as List<dynamic>?)?.cast<String>() ?? [];

  Future<void> _loadSummary() async {
    final nickName = await UserSessionStorage.readNickName();
    final dob = await DiscoverOnboardingDraftStorage.readDob();
    final gender = await DiscoverOnboardingDraftStorage.readGender();
    final bio = await DiscoverOnboardingDraftStorage.readBio();
    final occupation = await DiscoverOnboardingDraftStorage.readOccupation();
    final education = await DiscoverOnboardingDraftStorage.readEducation();
    final relationshipGoal =
        await DiscoverOnboardingDraftStorage.readRelationshipGoal();
    final photoPaths = await DiscoverOnboardingDraftStorage.readPhotoPaths();
    final interestIds = await DiscoverOnboardingDraftStorage.readInterestIds();
    final preferences = await DiscoverOnboardingDraftStorage.readPreferences();
    final loveLanguages =
        await DiscoverOnboardingDraftStorage.readLoveLanguages();
    final drinking = await DiscoverOnboardingDraftStorage.readDrinking();
    final smoking = await DiscoverOnboardingDraftStorage.readSmoking();
    final petPreference =
        await DiscoverOnboardingDraftStorage.readPetPreference();
    final childrenPreference =
        await DiscoverOnboardingDraftStorage.readChildrenPreference();
    final marriagePreference =
        await DiscoverOnboardingDraftStorage.readMarriagePreference();

    var interestSlugs = <String>[];
    if (interestIds.isNotEmpty) {
      try {
        final allInterests = await interestRepository.list();
        interestSlugs = allInterests
            .where((interest) => interestIds.contains(interest.id))
            .take(2)
            .map((interest) => interest.slug)
            .toList();
      } catch (_) {
        // Gagal fetch interest list bukan blocker Preview — fact-grid
        // cuma tidak tampilkan interest, sisanya tetap jalan normal.
      }
    }

    int? age;
    if (dob != null) {
      final dobDate = DateTime.parse(dob);
      final now = DateTime.now();
      age = now.year - dobDate.year;
      if (now.month < dobDate.month ||
          (now.month == dobDate.month && now.day < dobDate.day)) {
        age--;
      }
    }

    if (mounted) {
      setState(() {
        _nickName = nickName;
        _age = age;
        _gender = gender;
        _bio = bio;
        _occupation = occupation;
        _education = education;
        _relationshipGoal = relationshipGoal;
        _photoPaths = photoPaths;
        _interestSlugs = interestSlugs;
        _ageRangeMin = preferences['age_min'] as int?;
        _ageRangeMax = preferences['age_max'] as int?;
        _genderPreference = preferences['gender_preference'] as String?;
        _childrenPreferences = _asStringList(
          preferences['children_preference'],
        );
        _marriagePreferences = _asStringList(
          preferences['marriage_preference'],
        );
        _ethnicityPreferences = _asStringList(
          preferences['ethnicity_preference'],
        );
        _religionPreferences = _asStringList(
          preferences['religion_preference'],
        );
        _educationPreferences = _asStringList(
          preferences['education_preference'],
        );
        _drinkingPreferences = _asStringList(
          preferences['drinking_preference'],
        );
        _smokingPreferences = _asStringList(preferences['smoking_preference']);
        _petPreferences = _asStringList(preferences['pet_preference']);
        _loveLanguages = loveLanguages;
        _drinking = drinking;
        _smoking = smoking;
        _petPreference = petPreference;
        _childrenPreference = childrenPreference;
        _marriagePreference = marriagePreference;
        _isLoadingDraft = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    // Modal loading (2 heart "matching") menutupi seluruh layar selama
    // request — menggantikan CircularProgressIndicator inline yang lama
    // di bottomButton. Non-dismissible, ditutup manual di bawah baik di
    // jalur sukses maupun error.
    unawaited(MatchingLoadingOverlay.show(context));

    try {
      final fields = await DiscoverOnboardingDraftStorage.readAllForSubmit();
      await discoverOnboardingRepository.complete(fields);

      if (_photoPaths.isNotEmpty) {
        await discoverOnboardingRepository.uploadPhotos(_photoPaths);
      }

      await DiscoverOnboardingDraftStorage.clear();
      // Isi cache profil lokal (halaman Profile/Account baca dari sini,
      // BUKAN network call tiap dibuka) — kegagalan di sini TIDAK
      // menggagalkan submit (sudah lanjut ke Discover), cache akan
      // terisi lagi begitu ProfileScreen dibuka pertama kali (fallback
      // fetch kalau cache kosong).
      try {
        await profileRepository.syncMyProfile();
      } catch (_) {
        // Diabaikan sengaja — lihat komentar di atas.
      }

      if (mounted) {
        // Tutup modal SEBELUM context.go() — go() me-reset seluruh
        // stack navigator (lihat .ai/rules/architecture.md), jadi
        // dialog route yang belum di-pop bisa nyangkut/exception kalau
        // stack di baliknya sudah diganti duluan.
        MatchingLoadingOverlay.hide(context);
        context.go('/main');
      }
    } on ApiException catch (e) {
      if (mounted) {
        MatchingLoadingOverlay.hide(context);
        setState(() {
          _errorMessage = e.message;
          _isSubmitting = false;
        });
      }
    } catch (_) {
      if (mounted) {
        MatchingLoadingOverlay.hide(context);
        setState(() {
          _errorMessage = AppLocalizations.of(context).previewSubmitError;
          _isSubmitting = false;
        });
      }
    }
  }

  void _backToPreferences() => context.go('/onboarding/discover/preferences');

  String? _genderLabel(AppLocalizations l10n) => switch (_gender) {
    'female' => l10n.genderFemale,
    'male' => l10n.genderMale,
    'prefer_not_to_say' => l10n.genderPreferNotToSay,
    _ => null,
  };

  String? _relationshipGoalLabel(AppLocalizations l10n) =>
      switch (_relationshipGoal) {
        'serious_dating' => l10n.relationshipGoalSeriousTitle,
        'casual_dating' => l10n.relationshipGoalCasualTitle,
        'new_connections' => l10n.relationshipGoalNewConnectionsTitle,
        'still_figuring_out' => l10n.relationshipGoalStillFiguringOutTitle,
        _ => null,
      };

  // --- Label untuk step 7 (Lifestyle), 8 (Future), dan Love Language ---

  String _loveLanguageLabel(AppLocalizations l10n, String key) => switch (key) {
    'words_of_affirmation' => l10n.loveLanguageWordsOfAffirmation,
    'quality_time' => l10n.loveLanguageQualityTime,
    'acts_of_service' => l10n.loveLanguageActsOfService,
    'physical_touch' => l10n.loveLanguagePhysicalTouch,
    'gifts' => l10n.loveLanguageGifts,
    _ => l10n.loveLanguageDontKnowYet,
  };

  String? _drinkingLabel(AppLocalizations l10n) => switch (_drinking) {
    'never' => l10n.drinkingNever,
    'occasionally' => l10n.drinkingOccasionally,
    'socially' => l10n.drinkingSocially,
    'regularly' => l10n.drinkingRegularly,
    'prefer_not_to_say' => l10n.drinkingPreferNotToSay,
    _ => null,
  };

  String? _smokingLabel(AppLocalizations l10n) => switch (_smoking) {
    'never' => l10n.smokingNever,
    'occasionally' => l10n.smokingOccasionally,
    'regularly' => l10n.smokingRegularly,
    'prefer_not_to_say' => l10n.smokingPreferNotToSay,
    _ => null,
  };

  String? _petPreferenceLabel(AppLocalizations l10n) =>
      switch (_petPreference) {
        'love_pets' => l10n.petPreferenceLovePets,
        'neutral' => l10n.petPreferenceNeutral,
        'not_a_fan' => l10n.petPreferenceNotAFan,
        _ => null,
      };

  String? _childrenPreferenceLabel(AppLocalizations l10n) =>
      switch (_childrenPreference) {
        'want_children' => l10n.childrenPreferenceWantChildren,
        'not_want_children' => l10n.childrenPreferenceNotWantChildren,
        'have_children' => l10n.childrenPreferenceHaveChildren,
        'open_to_children' => l10n.childrenPreferenceOpenToChildren,
        'not_sure' => l10n.childrenPreferenceNotSure,
        'prefer_not_to_say' => l10n.childrenPreferencePreferNotToSay,
        _ => null,
      };

  String? _marriagePreferenceLabel(AppLocalizations l10n) =>
      switch (_marriagePreference) {
        'want_marriage' => l10n.marriagePreferenceWantMarriage,
        'open_to_marriage' => l10n.marriagePreferenceOpenToMarriage,
        'not_want_marriage' => l10n.marriagePreferenceNotWantMarriage,
        'not_sure' => l10n.marriagePreferenceNotSure,
        _ => null,
      };

  // --- Label untuk section "Looking for" (preferences step 10) ---
  // SEMUA field multi-select selain gender_preference — "open_for_all"
  // GANTI "any"/"everyone" lama, exclusive (lihat PreferencesStepScreen).

  String? _genderPreferenceLabel(AppLocalizations l10n) =>
      switch (_genderPreference) {
        'female' => l10n.genderFemale,
        'male' => l10n.genderMale,
        'open_for_all' => l10n.preferencesOpenForAll,
        _ => null,
      };

  String _childrenOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'want_children' => l10n.childrenPreferenceWantChildren,
        'not_want_children' => l10n.childrenPreferenceNotWantChildren,
        'have_children' => l10n.childrenPreferenceHaveChildren,
        'open_to_children' => l10n.childrenPreferenceOpenToChildren,
        'not_sure' => l10n.childrenPreferenceNotSure,
        _ => l10n.preferencesOpenForAll,
      };

  String _marriageOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'want_marriage' => l10n.marriagePreferenceWantMarriage,
        'open_to_marriage' => l10n.marriagePreferenceOpenToMarriage,
        'not_want_marriage' => l10n.marriagePreferenceNotWantMarriage,
        'not_sure' => l10n.marriagePreferenceNotSure,
        _ => l10n.preferencesOpenForAll,
      };

  String _ethnicityOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
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
        _ => l10n.preferencesOpenForAll,
      };

  String _religionOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'islam' => l10n.religionIslam,
        'christianity' => l10n.religionChristianity,
        'catholic' => l10n.religionCatholic,
        'hinduism' => l10n.religionHinduism,
        'buddhism' => l10n.religionBuddhism,
        'confucianism' => l10n.religionConfucianism,
        'judaism' => l10n.religionJudaism,
        'sikhism' => l10n.religionSikhism,
        'taoism' => l10n.religionTaoism,
        'agnostic' => l10n.religionAgnostic,
        'atheist' => l10n.religionAtheist,
        _ => l10n.preferencesOpenForAll,
      };

  String _educationOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'no_education' => l10n.educationNoEducation,
        'elementary' => l10n.educationElementary,
        'high_school' => l10n.educationHighSchool,
        'bachelor' => l10n.educationBachelor,
        'master' => l10n.educationMaster,
        'doctorate' => l10n.educationDoctorate,
        _ => l10n.preferencesOpenForAll,
      };

  String _drinkingOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'never' => l10n.drinkingNever,
        'occasionally' => l10n.drinkingOccasionally,
        'socially' => l10n.drinkingSocially,
        'regularly' => l10n.drinkingRegularly,
        _ => l10n.preferencesOpenForAll,
      };

  String _smokingOptionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'never' => l10n.smokingNever,
        'occasionally' => l10n.smokingOccasionally,
        'regularly' => l10n.smokingRegularly,
        _ => l10n.preferencesOpenForAll,
      };

  String _petOptionLabel(AppLocalizations l10n, String key) => switch (key) {
    'love_pets' => l10n.petPreferenceLovePets,
    'not_a_fan' => l10n.petPreferenceNotAFan,
    _ => l10n.preferencesOpenForAll,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSubmitting) _backToPreferences();
      },
      child: OnboardingStepScaffold(
        step: 11,
        totalSteps: 11,
        onBack: _backToPreferences,
        errorText: _errorMessage,
        // Loading sekarang ditampilkan lewat MatchingLoadingOverlay (modal
        // full-screen), BUKAN CircularProgressIndicator inline lagi —
        // tombol cukup disabled saat submitting, tanpa indikator dobel.
        bottomButton: AppButton(
          label: l10n.previewSubmit,
          onPressed: _isSubmitting ? null : _submit,
        ),
        body: _isLoadingDraft
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.previewTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.previewSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.lilac.withValues(alpha: 0.2),
                      backgroundImage: _photoPaths.isNotEmpty
                          ? FileImage(File(_photoPaths.first))
                          : null,
                      child: _photoPaths.isEmpty
                          ? Icon(
                              PhosphorIcons.user(),
                              size: 36,
                              color: AppColors.deepViolet,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_nickName != null && _age != null)
                    Center(
                      child: Text(
                        l10n.previewNameAge(_nickName!, _age!),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  if (_occupation != null || _education != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          [
                            _occupation,
                            _education,
                          ].whereType<String>().join(' · '),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  if (_bio != null && _bio!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      _bio!,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textDark,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_genderLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.genderFemale(),
                          label: _genderLabel(l10n)!,
                        ),
                      if (_relationshipGoalLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.heart(),
                          label: _relationshipGoalLabel(l10n)!,
                        ),
                      for (final slug in _interestSlugs)
                        _FactPill(
                          icon: PhosphorIcons.sparkle(),
                          label: InterestLabels.labelFor(l10n, slug),
                        ),
                      if (_drinkingLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.wine(),
                          label: _drinkingLabel(l10n)!,
                        ),
                      if (_smokingLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.cigarette(),
                          label: _smokingLabel(l10n)!,
                        ),
                      if (_petPreferenceLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.pawPrint(),
                          label: _petPreferenceLabel(l10n)!,
                        ),
                      if (_childrenPreferenceLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.babyCarriage(),
                          label: _childrenPreferenceLabel(l10n)!,
                        ),
                      if (_marriagePreferenceLabel(l10n) != null)
                        _FactPill(
                          icon: PhosphorIcons.heartStraight(),
                          label: _marriagePreferenceLabel(l10n)!,
                        ),
                      for (final key in _loveLanguages)
                        _FactPill(
                          icon: PhosphorIcons.chatCircleDots(),
                          label: _loveLanguageLabel(l10n, key),
                        ),
                    ],
                  ),
                  // Section terpisah — preferences step 10 ("siapa yang
                  // saya cari"), BEDA kategori dari fact-pill di atas
                  // ("siapa saya"). Tampilkan SEMUA yang sudah dipilih —
                  // SEMUA field multi-select (join koma, sama pola
                  // _summaryFor di PreferencesStepScreen).
                  if (_ageRangeMin != null ||
                      _genderPreferenceLabel(l10n) != null ||
                      _childrenPreferences.isNotEmpty ||
                      _marriagePreferences.isNotEmpty ||
                      _ethnicityPreferences.isNotEmpty ||
                      _religionPreferences.isNotEmpty ||
                      _educationPreferences.isNotEmpty ||
                      _drinkingPreferences.isNotEmpty ||
                      _smokingPreferences.isNotEmpty ||
                      _petPreferences.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      l10n.previewLookingForTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (_ageRangeMin != null && _ageRangeMax != null)
                          _FactPill(
                            icon: PhosphorIcons.calendarBlank(),
                            label: l10n.preferencesAgeRangeLabel(
                              _ageRangeMin!,
                              _ageRangeMax!,
                            ),
                          ),
                        if (_genderPreferenceLabel(l10n) != null)
                          _FactPill(
                            icon: PhosphorIcons.user(),
                            label: _genderPreferenceLabel(l10n)!,
                          ),
                        if (_childrenPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.babyCarriage(),
                            label: _childrenPreferences
                                .map((key) => _childrenOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_marriagePreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.heartStraight(),
                            label: _marriagePreferences
                                .map((key) => _marriageOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_ethnicityPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.globe(),
                            label: _ethnicityPreferences
                                .map((key) => _ethnicityOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_religionPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.handsPraying(),
                            label: _religionPreferences
                                .map((key) => _religionOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_educationPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.graduationCap(),
                            label: _educationPreferences
                                .map((key) => _educationOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_drinkingPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.wine(),
                            label: _drinkingPreferences
                                .map((key) => _drinkingOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_smokingPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.cigarette(),
                            label: _smokingPreferences
                                .map((key) => _smokingOptionLabel(l10n, key))
                                .join(', '),
                          ),
                        if (_petPreferences.isNotEmpty)
                          _FactPill(
                            icon: PhosphorIcons.pawPrint(),
                            label: _petPreferences
                                .map((key) => _petOptionLabel(l10n, key))
                                .join(', '),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _FactPill extends StatelessWidget {
  const _FactPill({required this.icon, required this.label});

  final PhosphorIconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.deepViolet),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}
