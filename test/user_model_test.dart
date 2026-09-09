import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses nick_name normally when present', () {
      final user = User.fromJson({
        'id': 1,
        'full_name': 'Budi Santoso',
        'nick_name': 'Budi',
        'email': 'budi@example.com',
        'phone': '+628123456789',
        'locale': 'id',
      });

      expect(user.nickName, 'Budi');
    });

    test('nick_name null (account created before this field existed) does '
        'NOT throw — regression test for the bug that left login stuck on '
        'a permanent loading spinner (TypeError from a forced `as String` '
        'cast is not a DioException/ApiException, so it slipped past both '
        'catch clauses and never updated the loading state)', () {
      expect(
        () => User.fromJson({
          'id': 2,
          'full_name': 'Daniel',
          'nick_name': null,
          'email': 'daniel@example.com',
          'phone': '+628111222333',
          'locale': 'en',
        }),
        returnsNormally,
      );

      final user = User.fromJson({
        'id': 2,
        'full_name': 'Daniel',
        'nick_name': null,
        'email': 'daniel@example.com',
        'phone': '+628111222333',
        'locale': 'en',
      });
      expect(user.nickName, isNull);
    });
  });
}
