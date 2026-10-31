import 'package:flutter/material.dart';

import '../../core/storage/app_database.dart';

/// Halaman debug-only — dump MENTAH isi `ProfileDatabase` (tabel
/// `Profiles` + semua tabel anak) langsung dari disk, TANPA lewat
/// `ProfileDatabase.read()` (supaya bisa ketahuan kalau masalahnya ada di
/// method itu sendiri, bukan cuma di data). Dibuka lewat tap badge route
/// di pojok kiri atas (lihat `DebugRouteOverlay`) — HANYA ada di debug
/// build, tidak terdaftar di router production flow manapun.
class DebugProfileDbScreen extends StatefulWidget {
  const DebugProfileDbScreen({super.key});

  @override
  State<DebugProfileDbScreen> createState() => _DebugProfileDbScreenState();
}

class _DebugProfileDbScreenState extends State<DebugProfileDbScreen> {
  String _dump = 'Loading...';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final buffer = StringBuffer();
    final db = appDatabase;

    try {
      final profileRows = await db.select(db.profiles).get();
      buffer.writeln('=== profiles (${profileRows.length} row) ===');
      for (final row in profileRows) {
        buffer.writeln(row.toJson());
      }

      Future<void> dumpChild(String name, Future<List<dynamic>> Function() getRows) async {
        final rows = await getRows();
        buffer.writeln('\n=== $name (${rows.length} row) ===');
        for (final row in rows) {
          buffer.writeln((row as dynamic).toJson());
        }
      }

      await dumpChild('love_languages', () => db.select(db.loveLanguages).get());
      await dumpChild('profile_interests', () => db.select(db.profileInterests).get());
      await dumpChild('photos', () => db.select(db.photos).get());
      await dumpChild('preference_children', () => db.select(db.preferenceChildren).get());
      await dumpChild('preference_marriages', () => db.select(db.preferenceMarriages).get());
      await dumpChild('preference_ethnicities', () => db.select(db.preferenceEthnicities).get());
      await dumpChild('preference_religions', () => db.select(db.preferenceReligions).get());
      await dumpChild('preference_educations', () => db.select(db.preferenceEducations).get());
      await dumpChild('preference_drinkings', () => db.select(db.preferenceDrinkings).get());
      await dumpChild('preference_smokings', () => db.select(db.preferenceSmokings).get());
      await dumpChild('preference_pets', () => db.select(db.preferencePets).get());
    } catch (e, st) {
      buffer.writeln('ERROR reading database: $e\n$st');
    }

    if (mounted) {
      setState(() => _dump = buffer.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: Profile DB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _dump = 'Loading...');
              _load();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          _dump,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
        ),
      ),
    );
  }
}
