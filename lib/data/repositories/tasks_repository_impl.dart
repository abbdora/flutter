import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks/tasks_local_data_source.dart';
import '../datasources/tasks/task_mapper.dart';
import '../../core/models/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksLocalDataSource _localDataSource;

  TasksRepositoryImpl(this._localDataSource);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final dtos = await _localDataSource.getAllTasks();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final dto = task.toDto();
    await _localDataSource.saveTask(dto);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final dto = task.toDto();
    await _localDataSource.updateTask(dto);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);
  }
}