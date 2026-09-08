import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/models/onboarding_status.dart';
import '../../core/models/user.dart';
import '../../core/storage/token_storage.dart';
import '../../core/storage/user_session_storage.dart';

/// Hasil sukses login/register — user + token, sekaligus menyimpan token
/// ke secure storage. `onboarding` disertakan backend di response yang
/// sama supaya pemanggil (SignUp/Login) bisa langsung tentukan redirect
/// tanpa API call terpisah — lihat AuthService::issueToken() backend.
class AuthResult {
  const AuthResult({
    required this.user,
    required this.token,
    required this.onboarding,
  });

  final User user;
  final String token;
  final OnboardingStatus onboarding;
}

/// Panggil endpoint auth di backend Laravel (routes/api.php: /auth/*).
/// Business logic validasi/matching provider ada di backend
/// (App\Services\AuthService) — repository ini murni HTTP layer.
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<AuthResult> register({
    required String fullName,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required String locale,
  }) {
    return _post('/auth/register', {
      'full_name': fullName,
      'nick_name': nickName,
      'email': email,
      'phone': phone,
      'password': password,
      'locale': locale,
    });
  }

  Future<AuthResult> login({
    required String identifier,
    required String password,
  }) {
    return _post('/auth/login', {
      'identifier': identifier,
      'password': password,
    });
  }

  Future<AuthResult> loginWithGoogle({
    required String idToken,
    required String locale,
  }) {
    return _post('/auth/google', {'id_token': idToken, 'locale': locale});
  }

  Future<AuthResult> loginWithApple({
    required String identityToken,
    String? fullName,
    required String locale,
  }) {
    return _post('/auth/apple', {
      'identity_token': identityToken,
      'full_name': fullName,
      'locale': locale,
    });
  }

  /// POST generik ke endpoint auth — semua endpoint /auth/* balikin bentuk
  /// response yang sama ({user, token}), jadi cukup 1 method dipakai
  /// bareng, termasuk konversi DioException -> ApiException di sini.
  Future<AuthResult> _post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      final body = response.data as Map<String, dynamic>;
      final token = body['token'] as String;

      final user = User.fromJson(body['user'] as Map<String, dynamic>);

      await TokenStorage.saveToken(token);
      await UserSessionStorage.save(user);

      return AuthResult(
        user: user,
        token: token,
        onboarding: OnboardingStatus.fromJson(
          body['onboarding'] as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Instance tunggal — dipakai lewat Riverpod provider (lihat
/// auth_provider.dart), bukan di-construct manual di widget.
final authRepository = AuthRepository(CouplivyApiClient.instance);
