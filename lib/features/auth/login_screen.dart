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
import 'providers/auth_form_controller.dart';

/// Login — sumber: couplivy-docs/flow/00-auth/04-login.html. Identifier
/// bisa email ATAU nomor HP (backend yang tentukan kolom mana dicocokkan,
/// lihat AuthService::login()).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    ref
        .read(loginFormProvider.notifier)
        .login(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
  }

  /// Back (header maupun hardware) SELALU ke Welcome — bukan pop().
  /// Login bisa dicapai dari Welcome (push) ATAU dari Sign Up (push via
  /// footer link), jadi history stack-nya tidak konsisten; go('/welcome')
  /// eksplisit menjamin balik ke Welcome dari jalur mana pun, sesuai
  /// keputusan produk: back dari Login selalu skip Sign Up.
  ///
  /// Kalau keyboard sedang terbuka (ada TextField yang fokus), back
  /// PERTAMA cuma tutup keyboard (unfocus) — TIDAK langsung pindah ke
  /// Welcome. `PopScope(canPop: false)` intercept semua pop request
  /// termasuk yang seharusnya cuma dismiss keyboard, jadi behavior "tutup
  /// keyboard dulu" itu harus ditangani manual di sini, bukan otomatis
  /// dari framework.
  ///
  /// Cek ada `EditableText` (TextField) di ancestor primary focus saat
  /// ini — BUKAN cuma `FocusScope.of(context).hasFocus` (SELALU `true`
  /// walau tidak ada TextField aktif secara visual, false positive yang
  /// sempat bikin back rusak total) atau `primaryFocus?.context != null`
  /// (juga selalu non-null untuk focus node non-TextField).
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
    final formState = ref.watch(loginFormProvider);

    ref.listen(loginFormProvider, (previous, next) {
      if (next is AuthFormSuccess) {
        // Login bisa terjadi dari device baru (uninstall+install ulang)
        // atau session lama habis — `resumeRoute` arahkan ke step yang
        // BELUM diselesaikan (bukan selalu balik ke Gateway Choice dari
        // awal), sama seperti Splash. Lihat OnboardingStatus.resumeRoute.
        context.go(next.onboarding.resumeRoute);
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
                title: l10n.loginTitle,
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
                        label: l10n.loginIdentifierLabel,
                        hintText: l10n.authEmailHint,
                        controller: _identifierController,
                        errorText: apiError?.errorFor('identifier'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: l10n.authPasswordLabel,
                        hintText: l10n.authPasswordHintLogin,
                        controller: _passwordController,
                        obscureText: true,
                        errorText: apiError?.errorFor('password'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: navigasi ke /forgot-password saat
                            // halaman itu dibuat.
                          },
                          child: Text(
                            l10n.authForgotPassword,
                            style: const TextStyle(
                              color: AppColors.deepViolet,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      if (apiError != null && apiError.fieldErrors == null) ...[
                        const SizedBox(height: 4),
                        Text(
                          apiError.message,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      AppButton(
                        label: l10n.loginSubmit,
                        onPressed: isLoading ? null : _submit,
                      ),
                      if (isLoading) ...[
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                      ],
                      const SizedBox(height: 16),
                      AuthFooterLink(
                        question: l10n.loginFooterQuestion,
                        action: l10n.loginFooterAction,
                        // push (BUKAN go) — go() dari route yang sudah
                        // di-push (bukan root) mereset SELURUH stack ke
                        // cuma [Login/SignUp], bukan sekadar replace 1
                        // level, itu penyebab back-nya langsung keluar
                        // app. Back-nya sendiri tetap selalu ke Welcome
                        // lewat _backToWelcome (bukan pop), lihat komentar
                        // di atas.
                        onTap: () => context.push('/signup'),
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
