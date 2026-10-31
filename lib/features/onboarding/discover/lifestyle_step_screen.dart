import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_scaffold.dart';
import '../../../shared/widgets/preference_row.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 7/11 onboarding Discover — BARU, TIDAK ADA di desain HTML asli
/// (keputusan produk). Drinking/Smoking/Pets, SEMUA WAJIB diisi (tanpa
/// Skip, konsisten step lain) — Continue disabled sampai ketiganya
/// terpilih.
class LifestyleStepScreen extends StatefulWidget {
  const LifestyleStepScreen({super.key});

  @override
  State<LifestyleStepScreen> createState() => _LifestyleStepScreenState();
}

class _LifestyleStepScreenState extends State<LifestyleStepScreen> {
  String? _drinking;
  String? _smoking;
  String? _petPreference;
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final drinking = await DiscoverOnboardingDraftStorage.readDrinking();
    final smoking = await DiscoverOnboardingDraftStorage.readSmoking();
    final petPreference =
        await DiscoverOnboardingDraftStorage.readPetPreference();
    if (mounted) {
      setState(() {
        _drinking = drinking;
        _smoking = smoking;
        _petPreference = petPreference;
        _isLoadingDraft = false;
      });
    }
  }

  bool get _isComplete =>
      _drinking != null && _smoking != null && _petPreference != null;

  Future<void> _submit() async {
    if (!_isComplete) return;

    await DiscoverOnboardingDraftStorage.saveDrinking(_drinking!);
    await DiscoverOnboardingDraftStorage.saveSmoking(_smoking!);
    await DiscoverOnboardingDraftStorage.savePetPreference(_petPreference!);
    if (mounted) context.go('/onboarding/discover/future');
  }

  void _backToInterests() => context.go('/onboarding/discover/interests');

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

  Map<String, String> _petPreferenceOptions(AppLocalizations l10n) => {
    'love_pets': l10n.petPreferenceLovePets,
    'neutral': l10n.petPreferenceNeutral,
    'not_a_fan': l10n.petPreferenceNotAFan,
  };

  Future<void> _pickDrinking() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showSingleSelectSheet(
      context,
      _drinkingOptions(l10n),
      _drinking,
    );
    if (selected != null) setState(() => _drinking = selected);
  }

  Future<void> _pickSmoking() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showSingleSelectSheet(
      context,
      _smokingOptions(l10n),
      _smoking,
    );
    if (selected != null) setState(() => _smoking = selected);
  }

  Future<void> _pickPetPreference() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showSingleSelectSheet(
      context,
      _petPreferenceOptions(l10n),
      _petPreference,
    );
    if (selected != null) setState(() => _petPreference = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToInterests();
      },
      child: OnboardingStepScaffold(
        step: 7,
        totalSteps: 11,
        onBack: _backToInterests,
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
                    l10n.lifestyleTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.lifestyleSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PreferenceRow(
                    icon: PhosphorIcons.wine(),
                    label: l10n.lifestyleDrinkingLabel,
                    value: _drinking != null
                        ? _drinkingOptions(l10n)[_drinking]
                        : null,
                    onTap: _pickDrinking,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.cigarette(),
                    label: l10n.lifestyleSmokingLabel,
                    value: _smoking != null
                        ? _smokingOptions(l10n)[_smoking]
                        : null,
                    onTap: _pickSmoking,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.pawPrint(),
                    label: l10n.lifestylePetsLabel,
                    value: _petPreference != null
                        ? _petPreferenceOptions(l10n)[_petPreference]
                        : null,
                    onTap: _pickPetPreference,
                  ),
                ],
              ),
      ),
    );
  }
}
