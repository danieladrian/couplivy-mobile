import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/gateway_option_card.dart';
import 'providers/gateway_choice_controller.dart';

/// Step 1 onboarding — sumber:
/// couplivy-docs/flow/00-auth/05-gateway-choice.html. Muncul SEKALI
/// setelah Sign Up/Login pertama kali (bukan tiap login), sebelum masuk ke
/// pengisian profil (Discover) atau pairing (Together).
///
/// "Sudah punya pasangan" (mode=together) DI-DISABLE dulu — backend
/// menolak mode itu (lihat GatewayChoiceRequest), UI-nya tetap tampil
/// supaya user tahu fitur itu akan ada, cuma belum bisa dipilih.
class GatewayChoiceScreen extends ConsumerWidget {
  const GatewayChoiceScreen({super.key});

  void _chooseDiscover(WidgetRef ref) {
    ref.read(gatewayChoiceProvider.notifier).choose('discover');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(gatewayChoiceProvider);
    final isLoading = state is GatewayChoiceLoading;

    ref.listen(gatewayChoiceProvider, (previous, next) {
      if (next is GatewayChoiceSuccess) {
        context.go('/onboarding/discover/name');
      }

      if (next is GatewayChoiceError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.message)));
      }
    });

    return PopScope(
      // Gateway Choice adalah titik tanpa jalan kembali dari Sign Up/Login
      // (bukan halaman yang bisa di-skip dengan back) — sama alasan
      // SplashScreen tidak punya tombol back.
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.gatewayChoiceTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.playfairDisplay(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.gatewayChoiceSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                GatewayOptionCard(
                  icon: PhosphorIcons.heart(),
                  iconBackgroundColor: AppColors.lilac.withValues(alpha: 0.18),
                  title: l10n.gatewayChoiceDiscoverTitle,
                  description: l10n.gatewayChoiceDiscoverDescription,
                  ctaLabel: l10n.gatewayChoiceDiscoverCta,
                  onTap: isLoading ? null : () => _chooseDiscover(ref),
                ),
                const SizedBox(height: 16),
                GatewayOptionCard(
                  icon: PhosphorIcons.handHeart(),
                  iconBackgroundColor: AppColors.peach.withValues(alpha: 0.3),
                  title: l10n.gatewayChoiceTogetherTitle,
                  description: l10n.gatewayChoiceTogetherDescription,
                  ctaLabel: l10n.gatewayChoiceTogetherCta,
                  enabled: false,
                  onTap: null,
                ),
                if (isLoading) ...[
                  const SizedBox(height: 24),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
