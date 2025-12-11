import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/achievements/cubit/achievements_cubit.dart';
import 'features/achievements/screens/achievements_screen.dart';
import 'features/courses/cubit/courses_cubit.dart';
import 'features/courses/screens/courses_screen.dart';
import 'features/hours/screens/hours_screen.dart';
import 'features/intro/screens/intro_screen.dart';
import 'features/main/screens/main_screen.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/project/cubit/project_cubit.dart';
import 'features/project/screens/project_screen.dart';
import 'features/rating/cubit/rating_cubit.dart';
import 'features/rating/screens/rating_screen.dart';
import 'features/tasks/cubit/tasks_cubit.dart';
import 'features/tasks/screens/tasks_screen.dart';

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
          path: 'profile',
          builder: (context, state) => BlocProvider(
            create: (context) => ProfileCubit(),
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          path: 'rating',
          builder: (context, state) => BlocProvider(
            create: (context) => RatingCubit(),
            child: const RatingScreen(),
          ),
        ),
        GoRoute(
          path: 'project',
          builder: (context, state) => BlocProvider(
            create: (context) => ProjectCubit(),
            child: const ProjectScreen(),
          ),
        ),
        GoRoute(
          path: 'hours',
          builder: (context, state) => const HoursScreen(),
        ),
        GoRoute(
          path: 'tasks',
          builder: (context, state) => BlocProvider(
            create: (context) => TasksCubit(),
            child: const TasksScreen(),
          ),
        ),
        GoRoute(
          path: 'courses',
          builder: (context, state) => BlocProvider(
            create: (context) => CoursesCubit(),
            child: const CoursesScreen(),
          ),
        ),
        GoRoute(
          path: 'achievements',
          builder: (context, state) => BlocProvider(
            create: (context) => AchievementsCubit(),
            child: const AchievementsScreen(),
          ),
        ),
      ],
    ),
  ],
);