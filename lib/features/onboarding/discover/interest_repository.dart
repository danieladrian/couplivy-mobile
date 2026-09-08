import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/models/interest.dart';

/// Panggil `GET /api/interests` — daftar master data minat untuk render
/// chip di step Interests. Terpisah dari `DiscoverOnboardingRepository`
/// karena endpoint ini BUKAN di bawah `/onboarding/discover/*` (interests
/// adalah master data umum, bisa dipakai fitur lain di luar onboarding
/// nanti, mis. Edit Profile).
class InterestRepository {
  InterestRepository(this._dio);

  final Dio _dio;

  Future<List<Interest>> list() async {
    try {
      final response = await _dio.get('/interests');
      final body = response.data as Map<String, dynamic>;
      final rawInterests = body['interests'] as List<dynamic>;
      return rawInterests
          .map((raw) => Interest.fromJson(raw as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final interestRepository = InterestRepository(CouplivyApiClient.instance);
