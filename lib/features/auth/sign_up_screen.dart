import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/auth_footer_link.dart';
import '../../shared/widgets/auth_screen_header.dart';
import '../../shared/widgets/labeled_divider.dart';
import '../../shared/widgets/oauth_button.dart';
import '../../shared/widgets/phone_number_field.dart';
import 'providers/auth_form_controller.dart';

/// Sign Up — sumber: couplivy-docs/flow/00-auth/03-signup.html. Email DAN
/// nomor HP KEDUANYA wajib (bukan salah satu) — lihat
/// .ai/rules/architecture.md.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _dialCode = '+62';

  @override
  void dispose() {
    _fullNameController.dispose();
    _nickNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final locale = Localizations.localeOf(context).languageCode;

    ref
        .read(signUpFormProvider.notifier)
        .register(
          fullName: _fullNameController.text.trim(),
          nickName: _nickNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: '$_dialCode${_phoneController.text.trim()}',
          password: _passwordController.text,
          locale: locale,
        );
  }

  /// Back (header maupun hardware) SELALU ke Welcome — bukan pop(). Sama
  /// alasan seperti LoginScreen._backToWelcome: history stack ke Sign Up
  /// tidak konsisten (bisa dari Welcome atau dari Login via footer link),
  /// go('/welcome') eksplisit menjamin balik ke Welcome dari jalur mana pun.
  ///
  /// Kalau keyboard sedang terbuka, back PERTAMA cuma tutup keyboard
  /// (unfocus) — TIDAK langsung pindah ke Welcome (lihat komentar detail
  /// di LoginScreen._backToWelcome).
  void _backToWelcome(BuildContext context) {
    final primaryFocus = FocusManager.instance.primaryFocus;
    final isTextFieldFocused =
        primaryFocus?.context?.findAncestorWidgetOfExactType<EditableText>() !=
        null;

    if (isTextFieldFocused) {
      primaryFocus!.unfocus();
      return;
    }
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formState = ref.watch(signUpFormProvider);

    ref.listen(signUpFormProvider, (previous, next) {
      if (next is AuthFormSuccess) {
        // User baru daftar selalu belum onboard — langsung ke Gateway
        // Choice (step 1), bukan Welcome lagi.
        context.go('/gateway-choice');
      }
    });

    final isLoading = formState is AuthFormLoading;
    final apiError = formState is AuthFormError ? formState.error : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToWelcome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              AuthScreenHeader(
                title: l10n.signUpTitle,
                onBack: () => _backToWelcome(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OAuthButton(
                        label: l10n.authContinueWithApple,
                        provider: OAuthProviderKind.apple,
                        onPressed: () => _showComingSoon(context, l10n),
                      ),
                      const SizedBox(height: 10),
                      OAuthButton(
                        label: l10n.authContinueWithGoogle,
                        provider: OAuthProviderKind.google,
                        onPressed: () => _showComingSoon(context, l10n),
                      ),
                      LabeledDivider(label: l10n.authOr),
                      AppTextField(
                        label: l10n.authFullNameLabel,
                        hintText: l10n.authFullNameHint,
                        controller: _fullNameController,
                        errorText: apiError?.errorFor('full_name'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: l10n.authNickNameLabel,
                        hintText: l10n.authNickNameHint,
                        controller: _nickNameController,
                        errorText: apiError?.errorFor('nick_name'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: l10n.authEmailLabel,
                        hintText: l10n.authEmailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: apiError?.errorFor('email'),
                      ),
                      const SizedBox(height: 14),
                      PhoneNumberField(
                        label: l10n.authPhoneLabel,
                        controller: _phoneController,
                        onCountryChanged: (code) => setState(() {
                          _dialCode = code.dialCode ?? '+62';
                        }),
                        errorText: apiError?.errorFor('phone'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: l10n.authPasswordLabel,
                        hintText: l10n.authPasswordHintSignUp,
                        controller: _passwordController,
                        obscureText: true,
                        errorText: apiError?.errorFor('password'),
                      ),
                      if (apiError != null && apiError.fieldErrors == null) ...[
                        const SizedBox(height: 10),
                        Text(
                          apiError.message,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 22),
                      AppButton(
                        label: l10n.signUpSubmit,
                        onPressed: isLoading ? null : _submit,
                      ),
                      if (isLoading) ...[
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                      ],
                      const SizedBox(height: 16),
                      AuthFooterLink(
                        question: l10n.signUpFooterQuestion,
                        action: l10n.signUpFooterAction,
                        // push (BUKAN go) — lihat komentar setara di
                        // LoginScreen tentang kenapa go() dari route
                        // ter-push berbahaya (reset seluruh stack).
                        onTap: () => context.push('/login'),
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

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.authComingSoon)));
  }
}
