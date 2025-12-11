import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/task_model.dart';
import '../cubit/tasks_cubit.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _taskController = TextEditingController();
  final String _fixedImageUrl = 'https://1gai.ru/uploads/posts/2020-01/1580109107_885544.jpg';

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _showTaskDetailsDialog(BuildContext context, TaskModel task) {
    final tasksCubit = context.read<TasksCubit>();
    final deadlineController = TextEditingController(text: task.deadline);
    final categoryController = TextEditingController(text: task.category);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(task.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: deadlineController,
                decoration: const InputDecoration(
                  labelText: 'Срок выполнения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                tasksCubit.updateTaskDetails(
                  taskId: task.id,
                  deadline: deadlineController.text.trim(),
                  category: categoryController.text.trim(),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Удалить задачу?'),
          content: Text('Вы уверены, что хотите удалить задачу:\n"${task.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                context.read<TasksCubit>().deleteTask(task.id);
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (state.isLoading && state.tasks.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Задачи проектов'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TasksState state) {
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TasksCubit>().loadTasks(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final tasksCubit = context.read<TasksCubit>();

    return Column(
      children: [
        _buildImageSection(),
        const SizedBox(height: 16),
        _buildTaskCounter(state.tasks.length),
        const SizedBox(height: 16),
        _buildAddTaskSection(context, tasksCubit),
        const SizedBox(height: 16),
        _buildTasksList(context, state.tasks, tasksCubit),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: 350,
          height: 255,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              imageUrl: _fixedImageUrl,
              fit: BoxFit.contain,
              progressIndicatorBuilder: (context, url, progress) =>
                  Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 24),
                      SizedBox(height: 4),
                      Text('Ошибка', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCounter(int tasksCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Количество задач:',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '$tasksCount',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskSection(BuildContext context, TasksCubit tasksCubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Введите задачу проекта',
                border: OutlineInputBorder(),
                labelText: 'Новая задача',
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  tasksCubit.addTask(value.trim());
                  _taskController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final taskName = _taskController.text.trim();
              if (taskName.isNotEmpty) {
                tasksCubit.addTask(taskName);
                _taskController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<TaskModel> tasks, TasksCubit tasksCubit) {
    if (tasks.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.task, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Задачи проекта отсутствуют',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Text(
                'Добавьте первую задачу',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              onTap: () => _showTaskDetailsDialog(context, task),
              leading: Checkbox(
                value: task.completed,
                onChanged: (value) {
                  tasksCubit.toggleTaskCompletion(task.id);
                },
              ),
              title: Text(
                task.name,
                style: TextStyle(
                  fontSize: 16,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.deadline.isNotEmpty)
                    Text('Срок: ${task.deadline}'),
                  if (task.category.isNotEmpty)
                    Text('Категория: ${task.category}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(context, task),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}