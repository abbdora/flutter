import 'package:flutter_bloc/flutter_bloc.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String status;
  final int progress;
  final List<String> performers;
  final String detailedDescription;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.progress,
    required this.performers,
    required this.detailedDescription,
  });

  Project copyWith({
    String? name,
    String? description,
    String? status,
    int? progress,
    List<String>? performers,
    String? detailedDescription,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: this.imageUrl,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      performers: performers ?? this.performers,
      detailedDescription: detailedDescription ?? this.detailedDescription,
    );
  }
}

class ProjectState {
  final List<Project> projects;
  final Project? selectedProject;

  const ProjectState({
    required this.projects,
    this.selectedProject,
  });

  ProjectState copyWith({
    List<Project>? projects,
    Project? selectedProject,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
    );
  }
}

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit()
      : super(
    ProjectState(
      projects: [
        Project(
          id: '1',
          name: 'Мобильное приложение "Рабочее портфолио"',
          description: 'Разработка Flutter приложения для учета рабочих проектов',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ8nqfnmxH7hXRfEUDHi2JtMDf3_Ox69iS2g&s',
          status: 'В разработке',
          progress: 75,
          performers: ['Иванов А.П.'],
          detailedDescription: 'Полнофункциональное мобильное приложение для управления рабочими проектами, задачами и временем.',
        ),
        Project(
          id: '2',
          name: 'Корпоративный портал',
          description: 'Веб-приложение для внутреннего использования компании',
          imageUrl: 'https://habrastorage.org/files/813/b47/91f/813b4791fb274fa98ab8bdb7eec03acb.png',
          status: 'Завершен',
          progress: 100,
          performers: ['Смирнов Д.И.', 'Козлова Е.В.'],
          detailedDescription: 'Корпоративный портал с системой документооборота и коммуникации сотрудников.',
        ),
        Project(
          id: '3',
          name: 'E-commerce платформа',
          description: 'Интернет-магазин с системой управления заказами',
          imageUrl: 'https://eurobyte.ru/img/articles/plyusy-i-minusy-internet-magazina/image1.png',
          status: 'В планах',
          progress: 0,
          performers: ['Федоров П.С.'],
          detailedDescription: 'Многофункциональная платформа для онлайн-торговли с интеграцией платежных систем.',
        ),
        Project(
          id: '4',
          name: 'Система аналитики',
          description: 'Дашборд для анализа бизнес-показателей',
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/2721/2721264.png',
          status: 'На паузе',
          progress: 30,
          performers: ['Николаева О.Л.', 'Васильев И.Д.', 'Морозова Т.П.'],
          detailedDescription: 'Система визуализации и анализа ключевых бизнес-метрик в реальном времени.',
        ),
      ],
    ),
  );

  void updateProjectProgress(String projectId, int newProgress) {
    final updatedProjects = state.projects.map((project) {
      if (project.id == projectId) {
        String newStatus = _getStatusByProgress(newProgress);
        return project.copyWith(progress: newProgress, status: newStatus);
      }
      return project;
    }).toList();

    emit(state.copyWith(projects: updatedProjects));
  }

  void updateProjectStatus(String projectId, String newStatus) {
    final updatedProjects = state.projects.map((project) {
      if (project.id == projectId) {
        return project.copyWith(status: newStatus);
      }
      return project;
    }).toList();

    emit(state.copyWith(projects: updatedProjects));
  }

  void updateProjectPerformers(String projectId, List<String> newPerformers) {
    final updatedProjects = state.projects.map((project) {
      if (project.id == projectId) {
        return project.copyWith(performers: newPerformers);
      }
      return project;
    }).toList();

    emit(state.copyWith(projects: updatedProjects));
  }

  void updateProjectDescription(String projectId, String newDescription) {
    final updatedProjects = state.projects.map((project) {
      if (project.id == projectId) {
        return project.copyWith(detailedDescription: newDescription);
      }
      return project;
    }).toList();

    emit(state.copyWith(projects: updatedProjects));
  }

  void selectProject(Project project) {
    emit(state.copyWith(selectedProject: project));
  }

  void clearSelection() {
    emit(state.copyWith(selectedProject: null));
  }

  String _getStatusByProgress(int progress) {
    if (progress == 0) return 'В планах';
    if (progress < 100) return 'В разработке';
    return 'Завершен';
  }
}