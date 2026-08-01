import 'package:go_router/go_router.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/students/presentation/students_screen.dart';
import '../features/attendance/presentation/attendance_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/batches/presentation/batches_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/students',
        builder: (context, state) => const StudentsScreen(),
      ),
      GoRoute(
        path: '/attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/batches',
        builder: (context, state) => const BatchesScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
