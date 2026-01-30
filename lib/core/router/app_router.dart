import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../injection/injection_container.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/escalation/presentation/pages/active_escalation_page.dart';
import '../../features/escalation/presentation/pages/manual_escalation_page.dart';
import '../widgets/main_layout.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      if (authState is Unauthenticated || authState is AuthInitial) {
        final onAuthPage =
            state.uri.path == '/login' || state.uri.path == '/auth/callback';
        return onAuthPage ? null : '/login';
      }

      if (authState is Authenticated) {
        final user = authState.user;
        final onAuthPage =
            state.uri.path == '/login' || state.uri.path == '/auth/callback';
        if (onAuthPage || state.uri.path == '/') {
          if (user.isOnboarding) {
            return '/onboarding';
          }
          if (user.redirectUrl != null &&
              user.redirectUrl!.isNotEmpty &&
              user.redirectUrl!.startsWith('/') &&
              user.redirectUrl != '/') {
            return user.redirectUrl;
          }
          return '/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => BlocProvider(
              create: (context) => sl<DashboardBloc>()..add(LoadDashboard()),
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksPage(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(path: '/more', builder: (context, state) => const MorePage()),
        ],
      ),
      GoRoute(
        path: '/escalation/active',
        builder: (context, state) => const ActiveEscalationPage(),
      ),
      GoRoute(
        path: '/escalation/manual',
        builder: (context, state) => const ManualEscalationPage(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
