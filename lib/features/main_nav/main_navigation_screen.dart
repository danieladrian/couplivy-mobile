import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../connections/connections_screen.dart';
import '../discover/discover_placeholder_screen.dart';
import '../profile/profile_screen.dart';

/// Container 3 tab utama app setelah onboarding selesai — Discover,
/// Connections, Profile. Dipasang di route `/discover` (satu-satunya
/// entry point setelah Gateway Choice/onboarding/login berhasil, lihat
/// router.dart), BUKAN 3 route URL terpisah — tab dikelola state lokal
/// (`_selectedIndex`), bukan lewat go_router nested routes.
///
/// `IndexedStack` (bukan cuma render tab aktif) — supaya state tiap tab
/// (mis. scroll position, form yang sedang diisi) PERSIST saat pindah
/// tab, bukan dibuang & dibangun ulang dari nol tiap kali balik.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const _tabs = [
    DiscoverPlaceholderScreen(),
    ConnectionsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.deepViolet,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.compass()),
            activeIcon: Icon(PhosphorIcons.compass(PhosphorIconsStyle.fill)),
            label: l10n.navDiscover,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.usersThree()),
            activeIcon: Icon(PhosphorIcons.usersThree(PhosphorIconsStyle.fill)),
            label: l10n.navConnections,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.user()),
            activeIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.fill)),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
