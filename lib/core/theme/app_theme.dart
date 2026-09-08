import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ThemeData aplikasi, dibangun dari token di [AppColors]. Font default UI
/// adalah Poppins (§4 brand-guideline.md) — Playfair Display dipakai
/// eksplisit lewat [AppTextStyles.playfairDisplay] hanya untuk headline
/// emosional, bukan sebagai default textTheme.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepViolet,
      primary: AppColors.deepViolet,
      secondary: AppColors.lilac,
      surface: Colors.white,
      error: AppColors.error,
      brightness: Brightness.light,
    );

    final baseTextTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      textTheme: baseTextTheme,
    );
  }
}
