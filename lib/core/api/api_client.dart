import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// HTTP client tunggal ke backend Laravel — dipakai semua fitur yang butuh
/// panggil API (auth, profile, dst), jangan bikin Dio instance baru di
/// tempat lain.
///
/// Base URL diarahkan ke domain production (couplivy.kriukgo.id) — BELUM
/// bisa ditest end-to-end sampai backend selesai di-deploy ke shared
/// hosting (baru database yang tersambung, kode aplikasi belum diupload).
/// Untuk dev lokal, override lewat --dart-define=API_BASE_URL=... saat
/// `flutter run` (lihat CouplivyApiClient.baseUrl).
class CouplivyApiClient {
  CouplivyApiClient._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // SEMENTARA — backend lokal (Postgres via Docker, lihat
    // couplivy-backend/.ai/rules/architecture.md) diakses lewat Tailscale
    // IP laptop ("macbook-pro" di tailnet), karena production
    // (couplivy.kriukgo.id) belum ter-deploy kode terbaru. HP WAJIB
    // terhubung ke tailnet yang sama (sudah dikonfirmasi: "daniels-a73").
    // IP ini BISA BERUBAH kalau laptop di-reset dari tailnet — cek ulang
    // dengan `tailscale ip -4` di laptop kalau koneksi gagal. KEMBALIKAN
    // ke 'https://couplivy.kriukgo.id/api' begitu deploy production
    // beres.
    defaultValue: 'http://100.72.128.55:8000/api',
  );

  /// Gabungkan path RELATIF storage (mis. `profile-photos/xxx.jpg`, dari
  /// `GET /me` — lihat `MyProfile.photoPaths`/`ProfileDatabase`) jadi URL
  /// lengkap untuk `NetworkImage`. Dilakukan DI SINI (saat render), BUKAN
  /// disimpan sebagai URL utuh di backend/ProfileDatabase — supaya ganti
  /// environment (ngrok/Tailscale/production, lihat [baseUrl]) cuma ganti
  /// konstanta ini, tidak perlu re-sync data foto yang sudah tersimpan
  /// lokal. `baseUrl` sendiri berakhiran `/api` (dipakai Dio), foto
  /// disajikan backend dari `/storage/...` (bukan di bawah `/api`) — WAJIB
  /// strip suffix itu dulu.
  static String storageUrl(String relativePath) {
    final serverRoot = baseUrl.endsWith('/api')
        ? baseUrl.substring(0, baseUrl.length - '/api'.length)
        : baseUrl;
    return '$serverRoot/storage/$relativePath';
  }

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            contentType: 'application/json',
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await TokenStorage.readToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          ),
        );

  static Dio get instance => _dio;
}
