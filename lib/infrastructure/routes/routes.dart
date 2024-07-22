import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/presentation/screens/dynamic_form_screen.dart';
import 'package:polaris/presentation/screens/home_screen.dart';
import 'package:polaris/presentation/screens/splash_screen.dart';

import '../../presentation/screens/page_not_found.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  initialLocation: RouteName.splash,
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      path: RouteName.splash,
      name: RouteName.splash,
      builder: (_, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: RouteName.home,
      name: RouteName.home,
      builder: (_, state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: "${RouteName.form}/:form",
          name: RouteName.form,
          builder: (_, state) {
            final String formName = state.pathParameters['form']?.toString() ?? '';
            return DynamicFormScreen(formName: formName);
          },
        ),
        GoRoute(
          path: RouteName.formResponse,
          name: RouteName.formResponse,
          builder: (_, state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
);
