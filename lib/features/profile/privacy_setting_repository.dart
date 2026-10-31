import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/models/privacy_settings.dart';

/// Panggil `GET`/`PATCH /privacy-settings` — halaman Privacy & Visibility.
class PrivacySettingRepository {
  PrivacySettingRepository(this._dio);

  final Dio _dio;

  Future<PrivacySettings> fetch() async {
    try {
      final response = await _dio.get('/privacy-settings');
      return PrivacySettings.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PrivacySettings> update(PrivacySettings settings) async {
    try {
      final response = await _dio.patch(
        '/privacy-settings',
        data: settings.toJson(),
      );
      return PrivacySettings.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final privacySettingRepository = PrivacySettingRepository(
  CouplivyApiClient.instance,
);
