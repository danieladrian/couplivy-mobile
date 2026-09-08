import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Baris footer "Sudah punya akun? Log In" / "Belum punya akun? Daftar" —
/// dipakai bolak-balik antara Sign Up dan Login.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: '$question '),
            TextSpan(
              text: action,
              style: const TextStyle(
                color: AppColors.deepViolet,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
