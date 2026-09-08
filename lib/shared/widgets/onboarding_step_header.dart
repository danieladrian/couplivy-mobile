import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';

/// Header step onboarding — back arrow + progress bar + label "x/total".
/// Dipakai di semua step Discover (Name, DOB, Gender, dst — 10 step total)
/// dan berpotensi Together nanti. Sumber desain:
/// couplivy-docs/flow/01-discover/onboarding/*.html (`.screen-header` +
/// `.progress-bar`).
class OnboardingStepHeader extends StatelessWidget {
  const OnboardingStepHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
  });

  /// 1-indexed — step 1 dari totalSteps, BUKAN 0-indexed.
  final int step;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 20, 4),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: Icon(PhosphorIcons.arrowLeft())),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.deepViolet),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$step/$totalSteps',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
