import 'dart:math';

/// Data dummy 1 kandidat Discover — SEMENTARA, belum ada backend
/// matching/recommendation sungguhan. Di-generate RANDOM sekali per sesi
/// app (lihat `DummyCandidate.generateList()`), bukan dari API. Ganti ke
/// data server asli begitu endpoint Discover/matching dibangun.
class DummyCandidate {
  const DummyCandidate({
    required this.name,
    required this.age,
    required this.occupation,
    required this.distanceKm,
    required this.compatibilityPercent,
    required this.tags,
    required this.gradientSeed,
  });

  final String name;
  final int age;
  final String occupation;
  final int distanceKm;
  final int compatibilityPercent;
  final List<String> tags;
  final int gradientSeed;

  static const _names = [
    'Sarah', 'Michelle', 'Jessica', 'Emily', 'Amanda', 'Nadia', 'Clara',
    'Fiona', 'Grace', 'Hana',
  ];
  static const _occupations = [
    'Product Designer', 'Finance Analyst', 'Teacher', 'Marketing Manager',
    'Software Engineer', 'Nurse', 'Architect', 'Photographer',
  ];
  static const _tagPool = [
    'Travel', 'Coffee', 'Hiking', 'Reading', 'Movies', 'Pilates', 'Food',
    'Music', 'Gaming', 'Yoga',
  ];

  /// Generate N kandidat RANDOM — dipanggil SEKALI saat screen pertama
  /// dibuka (lihat `DiscoverScreen`), bukan di-regenerate tiap rebuild
  /// (supaya list tidak "lompat" tiap setState lain, mis. setelah
  /// Pass/Like satu kartu).
  static List<DummyCandidate> generateList(int count, {int? seed}) {
    final random = Random(seed);
    return List.generate(count, (index) {
      final tagCount = 2 + random.nextInt(2);
      final shuffledTags = [..._tagPool]..shuffle(random);
      return DummyCandidate(
        name: _names[random.nextInt(_names.length)],
        age: 22 + random.nextInt(14),
        occupation: _occupations[random.nextInt(_occupations.length)],
        distanceKm: 1 + random.nextInt(20),
        compatibilityPercent: 55 + random.nextInt(45),
        tags: shuffledTags.take(tagCount).toList(),
        gradientSeed: random.nextInt(4),
      );
    });
  }
}
