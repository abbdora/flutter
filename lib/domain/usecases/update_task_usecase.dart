import '../../core/models/task_model.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.updateTask(task);
  }
}