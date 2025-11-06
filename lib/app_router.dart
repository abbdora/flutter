import 'package:go_router/go_router.dart';
import 'features/hours/screens/hours_screen.dart';
import 'features/intro/intro_screen.dart';
import 'features/project/screens/project_screen.dart';
import 'features/rating/screens/rating_screen.dart';
import 'features/tasks/screens/tasks_screen.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/intro',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/intro',
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'rating',
          builder: (context, state) => const RatingScreen(),
        ),
        GoRoute(
          path: 'project',
          builder: (context, state) => const ProjectScreen(),
        ),
        GoRoute(
          path: 'hours',
          builder: (context, state) => const HoursScreen(),
        ),
        GoRoute(
          path: 'tasks',
          builder: (context, state) => const TasksScreen(),
        ),
      ],
    ),
  ],
);