import '../../core/models/task_model.dart';

abstract class TasksRepository {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}