import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 5/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/06-work-education.html.
/// Occupation dan Education WAJIB diisi (tombol Skip dihapus) — keputusan
/// produk, lihat catatan di .ai/rules/architecture.md. Education pakai
/// bottom sheet select (sesuai brand-guideline §9.2c), bukan native
/// dropdown.
class WorkEducationStepScreen extends StatefulWidget {
  const WorkEducationStepScreen({super.key});

  @override
  State<WorkEducationStepScreen> createState() =>
      _WorkEducationStepScreenState();
}

class _WorkEducationStepScreenState extends State<WorkEducationStepScreen> {
  final _occupationController = TextEditingController();
  String? _selectedEducation;
  bool _isLoadingDraft = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final occupation = await DiscoverOnboardingDraftStorage.readOccupation();
    final education = await DiscoverOnboardingDraftStorage.readEducation();
    if (mounted) {
      if (occupation != null) _occupationController.text = occupation;
      setState(() {
        _selectedEducation = education;
        _isLoadingDraft = false;
      });
    }
  }

  @override
  void dispose() {
    _occupationController.dispose();
    super.dispose();
  }

  // Jenjang terendah ke tertinggi.
  Map<String, String> _educationOptions(AppLocalizations l10n) => {
    'no_education': l10n.educationNoEducation,
    'elementary': l10n.educationElementary,
    'high_school': l10n.educationHighSchool,
    'bachelor': l10n.educationBachelor,
    'master': l10n.educationMaster,
    'doctorate': l10n.educationDoctorate,
  };

  Future<void> _pickEducation() async {
    final l10n = AppLocalizations.of(context);
    final options = _educationOptions(l10n);

    final selected = await showModalBottomSheet<String>(
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
                  trailing: _selectedEducation == entry.key
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

    if (selected != null) setState(() => _selectedEducation = selected);
  }

  Future<void> _saveAndContinue() async {
    final l10n = AppLocalizations.of(context);
    final occupation = _occupationController.text.trim();

    if (occupation.isEmpty || _selectedEducation == null) {
      setState(() => _errorText = l10n.workEducationAllFieldsRequiredError);
      return;
    }

    await DiscoverOnboardingDraftStorage.saveOccupation(occupation);
    await DiscoverOnboardingDraftStorage.saveEducation(_selectedEducation);
    if (mounted) context.go('/onboarding/discover/interests');
  }

  void _backToBio() => context.go('/onboarding/discover/bio');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final educationLabel = _selectedEducation != null
        ? _educationOptions(l10n)[_selectedEducation]
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToBio();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(step: 5, totalSteps: 9, onBack: _backToBio),
              Expanded(
                child: _isLoadingDraft
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.workEducationTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.workEducationSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppTextField(
                              label: l10n.workEducationOccupationLabel,
                              hintText: l10n.workEducationOccupationHint,
                              controller: _occupationController,
                              suffixIcon: const Icon(
                                Icons.work_outline,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              l10n.workEducationEducationLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickEducation,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.school_outlined,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        educationLabel ??
                                            l10n.workEducationEducationHint,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: educationLabel != null
                                              ? AppColors.textDark
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      PhosphorIcons.caretDown(),
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorText!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.onboardingContinue,
                              onPressed: _saveAndContinue,
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
