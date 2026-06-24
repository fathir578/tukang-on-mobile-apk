import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/home_screen.dart';
import '../../features/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/tukang/presentation/tukang_list_screen.dart';
import '../../features/tukang/presentation/tukang_form_screen.dart';

final _authProvider = AuthProvider();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/tukang/create',
        builder: (_, __) => const TukangFormScreen(),
      ),
      GoRoute(
        path: '/tukang/:id/edit',
        builder: (_, state) => TukangFormScreen(
          tukangId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
});
