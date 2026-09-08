import 'package:dio/dio.dart';

/// Error terstruktur dari response Laravel — validation error (422) punya
/// `errors: {field: [messages]}`, error lain (401, 500, dst) cuma punya
/// `message`.
class ApiException implements Exception {
  const ApiException({required this.message, this.fieldErrors});

  final String message;
  final Map<String, List<String>>? fieldErrors;

  /// Ambil pesan error untuk 1 field tertentu (dipakai di form Sign Up/
  /// Login), null kalau tidak ada error utk field itu.
  String? errorFor(String field) => fieldErrors?[field]?.first;

  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'] as String? ?? 'Something went wrong.';
      final rawErrors = data['errors'] as Map<String, dynamic>?;

      return ApiException(
        message: message,
        fieldErrors: rawErrors?.map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      );
    }

    return ApiException(
      message:
          e.message ??
          'Could not connect to server. Check your internet connection.',
    );
  }
}
