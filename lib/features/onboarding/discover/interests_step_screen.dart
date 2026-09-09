import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/interest.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';
import 'interest_labels.dart';
import 'interest_repository.dart';

const _minimumInterests = 3;

/// Step 6/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/07-interests.html. Daftar
/// interest di-cache lokal (lihat [InterestRepository]) sejak login/
/// register, jadi step ini biasanya render instan tanpa network round-
/// trip. WAJIB pilih minimal 3 (tombol Skip dihapus — keputusan produk,
/// lihat .ai/rules/architecture.md) — divalidasi lagi di server saat
/// submit akhir, tapi dicek juga di sini supaya user tidak perlu tunggu
/// sampai step Preview untuk tahu ada masalah.
class InterestsStepScreen extends StatefulWidget {
  const InterestsStepScreen({super.key});

  @override
  State<InterestsStepScreen> createState() => _InterestsStepScreenState();
}

class _InterestsStepScreenState extends State<InterestsStepScreen> {
  List<Interest> _interests = [];
  Set<int> _selectedIds = {};
  bool _isLoading = true;
  String? _errorText;
  ApiLoadError? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        interestRepository.list(),
        DiscoverOnboardingDraftStorage.readInterestIds(),
      ]);
      final interests = results[0] as List<Interest>;
      final savedIds = results[1] as List<int>;

      if (mounted) {
        setState(() {
          _interests = interests;
          _selectedIds = savedIds.toSet();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadError = ApiLoadError();
          _isLoading = false;
        });
      }
    }
  }

  void _toggle(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _errorText = null;
    });
  }

  Future<void> _saveAndContinue() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedIds.length < _minimumInterests) {
      setState(() => _errorText = l10n.interestsMinimumError);
      return;
    }

    await DiscoverOnboardingDraftStorage.saveInterestIds(_selectedIds.toList());
    if (mounted) context.go('/onboarding/discover/relationship-goal');
  }

  void _backToWorkEducation() =>
      context.go('/onboarding/discover/work-education');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToWorkEducation();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 6,
                totalSteps: 9,
                onBack: _backToWorkEducation,
              ),
              Expanded(child: _buildBody(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) return const SizedBox.shrink();

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _loadError!.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: l10n.onboardingContinue,
                onPressed: () => setState(() {
                  _isLoading = true;
                  _loadError = null;
                  _load();
                }),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.interestsTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.interestsSubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final interest in _interests)
                _InterestChip(
                  label: InterestLabels.labelFor(l10n, interest.slug),
                  selected: _selectedIds.contains(interest.id),
                  onTap: () => _toggle(interest.id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.interestsSelectedCount(_selectedIds.length),
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: const TextStyle(color: AppColors.error, fontSize: 12.5),
            ),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: l10n.onboardingContinue,
            onPressed: _saveAndContinue,
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lilac.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? AppColors.lilac : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.deepViolet : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

/// Marker error sederhana — pesan generik, tidak perlu detail teknis untuk
/// user (load daftar interest gagal biasanya network, retry cukup).
class ApiLoadError {
  String get message => 'Could not load interests. Please try again.';
}
