import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import '../../../shared/widgets/selectable_option_card.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 7/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/08-relationship-goal.html.
/// Required, tidak ada tombol Skip — memilih salah satu opsi langsung
/// lanjut ke step berikutnya.
class RelationshipGoalStepScreen extends StatefulWidget {
  const RelationshipGoalStepScreen({super.key});

  @override
  State<RelationshipGoalStepScreen> createState() =>
      _RelationshipGoalStepScreenState();
}

class _RelationshipGoalStepScreenState
    extends State<RelationshipGoalStepScreen> {
  String? _selectedGoal;
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final saved = await DiscoverOnboardingDraftStorage.readRelationshipGoal();
    if (saved != null && mounted) setState(() => _selectedGoal = saved);
    if (mounted) setState(() => _isLoadingDraft = false);
  }

  Future<void> _select(String goal) async {
    setState(() => _selectedGoal = goal);
    await DiscoverOnboardingDraftStorage.saveRelationshipGoal(goal);
    if (mounted) context.go('/onboarding/discover/preferences');
  }

  void _backToInterests() => context.go('/onboarding/discover/interests');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToInterests();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 7,
                totalSteps: 9,
                onBack: _backToInterests,
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
                              l10n.relationshipGoalTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.relationshipGoalSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SelectableOptionCard(
                              icon: PhosphorIcons.heart(),
                              iconBackgroundColor: AppColors.error.withValues(
                                alpha: 0.15,
                              ),
                              title: l10n.relationshipGoalSeriousTitle,
                              description:
                                  l10n.relationshipGoalSeriousDescription,
                              selected: _selectedGoal == 'serious_relationship',
                              onTap: () => _select('serious_relationship'),
                            ),
                            const SizedBox(height: 12),
                            SelectableOptionCard(
                              icon: PhosphorIcons.sparkle(),
                              iconBackgroundColor: AppColors.peach.withValues(
                                alpha: 0.3,
                              ),
                              title: l10n.relationshipGoalCasualTitle,
                              description:
                                  l10n.relationshipGoalCasualDescription,
                              selected: _selectedGoal == 'casual_dating',
                              onTap: () => _select('casual_dating'),
                            ),
                            const SizedBox(height: 12),
                            SelectableOptionCard(
                              icon: PhosphorIcons.handshake(),
                              iconBackgroundColor: AppColors.dustyBlue
                                  .withValues(alpha: 0.2),
                              title: l10n.relationshipGoalFriendshipTitle,
                              description:
                                  l10n.relationshipGoalFriendshipDescription,
                              selected: _selectedGoal == 'friendship',
                              onTap: () => _select('friendship'),
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
