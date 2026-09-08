import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Token tipografi brand — Poppins untuk UI fungsional, Playfair Display
/// HANYA untuk headline emosional (§4 brand-guideline.md, sinkron dengan
/// `font-poppins`/`font-playfair` di couplivy-backend/resources/css/app.css
/// dan .ai/rules/architecture.md di couplivy-backend).
abstract final class AppTextStyles {
  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textDark,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle playfairDisplay({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    FontStyle fontStyle = FontStyle.normal,
    Color color = AppColors.deepViolet,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
    );
  }
}
