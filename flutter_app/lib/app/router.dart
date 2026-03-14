import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/home/presentation/pages.dart';
import 'app_navigation.dart';
import 'app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final authNotifier = ref.watch(authControllerProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authNotifier.refreshStream),
    redirect: (context, state) {
      if (auth.isInitializing) return null;

      final location = state.matchedLocation;
      final loggedIn = auth.isAuthenticated;
      final isLoginPage = location == '/login';

      if (!loggedIn) {
        return isLoginPage ? null : '/login';
      }

      if (isLoginPage || location == '/home') {
        return defaultPathForRole(auth.role);
      }

      if (location.startsWith('/app') && !canAccessLocation(auth.role, location)) {
        return defaultPathForRole(auth.role);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => defaultPathForRole(auth.role),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/app/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/app/notices',
            builder: (context, state) => const NoticesPage(),
          ),
          GoRoute(
            path: '/app/calendar',
            builder: (context, state) => const CalendarPage(),
          ),
          GoRoute(
            path: '/app/recruitment',
            builder: (context, state) => const RecruitmentPage(),
          ),
          GoRoute(
            path: '/app/club',
            builder: (context, state) => const ClubManagementPage(),
          ),
          GoRoute(
            path: '/app/members',
            builder: (context, state) => const MembersPage(),
          ),
          GoRoute(
            path: '/app/activities',
            builder: (context, state) => const ActivitiesPage(),
          ),
          GoRoute(
            path: '/app/inventory',
            builder: (context, state) => const InventoryPage(),
          ),
          GoRoute(
            path: '/app/finance',
            builder: (context, state) => const FinancePage(),
          ),
          GoRoute(
            path: '/app/my-page',
            builder: (context, state) => const MyPage(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
