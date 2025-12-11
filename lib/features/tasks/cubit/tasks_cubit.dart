import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/task_model.dart';
import '../../../../domain/usecases/get_tasks_usecase.dart';
import '../../../../domain/usecases/save_task_usecase.dart';
import '../../../../domain/usecases/update_task_usecase.dart';
import '../../../../domain/usecases/delete_task_usecase.dart';

class TasksState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;

  const TasksState({
    required this.tasks,
    this.isLoading = false,
    this.error,
  });

  factory TasksState.initial() => const TasksState(
    tasks: [],
    isLoading: false,
    error: null,
  );

  TasksState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase _getTasksUseCase;
  final SaveTaskUseCase _saveTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TasksCubit({
    required GetTasksUseCase getTasksUseCase,
    required SaveTaskUseCase saveTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  }) : _getTasksUseCase = getTasksUseCase,
        _saveTaskUseCase = saveTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        super(TasksState.initial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));
    try {
      final tasks = await _getTasksUseCase();
      emit(state.copyWith(
        tasks: tasks,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки задач: $e',
      ));
    }
  }

  Future<void> addTask(String name) async {
    if (name.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));
    try {
      final newTask = TaskModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        completed: false,
        deadline: '',
        category: '',
      );

      await _saveTaskUseCase(newTask);
      await loadTasks(); // Перезагружаем список
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка добавления задачи: $e',
      ));
    }
  }

  Future<void> updateTaskDetails({
    required String taskId,
    required String deadline,
    required String category,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final task = state.tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(
        deadline: deadline,
        category: category,
      );

      await _updateTaskUseCase(updatedTask);
      final updatedTasks = state.tasks
          .map((t) => t.id == taskId ? updatedTask : t)
          .toList();

      emit(state.copyWith(
        tasks: updatedTasks,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка обновления задачи: $e',
      ));
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final task = state.tasks.firstWhere((t) => t.id == taskId);
      final updatedTask = task.copyWith(
        completed: !task.completed,
      );

      await _updateTaskUseCase(updatedTask);
      final updatedTasks = state.tasks
          .map((t) => t.id == taskId ? updatedTask : t)
          .toList();

      emit(state.copyWith(
        tasks: updatedTasks,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка обновления задачи: $e',
      ));
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _deleteTaskUseCase(taskId);
      final updatedTasks = state.tasks
          .where((t) => t.id != taskId)
          .toList();

      emit(state.copyWith(
        tasks: updatedTasks,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка удаления задачи: $e',
      ));
    }
  }
}