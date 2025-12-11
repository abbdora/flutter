import 'dart:async';
import 'task_dto.dart';

class TasksLocalDataSource {
  final List<TaskDto> _tasks = [
    TaskDto(
      id: '1',
      name: 'Разработать архитектуру приложения',
      completed: false,
      deadline: '',
      category: '',
    ),
    TaskDto(
      id: '2',
      name: 'Создать интерфейс пользователя',
      completed: false,
      deadline: '',
      category: '',
    ),
    TaskDto(
      id: '3',
      name: 'Протестировать функционал',
      completed: false,
      deadline: '',
      category: '',
    ),
  ];

  Future<List<TaskDto>> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_tasks);
  }

  Future<void> saveTask(TaskDto task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.add(task);
  }

  Future<void> updateTask(TaskDto task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((t) => t.id == id);
  }
}