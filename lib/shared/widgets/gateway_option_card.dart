import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Kartu pilihan besar, full-tap — dipakai di Gateway Choice (dan
/// berpotensi step onboarding lain yang butuh pola "pilih salah satu dari
/// beberapa opsi besar"), makanya ditaruh di shared/, bukan di
/// features/onboarding/. Sumber desain:
/// couplivy-docs/flow/00-auth/05-gateway-choice.html (.option-card).
class GatewayOptionCard extends StatelessWidget {
  const GatewayOptionCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.ctaLabel,
    required this.onTap,
    this.enabled = true,
  });

  final PhosphorIconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String ctaLabel;
  final VoidCallback? onTap;

  /// Opsi "Sudah Punya Pasangan" di-disable dulu (backend menolak
  /// mode=together) — tetap tampil supaya user tahu fitur itu ada, cuma
  /// tidak bisa ditekan, bukan dihilangkan sama sekali.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final content = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.deepViolet, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ctaLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.deepViolet,
              ),
            ),
          ],
        ),
      ),
    );

    if (!enabled) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: content,
    );
  }
}
