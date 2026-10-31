import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:couplivy_mobile/shared/widgets/debug_route_overlay.dart';

void main() {
  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/one',
      routes: [
        GoRoute(
          path: '/one',
          builder: (context, state) => const Scaffold(body: Text('One')),
        ),
        GoRoute(
          path: '/two',
          builder: (context, state) => const Scaffold(body: Text('Two')),
        ),
      ],
    );
  }

  testWidgets('shows the current route path in a corner badge', (
    WidgetTester tester,
  ) async {
    final router = buildRouter();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => DebugRouteOverlay(
          router: router,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('/one'), findsOneWidget);
  });

  testWidgets('updates the badge after navigating to a different route', (
    WidgetTester tester,
  ) async {
    final router = buildRouter();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => DebugRouteOverlay(
          router: router,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    router.go('/two');
    await tester.pumpAndSettle();

    expect(find.text('/one'), findsNothing);
    expect(find.text('/two'), findsOneWidget);
  });
}
