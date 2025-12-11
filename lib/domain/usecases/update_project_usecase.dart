import '../../core/models/project_model.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectUseCase {
  final ProjectsRepository repository;

  UpdateProjectUseCase(this.repository);

  Future<void> call(ProjectModel project) async {
    return await repository.updateProject(project);
  }
}