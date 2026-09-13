import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tab "Profile" — kosong sengaja (belum dibangun), cuma jadi salah satu
/// dari 3 tab utama (`MainNavigationScreen`). Isi sebenarnya (foto,
/// bio, edit profil, settings, dst) menyusul nanti.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppColors.lightGray);
  }
}
