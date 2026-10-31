import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_scaffold.dart';
import '../../../shared/widgets/preference_row.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 8/11 onboarding Discover — BARU, TIDAK ADA di desain HTML asli
/// (keputusan produk). Children/Marriage, SEMUA WAJIB diisi (tanpa
/// Skip, konsisten step lain) — Continue disabled sampai keduanya
/// terpilih.
///
/// `children_preference` di sini GANTI TOTAL `wants_children` lama yang
/// dulu ada di step Bio (boolean 3 pilihan) — sekarang 6 opsi, lihat
/// .ai/rules/architecture.md backend.
class FutureStepScreen extends StatefulWidget {
  const FutureStepScreen({super.key});

  @override
  State<FutureStepScreen> createState() => _FutureStepScreenState();
}

class _FutureStepScreenState extends State<FutureStepScreen> {
  String? _childrenPreference;
  String? _marriagePreference;
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final childrenPreference =
        await DiscoverOnboardingDraftStorage.readChildrenPreference();
    final marriagePreference =
        await DiscoverOnboardingDraftStorage.readMarriagePreference();
    if (mounted) {
      setState(() {
        _childrenPreference = childrenPreference;
        _marriagePreference = marriagePreference;
        _isLoadingDraft = false;
      });
    }
  }

  bool get _isComplete =>
      _childrenPreference != null && _marriagePreference != null;

  Future<void> _submit() async {
    if (!_isComplete) return;

    await DiscoverOnboardingDraftStorage.saveChildrenPreference(
      _childrenPreference!,
    );
    await DiscoverOnboardingDraftStorage.saveMarriagePreference(
      _marriagePreference!,
    );
    if (mounted) context.go('/onboarding/discover/relationship-goal');
  }

  void _backToLifestyle() => context.go('/onboarding/discover/lifestyle');

  Map<String, String> _childrenPreferenceOptions(AppLocalizations l10n) => {
    'want_children': l10n.childrenPreferenceWantChildren,
    'not_want_children': l10n.childrenPreferenceNotWantChildren,
    'have_children': l10n.childrenPreferenceHaveChildren,
    'open_to_children': l10n.childrenPreferenceOpenToChildren,
    'not_sure': l10n.childrenPreferenceNotSure,
    'prefer_not_to_say': l10n.childrenPreferencePreferNotToSay,
  };

  Map<String, String> _marriagePreferenceOptions(AppLocalizations l10n) => {
    'want_marriage': l10n.marriagePreferenceWantMarriage,
    'open_to_marriage': l10n.marriagePreferenceOpenToMarriage,
    'not_want_marriage': l10n.marriagePreferenceNotWantMarriage,
    'not_sure': l10n.marriagePreferenceNotSure,
  };

  Future<void> _pickChildrenPreference() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showSingleSelectSheet(
      context,
      _childrenPreferenceOptions(l10n),
      _childrenPreference,
    );
    if (selected != null) setState(() => _childrenPreference = selected);
  }

  Future<void> _pickMarriagePreference() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showSingleSelectSheet(
      context,
      _marriagePreferenceOptions(l10n),
      _marriagePreference,
    );
    if (selected != null) setState(() => _marriagePreference = selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToLifestyle();
      },
      child: OnboardingStepScaffold(
        step: 8,
        totalSteps: 11,
        onBack: _backToLifestyle,
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
                    l10n.futureTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.futureSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PreferenceRow(
                    icon: PhosphorIcons.babyCarriage(),
                    label: l10n.futureChildrenLabel,
                    value: _childrenPreference != null
                        ? _childrenPreferenceOptions(l10n)[_childrenPreference]
                        : null,
                    onTap: _pickChildrenPreference,
                  ),
                  PreferenceRow(
                    icon: PhosphorIcons.heartStraight(),
                    label: l10n.futureMarriageLabel,
                    value: _marriagePreference != null
                        ? _marriagePreferenceOptions(l10n)[_marriagePreference]
                        : null,
                    onTap: _pickMarriagePreference,
                  ),
                ],
              ),
      ),
    );
  }
}
