import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/models/my_profile.dart';
import '../../core/storage/profile_database.dart';

/// Panggil `GET /me` (profil lengkap user sendiri) dan SYNC hasilnya ke
/// `ProfileDatabase` (database lokal, bukan cache sementara) — dipanggil
/// dari `AuthRepository._post()` setelah login/register sukses,
/// `PreviewStepScreen._submit()` setelah onboarding submit sukses, dan
/// dari `ProfileScreen` SEBAGAI FALLBACK kalau database lokal masih
/// kosong (device baru/login ulang yang belum pernah sync).
class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  Future<MyProfile> syncMyProfile() async {
    try {
      final response = await _dio.get('/me');
      final profile = MyProfile.fromJson(response.data as Map<String, dynamic>);
      await ProfileDatabase.save(profile);
      return profile;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `PATCH /me` — edit "My Profile". ONLINE-FIRST (lihat
  /// `ProfileDatabase` dokumentasi): submit ke server DULU, cuma update
  /// `ProfileDatabase` lokal kalau response sukses — TIDAK ADA optimistic
  /// write. `fields` partial (cuma field yang user ubah, lihat
  /// `UpdateProfileRequest` backend untuk daftar key yang valid), server
  /// balas profil LENGKAP terbaru (sama bentuk `GET /me`) supaya bisa
  /// langsung `ProfileDatabase.save()` tanpa panggil `syncMyProfile()`
  /// terpisah.
  Future<MyProfile> updateProfile(Map<String, dynamic> fields) async {
    try {
      final response = await _dio.patch('/me', data: fields);
      final profile = MyProfile.fromJson(response.data as Map<String, dynamic>);
      await ProfileDatabase.save(profile);
      return profile;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// `PATCH /me/preferences` — edit "My Preferences". Sama prinsip
  /// online-first dengan [updateProfile] (lihat dokumentasi itu), domain
  /// TERPISAH (dating_preferences, bukan profil dasar).
  Future<MyProfile> updatePreferences(Map<String, dynamic> fields) async {
    try {
      final response = await _dio.patch('/me/preferences', data: fields);
      final profile = MyProfile.fromJson(response.data as Map<String, dynamic>);
      await ProfileDatabase.save(profile);
      return profile;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final profileRepository = ProfileRepository(CouplivyApiClient.instance);
