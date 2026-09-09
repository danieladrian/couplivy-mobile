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
import '../../../shared/widgets/onboarding_step_header.dart';
import '../discover_onboarding_repository.dart';
import 'discover_onboarding_draft_storage.dart';
import 'interest_labels.dart';
import 'interest_repository.dart';

/// Step 9/9 onboarding Discover (TERAKHIR) — sumber:
/// couplivy-docs/flow/01-discover/onboarding/10-preview.html. Read-only
/// summary dari semua draft step 1-8 — TIDAK ada input baru di sini.
///
/// Tombol "Looks Good" adalah SATU-SATUNYA titik yang benar-benar
/// mengirim data ke server — memanggil `complete()` (field profil, JSON)
/// DAN `uploadPhotos()` (file foto, multipart) sekaligus. Setelah
/// keduanya sukses, draft lokal dihapus dan user masuk ke Discover.
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

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

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
        _isLoadingDraft = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final fields = await DiscoverOnboardingDraftStorage.readAllForSubmit();
      await discoverOnboardingRepository.complete(fields);

      if (_photoPaths.isNotEmpty) {
        await discoverOnboardingRepository.uploadPhotos(_photoPaths);
      }

      await DiscoverOnboardingDraftStorage.clear();

      if (mounted) context.go('/discover');
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isSubmitting = false;
        });
      }
    } catch (_) {
      if (mounted) {
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
    _ => null,
  };

  String? _relationshipGoalLabel(AppLocalizations l10n) =>
      switch (_relationshipGoal) {
        'serious_relationship' => l10n.relationshipGoalSeriousTitle,
        'casual_dating' => l10n.relationshipGoalCasualTitle,
        'friendship' => l10n.relationshipGoalFriendshipTitle,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSubmitting) _backToPreferences();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 9,
                totalSteps: 9,
                onBack: _backToPreferences,
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
                                backgroundColor: AppColors.lilac.withValues(
                                  alpha: 0.2,
                                ),
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
                              ],
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.previewSubmit,
                              onPressed: _isSubmitting ? null : _submit,
                            ),
                            if (_isSubmitting) ...[
                              const SizedBox(height: 16),
                              const Center(child: CircularProgressIndicator()),
                            ],
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
