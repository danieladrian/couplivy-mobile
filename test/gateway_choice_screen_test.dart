import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/gateway_choice_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

/// Widget test murni UI — tidak menyentuh network (belum ada infrastruktur
/// mocking Dio di project ini), jadi tidak menekan opsi "Mencari koneksi
/// baru" (itu akan benar-benar memanggil API). Cakupannya: opsi kedua
/// ("Sudah punya pasangan") tampil tapi non-aktif, judul dipersonalisasi
/// pakai nickname dari UserSessionStorage, dan konten teks sesuai
/// couplivy-docs/flow/00-auth/05-gateway-choice.html.
void main() {
  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/gateway-choice',
      routes: [
        GoRoute(
          path: '/gateway-choice',
          builder: (context, state) => const GatewayChoiceScreen(),
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );
  }

  testWidgets(
    'shows personalized greeting, both options, "sudah punya pasangan" disabled',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'user_session_nick_name': 'Daniel',
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: buildRouter(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hello Daniel,'), findsOneWidget);
      expect(find.text('Looking for a new connection'), findsOneWidget);
      expect(find.text('Already have a partner'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
    },
  );

  testWidgets('shows fallback greeting when nickname is not cached yet', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: buildRouter(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello,'), findsOneWidget);
  });
}
