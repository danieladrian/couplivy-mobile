import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';

/// Panggil endpoint step 1-9 onboarding jalur "Mencari koneksi baru"
/// (mode=discover) di backend Laravel (routes/api.php:
/// /onboarding/discover/*). Terpisah dari OnboardingRepository (yang cuma
/// urus Gateway Choice, netral untuk kedua mode) — sama pola pemisahan di
/// backend (DiscoverOnboardingController/Service), disiapkan supaya jalur
/// Together nanti bisa punya repository sendiri tanpa campur.
///
/// Step "Name" (dulu step 2) DIHAPUS — nickname sekarang diisi saat Sign
/// Up. Step 1-8 disimpan LOKAL di Flutter sepanjang pengisian (lihat
/// DiscoverOnboardingDraftStorage) — DUA network call di sini, KEDUANYA
/// dipanggil bersamaan di step TERAKHIR (Preview): `complete()` (JSON,
/// field profil) dan `uploadPhotos()` (multipart, file foto) — dipisah
/// karena beda bentuk request.
class DiscoverOnboardingRepository {
  DiscoverOnboardingRepository(this._dio);

  final Dio _dio;

  /// Submit semua field profil sekaligus + tandai onboarding selesai.
  /// `fields` dikumpulkan dari draft lokal (lihat
  /// `DiscoverOnboardingDraftStorage.readAllForSubmit()`).
  Future<void> complete(Map<String, dynamic> fields) async {
    try {
      await _dio.post('/onboarding/discover/complete', data: fields);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Upload foto profil — `photoPaths` path LOKAL di device (hasil copy
  /// dari galeri ke temp dir saat step Photos, lihat
  /// `DiscoverOnboardingDraftStorage.readPhotoPaths()`). Urutan list =
  /// urutan slot, index 0 = foto utama.
  Future<void> uploadPhotos(List<String> photoPaths) async {
    try {
      final formData = FormData.fromMap({
        'photos': [
          for (final path in photoPaths) await MultipartFile.fromFile(path),
        ],
      });
      await _dio.post('/onboarding/discover/photos', data: formData);
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
