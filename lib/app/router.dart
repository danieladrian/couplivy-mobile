import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/debug/debug_profile_db_screen.dart';
import '../features/main_nav/main_navigation_screen.dart';
import '../features/onboarding/discover/bio_step_screen.dart';
import '../features/onboarding/discover/dob_step_screen.dart';
import '../features/onboarding/discover/future_step_screen.dart';
import '../features/onboarding/discover/gender_step_screen.dart';
import '../features/onboarding/discover/interests_step_screen.dart';
import '../features/onboarding/discover/lifestyle_step_screen.dart';
import '../features/onboarding/discover/photos_step_screen.dart';
import '../features/onboarding/discover/preferences_step_screen.dart';
import '../features/onboarding/discover/preview_step_screen.dart';
import '../features/onboarding/discover/relationship_goal_step_screen.dart';
import '../features/onboarding/discover/work_education_step_screen.dart';
import '../features/onboarding/gateway_choice_screen.dart';
import '../features/profile/app_settings_screen.dart';
import '../features/profile/my_preferences_screen.dart';
import '../features/profile/my_profile_screen.dart';
import '../features/profile/privacy_settings_screen.dart';
import '../features/profile/terms_screen.dart';
import '../features/profile/widgets/coming_soon_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/welcome/welcome_screen.dart';
import '../l10n/generated/app_localizations.dart';

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
        path: '/onboarding/discover/lifestyle',
        name: 'onboarding-discover-lifestyle',
        builder: (context, state) => const LifestyleStepScreen(),
      ),
      GoRoute(
        path: '/onboarding/discover/future',
        name: 'onboarding-discover-future',
        builder: (context, state) => const FutureStepScreen(),
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
      // Route utama app SETELAH onboarding/login selesai — 3-tab
      // container (Discover, Connections, Profile, lihat
      // MainNavigationScreen), BUKAN cuma fitur Discover. Path `/main`
      // (GANTI dari `/discover` lama — nama lama menyesatkan, seolah
      // halaman ini cuma fitur Discover padahal isinya 3 tab).
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/profile/my-profile',
        name: 'profile-my-profile',
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: '/profile/preferences',
        name: 'profile-preferences',
        builder: (context, state) => const MyPreferencesScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        name: 'profile-privacy',
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        name: 'profile-settings',
        builder: (context, state) => const AppSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/terms',
        name: 'profile-terms',
        builder: (context, state) => const TermsScreen(),
      ),
      // Notifications, Safety & Reporting, Upgrade to Plus — TABEL/LOGIC
      // BELUM ADA sama sekali di backend (beda dari Privacy yang tabelnya
      // sudah ada), placeholder generik dulu supaya menu tidak dead-end.
      // Dibangun penuh di sesi terpisah (lihat .ai/rules/architecture.md).
      GoRoute(
        path: '/profile/notifications',
        name: 'profile-notifications',
        builder: (context, state) => ComingSoonScreen(
          title: AppLocalizations.of(context).profileMenuNotifications,
        ),
      ),
      GoRoute(
        path: '/profile/safety',
        name: 'profile-safety',
        builder: (context, state) => ComingSoonScreen(
          title: AppLocalizations.of(context).profileMenuSafety,
        ),
      ),
      GoRoute(
        path: '/profile/upgrade',
        name: 'profile-upgrade',
        builder: (context, state) => ComingSoonScreen(
          title: AppLocalizations.of(context).profileUpgradeTitle,
        ),
      ),
      // Debug-only — dump mentah ProfileDatabase, dibuka lewat tap badge
      // route (lihat DebugRouteOverlay). Tidak pernah dinavigasi dari
      // alur app production manapun.
      GoRoute(
        path: '/debug/profile-db',
        name: 'debug-profile-db',
        builder: (context, state) => const DebugProfileDbScreen(),
      ),
    ],
  );
}
