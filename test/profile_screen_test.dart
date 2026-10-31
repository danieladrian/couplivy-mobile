import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:couplivy_mobile/core/models/my_profile.dart';
import 'package:couplivy_mobile/features/profile/profile_screen.dart';
import 'package:couplivy_mobile/features/profile/widgets/coming_soon_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

import 'test_helpers/profile_database_test_helper.dart';

void main() {
  // Database lokal profil terisi PENUH — mencegah ProfileScreen masuk
  // jalur fallback sync `GET /me` (yang akan gagal network call nyata di
  // widget test).
  const seedProfile = MyProfile(
    nickName: 'Jowy',
    fullName: 'Jowy Full Name',
    age: 29,
    bio: 'Coffee lover',
    occupation: 'Marketing Manager',
    education: 'bachelor',
    heightCm: 170,
    gender: 'female',
    ethnicity: 'east_asian',
    religion: 'christianity',
    relationshipGoal: 'serious_dating',
    drinking: 'socially',
    smoking: 'never',
    petPreference: 'love_pets',
    childrenPreference: 'open_to_children',
    marriagePreference: 'want_marriage',
    loveLanguages: ['quality_time'],
    interestSlugs: ['coffee_tea'],
    photoPaths: [],
    completenessPercent: 90,
    preferences: null,
  );

  setUp(() {
    useInMemoryAppDatabaseForTesting();
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/profile/my-profile',
          builder: (context, state) => const Scaffold(body: Text('My Profile')),
        ),
        GoRoute(
          path: '/profile/preferences',
          builder: (context, state) =>
              const Scaffold(body: Text('My Preferences')),
        ),
        GoRoute(
          path: '/profile/notifications',
          builder: (context, state) =>
              const ComingSoonScreen(title: 'Notifications'),
        ),
        GoRoute(
          path: '/profile/privacy',
          builder: (context, state) => const Scaffold(body: Text('Privacy')),
        ),
        GoRoute(
          path: '/profile/safety',
          builder: (context, state) => const ComingSoonScreen(title: 'Safety'),
        ),
        GoRoute(
          path: '/profile/settings',
          builder: (context, state) => const Scaffold(body: Text('Settings')),
        ),
        GoRoute(
          path: '/profile/terms',
          builder: (context, state) => const Scaffold(body: Text('Terms')),
        ),
        GoRoute(
          path: '/profile/upgrade',
          builder: (context, state) => const ComingSoonScreen(title: 'Plus'),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const Scaffold(body: Text('Welcome')),
        ),
      ],
    );
  }

  Widget buildApp() {
    return MaterialApp.router(
      routerConfig: buildRouter(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  testWidgets('shows profile header, completeness, and all 8 menu items', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Jowy, 29'), findsOneWidget);
    expect(find.text("Marketing Manager · Bachelor's Degree"), findsOneWidget);
    expect(find.text('Profile completeness'), findsOneWidget);
    expect(find.text('90%'), findsOneWidget);
    expect(find.text('Upgrade to Couplivy Plus'), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('My Preferences'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Privacy & Visibility'), findsOneWidget);
    expect(find.text('Safety & Reporting'), findsOneWidget);
    expect(find.text('App Settings'), findsOneWidget);
    expect(find.text('Terms & Privacy'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('tapping My Profile navigates to My Profile screen', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
  });

  testWidgets('tapping Notifications navigates to a Coming Soon placeholder', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(find.byType(ComingSoonScreen), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Log Out shows a confirmation dialog, Cancel dismisses it', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsNothing);
    // Masih di ProfileScreen, TIDAK ter-logout.
    expect(find.text('Jowy, 29'), findsOneWidget);
  });
}
