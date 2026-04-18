import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/pages/main_navigation_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/queue_tracker/presentation/pages/checkout_page.dart';

class ArenaFlowApp extends StatelessWidget {
  ArenaFlowApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    initialLocation: '/login', // Start at login to demonstrate Auth restriction capability
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final itemName = extras?['item'] as String? ?? 'Item';
          final isDelivery = extras?['isDelivery'] as bool? ?? false;
          return CheckoutPage(itemName: itemName, isDelivery: isDelivery);
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArenaFlow',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
