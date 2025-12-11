import '../../core/models/task_model.dart';
import '../repositories/tasks_repository.dart';

class SaveTaskUseCase {
  final TasksRepository repository;

  SaveTaskUseCase(this.repository);

  Future<void> call(TaskModel task) async {
    return await repository.saveTask(task);
  }
}