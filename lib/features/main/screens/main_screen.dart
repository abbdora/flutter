import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';
import '../../../service_locator.dart';
import '../../intro/cubit/auth_cubit.dart';
import '../cubit/main_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рабочее портфолио'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Выход',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.pushReplacement('/intro');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text(
              'Выберите раздел:',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildNavigationButton(
              context: context,
              icon: Icons.person,
              label: 'Профиль',
              route: '/main/profile',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.work_outline,
              label: 'Проекты',
              route: '/main/project',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.access_time,
              label: 'Учёт времени',
              route: '/main/hours',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.star_border,
              label: 'Рейтинг',
              route: '/main/rating',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.task_alt_outlined,
              label: 'Задачи',
              route: '/main/tasks',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.menu_book,
              label: 'Курсы',
              route: '/main/courses',
            ),
            _buildNavigationButton(
              context: context,
              icon: Icons.emoji_events,
              label: 'Награды',
              route: '/main/achievements',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: () => context.push(route),
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}