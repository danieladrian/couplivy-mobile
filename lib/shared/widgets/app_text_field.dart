import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Text field brand — dipakai di Sign Up, Login, dan form lain ke depan.
/// Sinkron gaya dengan `.field input` di couplivy-docs/flow/_shared/
/// phone-shell.css (label di atas, border tipis, radius medium).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  // Beda dari `hintText` (placeholder — hilang begitu user mulai
  // mengetik): `helperText` TETAP TERLIHAT di bawah field sepanjang
  // waktu. Dipakai untuk syarat yang perlu diingat user selama mengisi
  // (mis. syarat kompleksitas password), bukan cuma sebelum mulai isi.
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            // errorText MENGGANTIKAN helperText kalau ada error (perilaku
            // bawaan InputDecoration) — jadi tidak perlu dicek manual di
            // sini, tapi tetap eksplisit: helperText cuma tampil kalau
            // TIDAK ada error.
            helperText: errorText == null ? helperText : null,
            helperMaxLines: 2,
            helperStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.deepViolet),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
