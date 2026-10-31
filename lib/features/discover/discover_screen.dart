import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../l10n/generated/app_localizations.dart';
import 'dummy_candidate.dart';

const _gradients = [
  [AppColors.lavender, AppColors.peach],
  [AppColors.dustyBlue, AppColors.lavender],
  [AppColors.lilac, AppColors.peach],
  [AppColors.peach, AppColors.dustyBlue],
];

/// Tab "Discover" — sumber: couplivy-docs/flow/01-discover/
/// 10-discover-free.html. Mekanisme: list kartu (BUKAN swipe stack),
/// tiap kartu = 1 kandidat dengan foto/nama+umur/job+jarak/tags minat/
/// compatibility %/tombol Pass+Like.
///
/// DUMMY SEMENTARA — belum ada backend matching/recommendation
/// sungguhan. Data RANDOM (`DummyCandidate.generateList()`), digenerate
/// SEKALI di `initState` (bukan tiap rebuild). Pass menghapus kartu dari
/// list lokal, Like juga menghapus (TIDAK ADA simulasi "mutual match" —
/// beda dari prototype HTML yang hardcode Sarah sebagai match, karena di
/// sini datanya random tiap kali, tidak ada kandidat tetap untuk
/// disimulasikan). Refresh generate ulang list baru. Ganti ke data
/// server asli begitu endpoint Discover/matching dibangun.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late List<DummyCandidate> _candidates;

  @override
  void initState() {
    super.initState();
    _candidates = DummyCandidate.generateList(3);
  }

  void _refresh() {
    setState(() => _candidates = DummyCandidate.generateList(3));
  }

  void _removeAt(int index) {
    setState(() => _candidates.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Couplivy',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.deepViolet,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.lightGray,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIcons.gearSix(),
                      size: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _candidates.isEmpty
                  ? Center(
                      child: Text(
                        l10n.discoverEmptyMessage,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                      itemCount: _candidates.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final candidate = _candidates[index];
                        return _CandidateCard(
                          candidate: candidate,
                          onPass: () => _removeAt(index),
                          onLike: () => _removeAt(index),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: Icon(PhosphorIcons.arrowClockwise(), size: 16),
                  label: Text(l10n.discoverRefreshLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.deepViolet,
                    side: const BorderSide(color: AppColors.lilac),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.candidate,
    required this.onPass,
    required this.onLike,
  });

  final DummyCandidate candidate;
  final VoidCallback onPass;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gradientColors = _gradients[candidate.gradientSeed % _gradients.length];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${candidate.name}, ${candidate.age}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.discoverDistanceLabel(
                    candidate.occupation,
                    candidate.distanceKm,
                  ),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final tag in candidate.tags)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                '${candidate.compatibilityPercent}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepViolet,
                ),
              ),
              Text(
                l10n.discoverCompatibleLabel,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _MiniButton(
                    icon: PhosphorIcons.x(),
                    onTap: onPass,
                  ),
                  const SizedBox(width: 6),
                  _MiniButton(
                    icon: PhosphorIcons.heart(),
                    onTap: onLike,
                    isLike: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.icon,
    required this.onTap,
    this.isLike = false,
  });

  final PhosphorIconData icon;
  final VoidCallback onTap;
  final bool isLike;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isLike
          ? AppColors.peach.withValues(alpha: 0.4)
          : AppColors.lightGray,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            size: 14,
            color: isLike ? const Color(0xFFB5652F) : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
