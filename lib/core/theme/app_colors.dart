import 'package:flutter/material.dart';

/// Token warna brand Couplivy — SUMBER KEBENARAN ada di
/// `couplivy-docs/flow/ui/brand-guideline.md`. Harus sinkron dengan
/// `@theme` di `couplivy-backend/resources/css/app.css`. Jangan tambah hex
/// baru di sini tanpa update dokumen guideline-nya juga.
abstract final class AppColors {
  static const deepViolet = Color(0xFF6D5BA6);
  static const lilac = Color(0xFFA788FA);
  static const lavender = Color(0xFFC4B5FD);
  static const dustyBlue = Color(0xFF8CA9D6);
  static const peach = Color(0xFFFFD5B5);
  static const cream = Color(0xFFFFF0E6);
  static const lightGray = Color(0xFFF2F3F7);
  static const textDark = Color(0xFF29263A);
  static const textSecondary = Color(0xFF777487);
  static const border = Color(0xFFE7E4EE);
  static const success = Color(0xFF76B89A);
  static const error = Color(0xFFD97B86);
  static const warning = Color(0xFFE7B66A);
}
