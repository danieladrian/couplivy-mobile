import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/models/onboarding_status.dart';

/// Panggil endpoint onboarding di backend Laravel (routes/api.php:
/// /onboarding/*). Auth via Sanctum sudah otomatis lewat interceptor di
/// CouplivyApiClient — repository ini murni HTTP layer, sama pola dengan
/// AuthRepository.
class OnboardingRepository {
  OnboardingRepository(this._dio);

  final Dio _dio;

  /// Dipanggil Splash (setelah cek ada token tersimpan) untuk tahu mau
  /// redirect ke Onboard (dengan step yang tepat) atau Discover/Together.
  Future<OnboardingStatus> status() async {
    try {
      final response = await _dio.get('/onboarding/status');
      return OnboardingStatus.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Step 1: Gateway Choice. `mode` cuma menerima 'discover' untuk
  /// sekarang — backend menolak 'together' (fitur "Sudah Punya Pasangan"
  /// ditunda, lihat GatewayChoiceRequest).
  Future<OnboardingStatus> saveGatewayChoice({required String mode}) async {
    try {
      final response = await _dio.post(
        '/onboarding/gateway-choice',
        data: {'mode': mode},
      );
      final body = response.data as Map<String, dynamic>;

      // Endpoint ini balikin {onboarding_step, mode}, bukan bentuk penuh
      // {completed, current_step, mode} seperti /onboarding/status — susun
      // ulang ke OnboardingStatus supaya pemanggil (provider) tetap pegang
      // 1 tipe yang konsisten. `completed` selalu false di titik ini (baru
      // step pertama, bukan step terakhir).
      return OnboardingStatus(
        completed: false,
        currentStep: body['onboarding_step'] as String?,
        mode: body['mode'] as String?,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Instance tunggal — dipakai lewat Riverpod provider, bukan di-construct
/// manual di widget.
final onboardingRepository = OnboardingRepository(CouplivyApiClient.instance);
