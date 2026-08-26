import 'package:go_router/go_router.dart';
import 'package:proviers/features/analytics/view/analytics_screen.dart';
import 'package:proviers/features/calendar/view/calendar_screen.dart';
import 'package:proviers/features/dashboard/view/dashboard_screen.dart';
import 'package:proviers/features/profile/view/profile_screen.dart';
import 'package:proviers/features/reflection/view/reflecton_screen.dart';
import 'package:proviers/features/study/view/study_session_screen.dart';
import 'package:proviers/features/splash/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:proviers/features/study/viewmodel/study_session_viewmodel.dart';
import 'package:proviers/navigation/view/main_navigation.dart';
import '../../features/assignment/view/assignment_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/exam_dates/view/exam_date_screen.dart';
import '../../features/subject/view/subject_screen.dart';
import 'app_routes.dart';
import '../../features/profile/view/profile_setup_screen.dart';



class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [

      // ─────────────────────────────
      // SPLASH
      // ─────────────────────────────

      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) {
          return const ProfileSetupScreen();
        },
      ),

      // ─────────────────────────────
      // MAIN APP WITH BOTTOM NAVIGATION
      // ─────────────────────────────

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigation(
            navigationShell: navigationShell,
          );
        },

        branches: [

          // ───────── DASHBOARD ─────────

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) {
                  return const DashboardScreen();
                },
              ),
            ],
          ),

          // ───────── CALENDAR-------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.calendar,
                builder: (context, state) {
                  return const CalendarScreen();
                },
              ),
            ],
          ),

          // ───────── ANALYTICS─----------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.analytics,
                builder: (context, state) {
                  return const AnalyticsScreen();
                },
              ),
            ],
          ),

          // ───────── PROFILE───

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) {
                  return const ProfileScreen();
                },
              ),
            ],
          ),
        ],
      ),

      // ─────────────────────────────
      // SECONDARY SCREENS
      // ─────────────────────────────

      GoRoute(
        path: AppRoutes.reflection,
        builder: (context, state) {
          return const DailyReflectionScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.study,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => StudyViewModel(),
            child: const StudySessionScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.subjects,
        builder: (context, state) => const SubjectsScreen(),
      ),

     GoRoute(
        path: AppRoutes.examDates,
        builder: (context, state) => const ExamDatesScreen(),
      ),

       GoRoute(
        path: AppRoutes.assignments,
        builder: (context, state) => const AssignmentsScreen(),
      ),

    ],
  );
}
