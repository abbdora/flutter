import 'dart:async';
import 'project_dto.dart';

class ProjectsLocalDataSource {
  final List<ProjectDto> _projects = [
    ProjectDto(
      id: '1',
      name: 'Мобильное приложение "Рабочее портфолио"',
      description: 'Разработка Flutter приложения для учета рабочих проектов',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ8nqfnmxH7hXRfEUDHi2JtMDf3_Ox69iS2g&s',
      status: 'На паузе',
      progress: 0,
      performers: [],
      detailedDescription: '',
    ),
    ProjectDto(
      id: '2',
      name: 'Корпоративный портал',
      description: 'Веб-приложение для внутреннего использования компании',
      imageUrl: 'https://habrastorage.org/files/813/b47/91f/813b4791fb274fa98ab8bdb7eec03acb.png',
      status: 'Завершен',
      progress: 100,
      performers: [],
      detailedDescription: 'Корпоративный портал с системой документооборота и коммуникации сотрудников.',
    ),
    ProjectDto(
      id: '3',
      name: 'E-commerce платформа',
      description: 'Интернет-магазин с системой управления заказами',
      imageUrl: 'https://eurobyte.ru/img/articles/plyusy-i-minusy-internet-magazina/image1.png',
      status: 'В планах',
      progress: 0,
      performers: [],
      detailedDescription: 'Многофункциональная платформа для онлайн-торговли с интеграцией платежных систем.',
    ),
    ProjectDto(
      id: '4',
      name: 'Система аналитики',
      description: '',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/2721/2721264.png',
      status: 'На паузе',
      progress: 30,
      performers: [''],
      detailedDescription: 'Система визуализации и анализа ключевых бизнес-метрик в реальном времени.',
    ),
  ];

  Future<List<ProjectDto>> getAllProjects() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_projects);
  }

  Future<void> saveProject(ProjectDto project) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _projects.add(project);
  }

  Future<void> updateProject(ProjectDto project) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
    }
  }

  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _projects.removeWhere((p) => p.id == id);
  }
}