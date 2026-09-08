import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/name_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

/// Widget test murni UI — tidak menekan Continue (itu akan simpan draft ke
/// SharedPreferences beneran lalu pindah halaman, di luar cakupan test
/// UI murni ini). Cakupannya: konten teks + progress header sesuai
/// couplivy-docs/flow/01-discover/onboarding/01-name.html, dan back
/// kembali ke Gateway Choice.
void main() {
  // NameStepScreen baca draft dari SharedPreferences di initState —
  // tanpa mock ini, `getInstance()` di widget test butuh 1 microtask
  // ekstra untuk resolve method channel, dan _isLoadingDraft tidak
  // pernah berubah jadi false dalam durasi pumpAndSettle default.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/name',
      routes: [
        GoRoute(
          path: '/gateway-choice',
          builder: (context, state) => const Scaffold(body: Text('Gateway')),
        ),
        GoRoute(
          path: '/onboarding/discover/name',
          builder: (context, state) => const NameStepScreen(),
        ),
      ],
    );
  }

  testWidgets('shows title, subtitle, and 1/10 progress label', (
    WidgetTester tester,
  ) async {
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

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text("This is how you'll appear on Couplivy."), findsOneWidget);
    expect(find.text('Your Name'), findsOneWidget);
    expect(find.text('1/10'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('back button returns to Gateway Choice', (
    WidgetTester tester,
  ) async {
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

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Gateway'), findsOneWidget);
  });

  testWidgets('name typed is persisted to local draft (not sent to API)', (
    WidgetTester tester,
  ) async {
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

    await tester.enterText(find.byType(TextField), 'Budi');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('onboarding_discover_draft_name'), 'Budi');
  });

  testWidgets('existing draft is pre-filled when reopening the step', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_discover_draft_name': 'Budi',
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

    expect(find.text('Budi'), findsOneWidget);
  });
}
