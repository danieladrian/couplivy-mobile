import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/api/api_client.dart';
import '../../core/models/my_profile.dart';
import '../../core/storage/profile_database.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../onboarding/discover/interest_labels.dart';
import 'edit_profile_screen.dart';
import 'profile_labels.dart';

/// "My Profile" — dari `ProfileDatabase` (database lokal, BISA DIBUKA
/// OFFLINE, TIDAK network call). Gaya visual mengikuti
/// couplivy-docs/flow/01-discover/11-profile-detail-plus.html (Profile
/// Detail kandidat match), TAPI untuk profil SENDIRI — compatibility
/// score/carousel-nav-vs-kandidat-lain/Like-Pass DIHILANGKAN (tidak
/// relevan untuk profil sendiri), diganti tombol Edit (pojok kanan atas
/// hero photo) yang buka `EditProfileScreen`.
///
/// Carousel foto TETAP ada (beda dari rencana awal "cuma 1 foto utama")
/// kalau `photoPaths` lebih dari 1 — user bisa upload sampai 6 foto saat
/// onboarding, carousel biar semua foto itu bisa dilihat di sini.
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  MyProfile? _profile;
  bool _isLoading = true;
  int _photoIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await ProfileDatabase.read();
    if (mounted) {
      setState(() {
        _profile = profile;
        _photoIndex = 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _openEdit() async {
    final profile = _profile;
    if (profile == null) return;

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(initialProfile: profile),
      ),
    );
    // EditProfileScreen sudah panggil ProfileRepository.updateProfile()
    // (yang sudah update ProfileDatabase lokal) SEBELUM pop — reload di
    // sini cuma baca ulang dari database lokal itu, TIDAK ada network
    // call tambahan.
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = _profile;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SizedBox.shrink(),
      );
    }

    if (profile == null) {
      return Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          backgroundColor: AppColors.lightGray,
          elevation: 0,
          title: Text(l10n.profileMenuMyProfile),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        body: Center(
          child: Text(
            l10n.profileComingSoonMessage,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _HeroPhoto(
              photoPaths: profile.photoPaths,
              index: _photoIndex,
              onIndexChanged: (index) => setState(() => _photoIndex = index),
              onBack: () => Navigator.of(context).pop(),
              onEdit: _openEdit,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.age != null
                        ? '${profile.nickName ?? profile.fullName}, ${profile.age}'
                        : profile.nickName ?? profile.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (profile.occupation != null ||
                      profile.education != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            [
                              profile.occupation,
                              if (profile.education != null)
                                ProfileLabels.education(
                                  l10n,
                                  profile.education!,
                                ),
                            ].whereType<String>().join(' · '),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  _FactGrid(profile: profile, l10n: l10n),
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _SectionTitle(l10n.myProfileAboutTitle),
                    const SizedBox(height: 8),
                    Text(
                      profile.bio!,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                  if (profile.interestSlugs.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _SectionTitle(l10n.myProfileInterestsTitle),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final slug in profile.interestSlugs)
                          _InterestTag(
                            label: InterestLabels.labelFor(l10n, slug),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({
    required this.photoPaths,
    required this.index,
    required this.onIndexChanged,
    required this.onBack,
    required this.onEdit,
  });

  final List<String> photoPaths;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: photoPaths.isEmpty
              ? const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.lavender, AppColors.peach],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                )
              : Image(
                  image: NetworkImage(
                    CouplivyApiClient.storageUrl(photoPaths[index]),
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 14,
          left: 16,
          right: 16,
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back,
                  onTap: onBack,
                ),
                _CircleIconButton(
                  icon: Icons.edit_outlined,
                  onTap: onEdit,
                ),
              ],
            ),
          ),
        ),
        if (photoPaths.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < photoPaths.length; i++)
                  GestureDetector(
                    onTap: () => onIndexChanged(i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 16, color: AppColors.textDark),
        ),
      ),
    );
  }
}

class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.profile, required this.l10n});

  final MyProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final facts = <(PhosphorIconData, String)>[
      if (profile.education != null)
        (PhosphorIcons.graduationCap(), ProfileLabels.education(l10n, profile.education!)),
      if (profile.religion != null)
        (PhosphorIcons.handsPraying(), ProfileLabels.religion(l10n, profile.religion!)),
      if (profile.heightCm != null)
        (PhosphorIcons.ruler(), '${profile.heightCm} cm'),
      if (profile.relationshipGoal != null)
        (
          PhosphorIcons.heart(),
          ProfileLabels.relationshipGoal(l10n, profile.relationshipGoal!),
        ),
      if (profile.childrenPreference != null)
        (
          PhosphorIcons.babyCarriage(),
          ProfileLabels.childrenPreference(l10n, profile.childrenPreference!),
        ),
      if (profile.drinking != null)
        (PhosphorIcons.wine(), ProfileLabels.drinking(l10n, profile.drinking!)),
    ];

    if (facts.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.3,
      children: [
        for (final (icon, label) in facts)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: AppColors.deepViolet),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _InterestTag extends StatelessWidget {
  const _InterestTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
