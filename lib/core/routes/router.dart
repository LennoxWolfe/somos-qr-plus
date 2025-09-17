import 'package:go_router/go_router.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/create_account_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/two_factor_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/user_management_screen.dart';
import '../../screens/invitation_screen.dart';
import '../../screens/quality_scorecards_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/reports_screen.dart';
import '../../screens/patients_screen.dart';
import '../../screens/schedule_screen.dart';
import '../../screens/resources_screen.dart';
import '../../screens/my_invitations_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
    // Authentication routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/two-factor',
      builder: (context, state) => const TwoFactorScreen(),
    ),
    // Main app routes
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/user-management',
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      path: '/invitation',
      builder: (context, state) => const InvitationScreen(),
    ),
    GoRoute(
      path: '/my-invitations',
      builder: (context, state) => const MyInvitationsScreen(),
    ),
    GoRoute(
      path: '/quality-scorecards',
      builder: (context, state) => const QualityScorecardsScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/patients',
      builder: (context, state) => const PatientsScreen(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: '/resources',
      builder: (context, state) => const ResourcesScreen(),
    ),
  ],
); 