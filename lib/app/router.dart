import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/discover/discover_placeholder_screen.dart';
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
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverPlaceholderScreen(),
      ),
    ],
  );
}
