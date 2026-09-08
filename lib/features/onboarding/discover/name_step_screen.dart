import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

/// Step 1/10 onboarding jalur Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/01-name.html.
///
/// TIDAK panggil API — nama cuma disimpan ke draft lokal
/// (DiscoverOnboardingDraftStorage). Submit ke server SEKALIGUS terjadi
/// di step terakhir (Preview, belum ada). Back (header maupun hardware)
/// ke Gateway Choice, draft yang sudah diisi tetap ada di storage kalau
/// user balik lagi ke step ini.
class NameStepScreen extends ConsumerStatefulWidget {
  const NameStepScreen({super.key});

  @override
  ConsumerState<NameStepScreen> createState() => _NameStepScreenState();
}

class _NameStepScreenState extends ConsumerState<NameStepScreen> {
  final _nameController = TextEditingController();
  bool _isLoadingDraft = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final savedName = await DiscoverOnboardingDraftStorage.readName();
    if (savedName != null && mounted) {
      _nameController.text = savedName;
    }
    if (mounted) setState(() => _isLoadingDraft = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await DiscoverOnboardingDraftStorage.saveName(name);
    // Step 3 (DOB) belum ada — sementara langsung ke Discover placeholder.
    // Ganti ke step berikutnya begitu halamannya dibuat.
    if (mounted) context.go('/discover');
  }

  /// Back (header maupun hardware) ke Gateway Choice — satu-satunya step
  /// sebelumnya sejauh ini. Kalau keyboard sedang terbuka, tutup dulu
  /// (sama pola LoginScreen/SignUpScreen._backToWelcome).
  void _backToGatewayChoice() {
    final primaryFocus = FocusManager.instance.primaryFocus;
    final isTextFieldFocused =
        primaryFocus?.context?.findAncestorWidgetOfExactType<EditableText>() !=
        null;

    if (isTextFieldFocused) {
      primaryFocus!.unfocus();
      return;
    }
    context.go('/gateway-choice');
  }

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
                totalSteps: 10,
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
                              l10n.onboardingNameTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.onboardingNameSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppTextField(
                              label: l10n.onboardingNameFieldLabel,
                              hintText: l10n.onboardingNameFieldHint,
                              controller: _nameController,
                            ),
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
