import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/interest.dart';
import 'package:couplivy_mobile/core/storage/interest_cache_web.dart';

/// `Interest` tidak override `==`/`hashCode` — bandingkan lewat JSON
/// shape (bukan identity) supaya assertion di sini tidak rapuh terhadap
/// itu.
List<Map<String, Object?>> _asComparable(List<Interest> interests) => interests
    .map((i) => {'id': i.id, 'slug': i.slug, 'category': i.category})
    .toList();

void main() {
  test('readAll returns empty list before anything is written', () async {
    final cache = WebInterestCache();

    expect(await cache.readAll(), isEmpty);
  });

  test('writeAll then readAll round-trips the same interests', () async {
    final cache = WebInterestCache();
    const interests = [
      Interest(id: 1, slug: 'coffee_tea', category: 'food'),
      Interest(id: 2, slug: 'beach_trips', category: 'travel'),
    ];

    await cache.writeAll(interests);

    expect(_asComparable(await cache.readAll()), _asComparable(interests));
  });

  test('writeAll replaces the previous contents entirely', () async {
    final cache = WebInterestCache();
    await cache.writeAll(const [
      Interest(id: 1, slug: 'coffee_tea', category: 'food'),
    ]);

    await cache.writeAll(const [
      Interest(id: 2, slug: 'beach_trips', category: 'travel'),
    ]);

    expect(_asComparable(await cache.readAll()), [
      {'id': 2, 'slug': 'beach_trips', 'category': 'travel'},
    ]);
  });
}
