import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import '../../../shared/widgets/selectable_option_card.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 2/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/03-gender.html. Required,
/// tidak ada tombol Skip — memilih salah satu opsi langsung lanjut ke
/// step berikutnya (tidak ada tombol Continue terpisah, sama pola
/// GatewayChoiceScreen).
///
/// Cuma 2 opsi (Female/Male) — keputusan produk, HTML sumber aslinya
/// punya Non-binary juga tapi sengaja dihapus dari scope sekarang.
class GenderStepScreen extends StatefulWidget {
  const GenderStepScreen({super.key});

  @override
  State<GenderStepScreen> createState() => _GenderStepScreenState();
}

class _GenderStepScreenState extends State<GenderStepScreen> {
  String? _selectedGender;
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final saved = await DiscoverOnboardingDraftStorage.readGender();
    if (saved != null && mounted) setState(() => _selectedGender = saved);
    if (mounted) setState(() => _isLoadingDraft = false);
  }

  Future<void> _select(String gender) async {
    setState(() => _selectedGender = gender);
    await DiscoverOnboardingDraftStorage.saveGender(gender);
    if (mounted) context.go('/onboarding/discover/photos');
  }

  void _backToDob() => context.go('/onboarding/discover/dob');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToDob();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(step: 2, totalSteps: 9, onBack: _backToDob),
              Expanded(
                child: _isLoadingDraft
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.genderTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.genderSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SelectableOptionCard(
                              icon: PhosphorIcons.genderFemale(),
                              iconBackgroundColor: AppColors.lilac.withValues(
                                alpha: 0.18,
                              ),
                              title: l10n.genderFemale,
                              selected: _selectedGender == 'female',
                              onTap: () => _select('female'),
                            ),
                            const SizedBox(height: 12),
                            SelectableOptionCard(
                              icon: PhosphorIcons.genderMale(),
                              iconBackgroundColor: AppColors.dustyBlue
                                  .withValues(alpha: 0.18),
                              title: l10n.genderMale,
                              selected: _selectedGender == 'male',
                              onTap: () => _select('male'),
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
