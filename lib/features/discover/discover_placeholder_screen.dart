import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tab "Discover" (feed utama) — kosong sengaja, belum dibangun. Sekarang
/// jadi salah satu dari 3 tab utama (`MainNavigationScreen`), BUKAN lagi
/// endpoint mandiri seperti sebelumnya — makanya tidak ada lagi teks
/// "coming soon" (dulu perlu, karena ini titik akhir tunggal seluruh
/// alur onboarding; sekarang sudah ada bottom nav yang jelas
/// menunjukkan ini bagian dari app, bukan dead end).
class DiscoverPlaceholderScreen extends StatelessWidget {
  const DiscoverPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppColors.lightGray);
  }
}
