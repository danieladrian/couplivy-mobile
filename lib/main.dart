import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// Bootstrap only — jangan taruh logic di sini. Lihat .ai/rules/architecture.md.
void main() async {
  // App dikunci portrait-only (upside-down TIDAK diikutkan — biasanya
  // membingungkan di HP karena tombol home/gesture-nav ikut kebalik).
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: CouplivyApp()));
}
