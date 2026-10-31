import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/profile_menu_row.dart';

/// "Terms & Privacy" — UI statis, 2 link (Terms of Service, Privacy
/// Policy) TANPA backend baru (keputusan produk). Tap menu ini SENGAJA
/// tidak membuka apa-apa (halaman T&C/kebijakan privasi belum ditulis
/// sama sekali — konten legal, di luar scope kerja frontend/backend)
/// — placeholder visual saja supaya menu tidak dead-end/hilang.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          l10n.termsTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ProfileMenuRow(
              icon: PhosphorIcons.fileText(),
              label: l10n.termsOfServiceLabel,
              onTap: () {},
            ),
            ProfileMenuRow(
              icon: PhosphorIcons.shieldCheck(),
              label: l10n.termsPrivacyPolicyLabel,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
