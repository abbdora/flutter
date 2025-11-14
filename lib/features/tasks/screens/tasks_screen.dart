import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit(),
      child: Builder(
        builder: (context) {
          final tasksCubit = context.read<TasksCubit>();

          void _showTaskDetailsDialog(int index, Task task) {
            final deadlineController = TextEditingController(text: task.deadline);
            final categoryController = TextEditingController(text: task.category);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      tasksCubit.updateTaskDetails(
                        index,
                        deadlineController.text.trim(),
                        categoryController.text.trim(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            );
          }

          void _addNewTask() {
            final taskName = _taskController.text.trim();
            if (taskName.isNotEmpty) {
              tasksCubit.addTask(taskName);
              _taskController.clear();
            }
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text('Задачи проектов'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                final tasksCount = state.tasks.length;

                return Column(
                  children: [
                    Container(
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
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Ошибка',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
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
                    ),

                    Padding(
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
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _addNewTask,
                            child: const Text('Добавить'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: state.tasks.isEmpty
                          ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Задачи проекта отсутствуют',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'Добавьте первую задачу',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          return GestureDetector(
                            onTap: () => _showTaskDetailsDialog(index, task),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: ListTile(
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}