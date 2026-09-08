import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'router.dart';

/// Root widget aplikasi. Ditaruh di lib/app/ (bukan lib/main.dart langsung)
/// supaya main.dart tetap bootstrap-only — lihat .ai/rules/architecture.md.
///
/// Locale: default ikut bahasa HP (localeListResolutionCallback bawaan
/// MaterialApp.router lewat `supportedLocales`), fallback ke English kalau
/// bahasa HP belum didukung.
class CouplivyApp extends StatefulWidget {
  const CouplivyApp({super.key});

  @override
  State<CouplivyApp> createState() => _CouplivyAppState();
}

class _CouplivyAppState extends State<CouplivyApp> {
  // Router dibuat sekali per instance CouplivyApp (bukan singleton global)
  // — tiap kali widget test pumpWidget(CouplivyApp()) baru, router-nya
  // juga baru, tidak bawa history/lokasi dari test sebelumnya.
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Couplivy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
