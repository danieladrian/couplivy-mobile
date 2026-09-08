import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

const _maxBioLength = 300;

/// Step 4/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/05-bio.html, diperluas jadi
/// "Detail Diri" dengan height/ethnicity/wants_children (field yang ADA
/// di skema `profiles` tapi tidak ada di desain HTML asli — keputusan
/// produk, lihat .ai/rules/architecture.md backend). Semua field di sini
/// OPTIONAL (ada tombol Skip).
class BioStepScreen extends StatefulWidget {
  const BioStepScreen({super.key});

  @override
  State<BioStepScreen> createState() => _BioStepScreenState();
}

class _BioStepScreenState extends State<BioStepScreen> {
  final _bioController = TextEditingController();
  final _heightController = TextEditingController();
  final _ethnicityController = TextEditingController();
  bool? _wantsChildren;
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _bioController.addListener(() => setState(() {}));
  }

  Future<void> _loadDraft() async {
    final bio = await DiscoverOnboardingDraftStorage.readBio();
    final height = await DiscoverOnboardingDraftStorage.readHeightCm();
    final ethnicity = await DiscoverOnboardingDraftStorage.readEthnicity();
    final wantsChildren =
        await DiscoverOnboardingDraftStorage.readWantsChildren();

    if (mounted) {
      if (bio != null) _bioController.text = bio;
      if (height != null) _heightController.text = height.toString();
      if (ethnicity != null) _ethnicityController.text = ethnicity;
      setState(() {
        _wantsChildren = wantsChildren;
        _isLoadingDraft = false;
      });
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    await DiscoverOnboardingDraftStorage.saveBio(_bioController.text.trim());
    await DiscoverOnboardingDraftStorage.saveHeightCm(
      int.tryParse(_heightController.text.trim()),
    );
    await DiscoverOnboardingDraftStorage.saveEthnicity(
      _ethnicityController.text.trim(),
    );
    await DiscoverOnboardingDraftStorage.saveWantsChildren(_wantsChildren);
    if (mounted) context.go('/onboarding/discover/work-education');
  }

  void _backToPhotos() => context.go('/onboarding/discover/photos');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bioLength = _bioController.text.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToPhotos();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 4,
                totalSteps: 9,
                onBack: _backToPhotos,
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
                              l10n.bioTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.bioSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Stack(
                              children: [
                                TextField(
                                  controller: _bioController,
                                  maxLength: _maxBioLength,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: l10n.bioFieldHint,
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: '',
                                    contentPadding: const EdgeInsets.all(16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.md,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 8,
                                  child: Text(
                                    l10n.bioCharCount(bioLength, _maxBioLength),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: bioLength > _maxBioLength * 0.9
                                          ? AppColors.warning
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              label: l10n.bioHeightLabel,
                              hintText: l10n.bioHeightHint,
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              label: l10n.bioEthnicityLabel,
                              hintText: l10n.bioEthnicityHint,
                              controller: _ethnicityController,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.bioWantsChildrenLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenYes,
                                  selected: _wantsChildren == true,
                                  onSelected: () =>
                                      setState(() => _wantsChildren = true),
                                ),
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenNo,
                                  selected: _wantsChildren == false,
                                  onSelected: () =>
                                      setState(() => _wantsChildren = false),
                                ),
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenNotSure,
                                  selected: _wantsChildren == null,
                                  onSelected: () =>
                                      setState(() => _wantsChildren = null),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _saveAndContinue,
                                  child: Text(l10n.onboardingSkip),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 160,
                                  child: AppButton(
                                    label: l10n.onboardingContinue,
                                    onPressed: _saveAndContinue,
                                  ),
                                ),
                              ],
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

class _ChoiceChipOption extends StatelessWidget {
  const _ChoiceChipOption({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.lilac.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: selected ? AppColors.deepViolet : AppColors.textDark,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        fontSize: 13,
      ),
      side: BorderSide(color: selected ? AppColors.lilac : AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      backgroundColor: Colors.white,
    );
  }
}
