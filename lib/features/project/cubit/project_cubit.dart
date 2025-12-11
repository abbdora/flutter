import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/project_model.dart';
import '../../../../domain/usecases/get_projects_usecase.dart';
import '../../../../domain/usecases/update_project_usecase.dart';

class ProjectState {
  final List<ProjectModel> projects;
  final ProjectModel? selectedProject;
  final bool isLoading;
  final String? error;

  const ProjectState({
    required this.projects,
    this.selectedProject,
    this.isLoading = false,
    this.error,
  });

  factory ProjectState.initial() => const ProjectState(
    projects: [],
    isLoading: false,
    error: null,
  );

  ProjectState copyWith({
    List<ProjectModel>? projects,
    ProjectModel? selectedProject,
    bool? isLoading,
    String? error,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProjectCubit extends Cubit<ProjectState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;

  ProjectCubit({
    required GetProjectsUseCase getProjectsUseCase,
    required UpdateProjectUseCase updateProjectUseCase,
  }) : _getProjectsUseCase = getProjectsUseCase,
        _updateProjectUseCase = updateProjectUseCase,
        super(ProjectState.initial()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    emit(state.copyWith(isLoading: true));
    try {
      final projects = await _getProjectsUseCase();
      emit(state.copyWith(
        projects: projects,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки проектов: $e',
      ));
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _updateProjectUseCase(project);
      final updatedProjects = state.projects
          .map((p) => p.id == project.id ? project : p)
          .toList();
      emit(state.copyWith(
        projects: updatedProjects,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка обновления проекта: $e',
      ));
    }
  }

  // Добавить этот метод для обновления всех полей сразу
  Future<void> updateProjectWithAllFields({
    required ProjectModel project,
    required int progress,
    required String status,
    required List<String> performers,
    required String detailedDescription,
  }) async {
    final newStatus = ProjectModel.getStatusByProgress(progress);
    final updatedProject = project.copyWith(
      progress: progress,
      status: status,
      performers: performers,
      detailedDescription: detailedDescription,
    );
    await updateProject(updatedProject);
  }

  void selectProject(ProjectModel project) {
    emit(state.copyWith(selectedProject: project));
  }

  void clearSelection() {
    emit(state.copyWith(selectedProject: null));
  }

  void updateProjectProgress(ProjectModel project, int newProgress) {
    final newStatus = ProjectModel.getStatusByProgress(newProgress);
    final updatedProject = project.copyWith(
      progress: newProgress,
      status: newStatus,
    );
    updateProject(updatedProject);
  }

  void updateProjectStatus(ProjectModel project, String newStatus) {
    final updatedProject = project.copyWith(status: newStatus);
    updateProject(updatedProject);
  }

  void updateProjectPerformers(ProjectModel project, List<String> newPerformers) {
    final updatedProject = project.copyWith(performers: newPerformers);
    updateProject(updatedProject);
  }

  void updateProjectDescription(ProjectModel project, String newDescription) {
    final updatedProject = project.copyWith(detailedDescription: newDescription);
    updateProject(updatedProject);
  }
}