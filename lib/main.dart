import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// Bootstrap only — jangan taruh logic di sini. Lihat .ai/rules/architecture.md.
void main() {
  runApp(const ProviderScope(child: CouplivyApp()));
}
