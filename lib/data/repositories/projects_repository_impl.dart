import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects/projects_local_data_source.dart';
import '../datasources/projects/project_mapper.dart';
import '../../core/models/project_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsLocalDataSource _localDataSource;

  ProjectsRepositoryImpl(this._localDataSource);

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    final dtos = await _localDataSource.getAllProjects();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> saveProject(ProjectModel project) async {
    final dto = project.toDto();
    await _localDataSource.saveProject(dto);
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    final dto = project.toDto();
    await _localDataSource.updateProject(dto);
  }

  @override
  Future<void> deleteProject(String id) async {
    await _localDataSource.deleteProject(id);
  }
}