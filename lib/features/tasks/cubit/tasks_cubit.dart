import 'package:flutter_bloc/flutter_bloc.dart';

class Task {
  final String name;
  final bool completed;
  final String deadline;
  final String category;

  const Task({
    required this.name,
    required this.completed,
    required this.deadline,
    required this.category,
  });

  Task copyWith({
    String? name,
    bool? completed,
    String? deadline,
    String? category,
  }) {
    return Task(
      name: name ?? this.name,
      completed: completed ?? this.completed,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
    );
  }
}

class TasksState {
  final List<Task> tasks;

  const TasksState({required this.tasks});

  TasksState copyWith({List<Task>? tasks}) {
    return TasksState(tasks: tasks ?? this.tasks);
  }
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState(tasks: [
    Task(
      name: 'Разработать архитектуру приложения',
      completed: false,
      deadline: '',
      category: '',
    ),
    Task(
      name: 'Создать интерфейс пользователя',
      completed: false,
      deadline: '',
      category: '',
    ),
    Task(
      name: 'Протестировать функционал',
      completed: false,
      deadline: '',
      category: '',
    ),
  ]));

  void addTask(String name) {
    if (name.trim().isNotEmpty) {
      final newTask = Task(
        name: name.trim(),
        completed: false,
        deadline: '',
        category: '',
      );
      final updatedTasks = [...state.tasks, newTask];
      emit(state.copyWith(tasks: updatedTasks));
    }
  }

  void updateTaskDetails(int index, String deadline, String category) {
    final updatedTasks = List<Task>.from(state.tasks);
    updatedTasks[index] = updatedTasks[index].copyWith(
      deadline: deadline,
      category: category,
    );
    emit(state.copyWith(tasks: updatedTasks));
  }

}