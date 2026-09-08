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
    defaultValue: 'https://couplivy.kriukgo.id/api',
  );

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
