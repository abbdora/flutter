import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  String currentProject = "Flutter";
  final List<String> projects = ["Flutter", "Java", "Python", "Базы данных", "Сети"];

  void nextProject() {
    final currentIndex = projects.indexOf(currentProject);
    currentProject = projects[(currentIndex + 1) % projects.length];
  }
}

void setupLocator() {
  locator.registerSingleton<AppStateService>(AppStateService());
}
