import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tab "Connections" — kosong sengaja (belum dibangun), cuma jadi salah
/// satu dari 3 tab utama (`MainNavigationScreen`). Isi sebenarnya (match
/// list, chat, dst) menyusul nanti.
class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppColors.lightGray);
  }
}
