import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 1/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/02-dob.html (nomor file lama
/// "02", step "Name" yang lama sudah dihapus dari alur).
///
/// Age SELALU derived dari DOB, tidak pernah input manual — sama pola
/// `Profile.getAgeAttribute()` di backend.
class DobStepScreen extends StatefulWidget {
  const DobStepScreen({super.key});

  @override
  State<DobStepScreen> createState() => _DobStepScreenState();
}

class _DobStepScreenState extends State<DobStepScreen> {
  DateTime? _dob;
  bool _isLoadingDraft = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final saved = await DiscoverOnboardingDraftStorage.readDob();
    if (saved != null && mounted) {
      setState(() => _dob = DateTime.parse(saved));
    }
    if (mounted) setState(() => _isLoadingDraft = false);
  }

  int get _age {
    final dob = _dob!;
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      helpText: AppLocalizations.of(context).dobFieldLabel,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _errorText = null;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_dob == null) {
      setState(() => _errorText = l10n.dobUnderageError);
      return;
    }

    await DiscoverOnboardingDraftStorage.saveDob(
      DateFormat('yyyy-MM-dd').format(_dob!),
    );
    if (mounted) context.go('/onboarding/discover/gender');
  }

  /// Back ke Gateway Choice — satu-satunya step sebelumnya. Kalau
  /// keyboard terbuka (tidak relevan di screen ini, tidak ada TextField,
  /// tapi tetap konsisten dengan pola screen lain), tutup dulu.
  void _backToGatewayChoice() => context.go('/gateway-choice');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToGatewayChoice();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 1,
                totalSteps: 9,
                onBack: _backToGatewayChoice,
              ),
              Expanded(
                child: _isLoadingDraft
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.dobTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.dobSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: _pickDate,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _errorText != null
                                        ? AppColors.error
                                        : AppColors.border,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _dob != null
                                          ? DateFormat(
                                              'd MMMM yyyy',
                                            ).format(_dob!)
                                          : l10n.dobFieldLabel,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _dob != null
                                            ? AppColors.textDark
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _errorText!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                            if (_dob != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.lilac.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.dobAgeResultLabel,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.dobAgeResultUnit(_age),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepViolet,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.onboardingContinue,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
