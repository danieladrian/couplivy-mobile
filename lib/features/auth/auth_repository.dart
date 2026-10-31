import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/models/onboarding_status.dart';
import '../../core/models/user.dart';
import '../../core/storage/profile_database.dart';
import '../../core/storage/token_storage.dart';
import '../../core/storage/user_session_storage.dart';
import '../onboarding/discover/discover_onboarding_draft_storage.dart';
import '../onboarding/discover/interest_repository.dart';
import '../profile/profile_repository.dart';

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

  /// Logout — panggil `/auth/logout` (revoke token Sanctum di server)
  /// SEBELUM hapus token lokal, supaya token lama tidak bisa dipakai lagi
  /// kalau device lain masih menyimpannya. Kegagalan network DIABAIKAN
  /// (tidak lempar ulang) — user tetap harus bisa "logout" dari device
  /// ini meski offline, cache/token lokal tetap dihapus di jalur manapun.
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (_) {
      // Diabaikan sengaja — lihat dokumentasi method.
    }
    await TokenStorage.clearToken();
    await UserSessionStorage.clear();
    await ProfileDatabase.clear();
    await DiscoverOnboardingDraftStorage.clear();
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
      final onboarding = OnboardingStatus.fromJson(
        body['onboarding'] as Map<String, dynamic>,
      );

      await TokenStorage.saveToken(token);
      await UserSessionStorage.save(user);
      // Refresh cache Interests SEGERA setelah login/register — supaya
      // saat user sampai step Interests (kalau mode discover), datanya
      // sudah ada di cache lokal (instan, tanpa network round-trip).
      // Kegagalan diabaikan (lihat dokumentasi refreshCache) — TIDAK
      // boleh menggagalkan alur login/register.
      unawaited(interestRepository.refreshCache());
      // Sync ProfileDatabase (database lokal profil) SEGERA kalau
      // onboarding SUDAH selesai — device baru/reinstall/login dari HP
      // lain langsung punya database lokal terisi SEBELUM user buka tab
      // Profile sama sekali (dulu baru ke-fetch saat tab itu pertama
      // dibuka, ada jeda loading). Kalau onboarding BELUM selesai,
      // `GET /me` percuma dipanggil — profil belum ada isinya sama
      // sekali di server. Kegagalan diabaikan (sama alasan interests di
      // atas) — ProfileScreen tetap punya fallback sync sendiri kalau
      // ini gagal.
      if (onboarding.completed) {
        unawaited(_syncProfileIgnoringErrors());
      }

      return AuthResult(user: user, token: token, onboarding: onboarding);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Wrapper `syncMyProfile()` yang TELAN semua error — beda dari
  /// `syncMyProfile()` sendiri yang me-LEMPAR (dipakai pemanggil lain,
  /// `PreviewStepScreen`/`ProfileScreen`, yang justru perlu tahu
  /// kegagalannya). Method ini WAJIB ada sebelum `unawaited()` di atas —
  /// tanpa try/catch di sini, exception dari `syncMyProfile()` jadi
  /// UNHANDLED di zona async terpisah (bukan "diam-diam diabaikan"
  /// seperti yang komentar di atas maksudkan), yang mencetak
  /// "Unhandled Exception: Instance of 'ApiException'" ke log device dan
  /// bisa bikin app crash — bug nyata yang pernah terjadi sebelum
  /// try/catch ini ditambahkan.
  Future<void> _syncProfileIgnoringErrors() async {
    try {
      await profileRepository.syncMyProfile();
    } on ApiException catch (_) {
      // Diabaikan sengaja — lihat dokumentasi method.
    }
  }
}

/// Instance tunggal — dipakai lewat Riverpod provider (lihat
/// auth_provider.dart), bukan di-construct manual di widget.
final authRepository = AuthRepository(CouplivyApiClient.instance);
