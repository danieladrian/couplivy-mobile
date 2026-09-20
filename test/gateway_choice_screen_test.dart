import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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

      // Continue disabled sampai kartu Discover dipilih — tap kartu itu
      // sendiri TIDAK ditekan di sini (akan memicu network call
      // sungguhan, lihat catatan di atas), cukup pastikan tombol dalam
      // keadaan disabled sebelum ada pilihan.
      final continueButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );
      expect(continueButton.onPressed, isNull);
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

  testWidgets(
    'tapping the Discover card selects it (shows checkmark) and enables '
    'Continue — WITHOUT tapping Continue itself (would trigger a real '
    'network call)',
    (WidgetTester tester) async {
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

      await tester.tap(find.text('Looking for a new connection'));
      await tester.pumpAndSettle();

      // Checkmark cuma muncul pada kartu yang selected — 1 icon check
      // baru (Together tetap disabled, tidak pernah dapat checkmark).
      expect(find.byIcon(PhosphorIconsBold.check), findsOneWidget);

      final continueButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );
      expect(continueButton.onPressed, isNotNull);
    },
  );
}
