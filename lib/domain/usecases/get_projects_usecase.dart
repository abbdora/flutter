import '../../core/models/project_model.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  Future<List<ProjectModel>> call() async {
    return await repository.getAllProjects();
  }
}