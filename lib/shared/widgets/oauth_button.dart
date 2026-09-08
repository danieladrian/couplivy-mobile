import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Tombol "Continue with Apple/Google" — sinkron dengan `.oauth-btn` di
/// couplivy-docs/flow/_shared/phone-shell.css.
///
/// CATATAN: belum fungsional — GOOGLE_CLIENT_ID/APPLE_* di backend masih
/// kosong (perlu setup Google Cloud Console + Apple Developer account dulu,
/// effort terpisah). onPressed sementara tampilkan "coming soon" lewat
/// callback yang di-pass dari screen pemanggil.
class OAuthButton extends StatelessWidget {
  const OAuthButton({
    super.key,
    required this.label,
    required this.provider,
    required this.onPressed,
  });

  final String label;
  final OAuthProviderKind provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        icon: Icon(
          provider == OAuthProviderKind.apple
              ? PhosphorIcons.appleLogo(PhosphorIconsStyle.fill)
              : PhosphorIcons.googleLogo(),
          size: 18,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

enum OAuthProviderKind { apple, google }
