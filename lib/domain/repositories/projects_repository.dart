import '../../core/models/project_model.dart';

abstract class ProjectsRepository {
  Future<List<ProjectModel>> getAllProjects();
  Future<void> saveProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(String id);
}