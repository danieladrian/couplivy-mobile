import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/discover/discover_placeholder_screen.dart';
import '../features/onboarding/discover/bio_step_screen.dart';
import '../features/onboarding/discover/dob_step_screen.dart';
import '../features/onboarding/discover/gender_step_screen.dart';
import '../features/onboarding/discover/interests_step_screen.dart';
import '../features/onboarding/discover/photos_step_screen.dart';
import '../features/onboarding/discover/preferences_step_screen.dart';
import '../features/onboarding/discover/preview_step_screen.dart';
import '../features/onboarding/discover/relationship_goal_step_screen.dart';
import '../features/onboarding/discover/work_education_step_screen.dart';
import '../features/onboarding/gateway_choice_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/welcome/welcome_screen.dart';

/// Router aplikasi — URL path adalah ID setiap halaman (konvensi proyek,
/// lihat .ai/rules/architecture.md). Halaman baru = tambah GoRoute baru di
/// sini, dengan path yang jadi identitas permanen halaman itu.
///
/// SENGAJA function (bukan `final appRouter = GoRouter(...)` singleton) —
/// singleton bikin history/lokasi router BOCOR antar widget test (tiap
/// `pumpWidget` baru tetap pakai instance lama yang sudah pernah navigasi
/// di test sebelumnya). `CouplivyApp` panggil ini tiap kali di-construct.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/gateway-choice',
        name: 'gateway-choice',
        builder: (context, state) => const GatewayChoiceScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/dob',
        name: 'onboarding-discover-dob',
        builder: (context, state) => const DobStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/gender',
        name: 'onboarding-discover-gender',
        builder: (context, state) => const GenderStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/photos',
        name: 'onboarding-discover-photos',
        builder: (context, state) => const PhotosStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/bio',
        name: 'onboarding-discover-bio',
        builder: (context, state) => const BioStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/work-education',
        name: 'onboarding-discover-work-education',
        builder: (context, state) => const WorkEducationStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/interests',
        name: 'onboarding-discover-interests',
        builder: (context, state) => const InterestsStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/relationship-goal',
        name: 'onboarding-discover-relationship-goal',
        builder: (context, state) => const RelationshipGoalStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/preferences',
        name: 'onboarding-discover-preferences',
        builder: (context, state) => const PreferencesStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/preview',
        name: 'onboarding-discover-preview',
        builder: (context, state) => const PreviewStepScreen(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverPlaceholderScreen(),
      ),
    ],
  );
}
