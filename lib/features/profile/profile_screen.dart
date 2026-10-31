import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/api/api_client.dart';
import '../../core/models/my_profile.dart';
import '../../core/storage/profile_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_repository.dart';
import 'profile_labels.dart';
import 'profile_repository.dart';
import 'widgets/profile_menu_row.dart';

/// Tab "Profile" — sumber: couplivy-docs/flow/03-shared/profile-account.html
/// (§6.10, sama untuk Discover maupun Together Mode). Header (avatar,
/// nama+umur, occupation · education) + completeness bar + upgrade
/// banner + menu list vertikal.
///
/// Data dibaca dari `ProfileDatabase` (database lokal, BUKAN cache
/// sementara — diisi dari sync login/submit onboarding, lihat dokumentasi
/// class itu), TIDAK ADA network call setiap halaman ini dibuka. Fallback
/// fetch `GET /me` HANYA kalau database lokal masih kosong (device baru/
/// reinstall/login ulang yang belum pernah sync).
///
/// 3 dari 8 tujuan menu SUDAH punya halaman sendiri (My Profile —
/// TODO, lihat catatan router; Privacy & Safety & App Settings & dst
/// masih `ComingSoonScreen` placeholder, dibangun bertahap di sesi
/// terpisah — lihat .ai/rules/architecture.md).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    var profile = await ProfileDatabase.read();
    // Database lokal kosong (device baru/reinstall/login ulang, belum
    // pernah sync) — fetch sekali dari server untuk isi. Kegagalan
    // diabaikan (offline dsb) — halaman tetap render dengan data kosong
    // daripada stuck loading.
    if (profile == null) {
      try {
        profile = await profileRepository.syncMyProfile();
      } catch (_) {
        // Diabaikan sengaja — lihat dokumentasi method.
      }
    }
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmLogOut() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileLogOutConfirmTitle),
        content: Text(l10n.profileLogOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.profileLogOutConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.profileLogOutConfirmConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authRepository.logout();
      if (mounted) context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = _profile;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: _isLoading
          ? const SizedBox.shrink()
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.lilac.withValues(alpha: 0.2),
                      // NetworkImage (BUKAN FileImage) — photoPaths di sini
                      // datang dari GET /me (via ProfileDatabase, lihat
                      // dokumentasi class) sebagai path RELATIF storage,
                      // file fisiknya ada di SERVER. Gabung jadi URL
                      // lengkap DI SINI lewat storageUrl() (bukan
                      // disimpan sebagai URL utuh) — supaya ganti
                      // environment (ngrok/Tailscale/production) tidak
                      // perlu re-sync data. Beda dari photoPaths di
                      // onboarding Photos/Preview step (draft lokal
                      // SEBELUM upload, FileImage benar di situ).
                      backgroundImage:
                          profile != null && profile.photoPaths.isNotEmpty
                          ? NetworkImage(
                              CouplivyApiClient.storageUrl(
                                profile.photoPaths.first,
                              ),
                            )
                          : null,
                      child: profile == null || profile.photoPaths.isEmpty
                          ? Icon(
                              PhosphorIcons.user(),
                              size: 36,
                              color: AppColors.deepViolet,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (profile != null)
                    Center(
                      child: Text(
                        profile.age != null
                            ? '${profile.nickName ?? profile.fullName}, ${profile.age}'
                            : profile.nickName ?? profile.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  if (profile != null &&
                      (profile.occupation != null || profile.education != null))
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          [
                            profile.occupation,
                            if (profile.education != null)
                              ProfileLabels.education(l10n, profile.education!),
                          ].whereType<String>().join(' · '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (profile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              l10n.profileCompletenessLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                  child: LinearProgressIndicator(
                                    value: profile.completenessPercent / 100,
                                    minHeight: 6,
                                    backgroundColor: AppColors.border,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.lilac,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${profile.completenessPercent}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepViolet,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: () => context.push('/profile/upgrade'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.peach, AppColors.lilac],
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.profileUpgradeTitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    l10n.profileUpgradeSubtitle,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ProfileMenuRow(
                          icon: PhosphorIcons.user(),
                          label: l10n.profileMenuMyProfile,
                          onTap: () => context.push('/profile/my-profile'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.sliders(),
                          label: l10n.profileMenuMyPreferences,
                          onTap: () => context.push('/profile/preferences'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.bell(),
                          label: l10n.profileMenuNotifications,
                          onTap: () => context.push('/profile/notifications'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.eye(),
                          label: l10n.profileMenuPrivacy,
                          onTap: () => context.push('/profile/privacy'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.shieldCheck(),
                          label: l10n.profileMenuSafety,
                          onTap: () => context.push('/profile/safety'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.gearSix(),
                          label: l10n.profileMenuAppSettings,
                          onTap: () => context.push('/profile/settings'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.fileText(),
                          label: l10n.profileMenuTerms,
                          onTap: () => context.push('/profile/terms'),
                        ),
                        ProfileMenuRow(
                          icon: PhosphorIcons.signOut(),
                          label: l10n.profileMenuLogOut,
                          isDestructive: true,
                          onTap: _confirmLogOut,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
