import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';

/// Panggil endpoint step 2-9 onboarding jalur "Mencari koneksi baru"
/// (mode=discover) di backend Laravel (routes/api.php:
/// /onboarding/discover/*). Terpisah dari OnboardingRepository (yang cuma
/// urus Gateway Choice, netral untuk kedua mode) — sama pola pemisahan di
/// backend (DiscoverOnboardingController/Service), disiapkan supaya jalur
/// Together nanti bisa punya repository sendiri tanpa campur.
///
/// Step "Name" (dulu step 2) DIHAPUS — nickname sekarang diisi saat Sign
/// Up (lihat `SignUpScreen`), bukan onboarding terpisah. Step 2-9 yang
/// tersisa (DOB, Gender, dst, belum ada satupun yang dibuat) disimpan
/// LOKAL di Flutter sepanjang pengisian (lihat
/// DiscoverOnboardingDraftStorage — belum dibuat lagi, dihapus bareng
/// NameStepScreen, buat ulang begitu step DOB mulai dikerjakan) —
/// SATU-SATUNYA network call ada di `complete()`, dipanggil di step
/// TERAKHIR dengan semua field sekaligus.
class DiscoverOnboardingRepository {
  DiscoverOnboardingRepository(this._dio);

  final Dio _dio;

  /// Submit semua field profil sekaligus + tandai onboarding selesai.
  /// `fields` dikumpulkan dari draft lokal — bentuknya bertambah seiring
  /// step baru ditambah (kosong `{}` sekarang, belum ada step yang dibuat).
  Future<void> complete(Map<String, dynamic> fields) async {
    try {
      await _dio.post('/onboarding/discover/complete', data: fields);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Instance tunggal — dipakai lewat Riverpod provider, bukan di-construct
/// manual di widget.
final discoverOnboardingRepository = DiscoverOnboardingRepository(
  CouplivyApiClient.instance,
);
