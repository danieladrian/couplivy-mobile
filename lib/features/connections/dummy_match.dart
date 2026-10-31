import 'dart:math';

/// Data dummy 1 match (Connections) + chat-nya — SEMENTARA, belum ada
/// backend match/chat sungguhan. Di-generate RANDOM sekali per sesi app
/// (lihat `DummyMatch.generateList()`). Ganti ke data server asli
/// (match real-time, chat via websocket/polling) begitu domain
/// Connections/Chat dibangun.
class DummyMatch {
  DummyMatch({
    required this.id,
    required this.name,
    required this.age,
    required this.sharedInterests,
    required this.timeAgoLabel,
    required this.gradientSeed,
    required this.messages,
  });

  final String id;
  final String name;
  final int age;
  final List<String> sharedInterests;
  final String timeAgoLabel;
  final int gradientSeed;
  final List<DummyMessage> messages;

  static const _names = [
    'Sarah', 'Emily', 'Jessica', 'Michelle', 'Amanda', 'Nadia',
  ];
  static const _interestPool = [
    'hiking', 'coffee', 'food', 'movies', 'reading', 'pilates', 'travel',
    'music',
  ];
  static const _timeLabels = ['2m', '1h', '3h', '1d', '2d'];

  static List<DummyMatch> generateList(int count, {int? seed}) {
    final random = Random(seed);
    return List.generate(count, (index) {
      final interestCount = 2;
      final shuffled = [..._interestPool]..shuffle(random);
      return DummyMatch(
        id: 'match_$index',
        name: _names[random.nextInt(_names.length)],
        age: 24 + random.nextInt(12),
        sharedInterests: shuffled.take(interestCount).toList(),
        timeAgoLabel: _timeLabels[random.nextInt(_timeLabels.length)],
        gradientSeed: random.nextInt(4),
        messages: DummyMessage.seedConversation(random),
      );
    });
  }
}

/// 1 pesan dummy di chat room — `isMe` menentukan sisi bubble (kanan =
/// user, kiri = lawan bicara).
class DummyMessage {
  const DummyMessage({
    required this.text,
    required this.isMe,
    required this.timeLabel,
  });

  final String text;
  final bool isMe;
  final String timeLabel;

  static List<DummyMessage> seedConversation(Random random) {
    const script = [
      (text: 'Hi! Thanks for the like 💜', isMe: false, time: '10:02'),
      (
        text: 'I love your profile — we have so many similar interests!',
        isMe: false,
        time: '10:02',
      ),
      (
        text: 'Hi! Likewise! Any favorite spot around here?',
        isMe: true,
        time: '10:05',
      ),
      (
        text: 'Yes! The sunrise view nearby is incredible.',
        isMe: false,
        time: '10:08',
      ),
    ];
    return script
        .map(
          (m) => DummyMessage(text: m.text, isMe: m.isMe, timeLabel: m.time),
        )
        .toList();
  }
}
