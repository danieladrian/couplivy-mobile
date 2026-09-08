import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/models/onboarding_status.dart';
import '../auth_repository.dart';

/// State loading/error untuk form Sign Up & Login — bentuknya sama
/// (idle/loading/error/success) makanya 1 class dipakai bareng; tiap screen
/// punya instance provider sendiri lewat `.autoDispose` (state di-reset
/// begitu screen ditinggalkan).
sealed class AuthFormState {
  const AuthFormState();
}

class AuthFormIdle extends AuthFormState {
  const AuthFormIdle();
}

class AuthFormLoading extends AuthFormState {
  const AuthFormLoading();
}

class AuthFormError extends AuthFormState {
  const AuthFormError(this.error);

  final ApiException error;
}

class AuthFormSuccess extends AuthFormState {
  const AuthFormSuccess(this.onboarding);

  /// Status onboarding user, disertakan backend di response yang sama
  /// dengan login/register — dipakai listener di SignUp/Login screen buat
  /// tentukan halaman tujuan redirect (Onboard vs Discover/Together) tanpa
  /// API call terpisah.
  final OnboardingStatus onboarding;
}

class AuthFormController extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormIdle();

  Future<void> register({
    required String fullName,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required String locale,
  }) async {
    state = const AuthFormLoading();
    try {
      final result = await authRepository.register(
        fullName: fullName,
        nickName: nickName,
        email: email,
        phone: phone,
        password: password,
        locale: locale,
      );
      state = AuthFormSuccess(result.onboarding);
    } on ApiException catch (e) {
      state = AuthFormError(e);
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = const AuthFormLoading();
    try {
      final result = await authRepository.login(
        identifier: identifier,
        password: password,
      );
      state = AuthFormSuccess(result.onboarding);
    } on ApiException catch (e) {
      state = AuthFormError(e);
    }
  }
}

/// Provider terpisah untuk Sign Up dan Login — instance state-nya beda
/// (kalau dipakai provider yang sama di 2 screen, error di 1 form bisa
/// bocor ke form lain kalau user pindah screen tanpa dispose).
final signUpFormProvider =
    NotifierProvider.autoDispose<AuthFormController, AuthFormState>(
      AuthFormController.new,
    );

final loginFormProvider =
    NotifierProvider.autoDispose<AuthFormController, AuthFormState>(
      AuthFormController.new,
    );
