import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_aapp/main.dart';
import 'package:test_aapp/features/hours/screens/hour_form_screen.dart';

import 'features/tasks/screens/tasks_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/profile',
    ),

    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(initialIndex: 0),
      ),
    ),
    GoRoute(
      path: '/rating',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(initialIndex: 1),
      ),
    ),

    GoRoute(
      path: '/project',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(initialIndex: 2),
      ),
      routes: [
        GoRoute(
          path: 'tasks',
          pageBuilder: (context, state) => MaterialPage(
            child: const TasksScreen(),
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/hours',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const MainScreen(initialIndex: 3),
      ),
      routes: [
        GoRoute(
          path: 'form',
          pageBuilder: (context, state) => MaterialPage(
            child: const HourFormScreen(),
          ),
        ),
      ],
    ),
  ],
);