import '../../core/models/task_model.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskModel>> call() async {
    return await repository.getAllTasks();
  }
}