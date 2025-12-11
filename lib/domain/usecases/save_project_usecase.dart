import '../../core/models/project_model.dart';
import '../repositories/projects_repository.dart';

class SaveProjectUseCase {
  final ProjectsRepository repository;

  SaveProjectUseCase(this.repository);

  Future<void> call(ProjectModel project) async {
    return await repository.saveProject(project);
  }
}