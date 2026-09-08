import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Placeholder sementara — Discover (feed utama setelah onboarding
/// selesai) belum dibangun. Cukup jadi titik akhir alur navigasi supaya
/// Gateway Choice/Splash/SignUp/Login bisa diverifikasi end-to-end tanpa
/// nyangkut di halaman yang belum ada.
class DiscoverPlaceholderScreen extends StatelessWidget {
  const DiscoverPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: const SafeArea(
        child: Center(
          child: Text(
            'Discover — coming soon',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
