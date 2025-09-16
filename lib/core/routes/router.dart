import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/create_account_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/two_factor_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/quality_scorecards_tablet_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/reports_tablet_screen.dart';
import '../../screens/patients_tablet_screen.dart';
import '../../screens/schedule_tablet_screen.dart';
import '../../screens/resources_screen.dart';

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
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/quality-scorecards',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const QualityScorecardsTabletScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ReportsTabletScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),
    GoRoute(
      path: '/patients',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PatientsTabletScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/schedule',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScheduleTabletScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/resources',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ResourcesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
  ],
); 