import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../l10n/generated/app_localizations.dart';

/// "App Settings" — UI statis (bahasa saat ini + versi app), TANPA
/// backend baru (keputusan produk, lihat .ai/rules/architecture.md).
/// Bahasa app HANYA ikut locale HP (`CouplivyApp` tidak punya toggle
/// bahasa manual, lihat `app.dart`) — di sini cuma DITAMPILKAN, TIDAK
/// bisa diganti dari dalam app. Versi app HARDCODE dari `pubspec.yaml`
/// (project belum pakai `package_info_plus` untuk baca versi runtime).
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  // Sinkron manual dengan `version:` di pubspec.yaml — TIDAK otomatis,
  // update ini juga kalau versi app dinaikkan (sampai package_info_plus
  // ditambahkan untuk baca ini dari build metadata langsung).
  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final languageLabel = locale.languageCode == 'id'
        ? l10n.appSettingsLanguageIndonesian
        : l10n.appSettingsLanguageEnglish;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          l10n.appSettingsTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              children: [
                _row(l10n.appSettingsLanguageLabel, languageLabel),
                _row(l10n.appSettingsVersionLabel, _appVersion, isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
