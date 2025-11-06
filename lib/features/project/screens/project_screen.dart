import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../tasks/screens/tasks_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late String _project;
  int? _tasksCount;

  @override
  void initState() {
    super.initState();
    _project = "Flutter";
  }

  void _nextProject() {
    setState(() {
      final projects = ["Flutter", "Java", "Python", "Базы данных", "Сети"];
      final currentIndex = projects.indexOf(_project);
      _project = projects[(currentIndex + 1) % projects.length];
      _tasksCount = null;
    });
  }

  void _navigateToProjectTasks(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TasksScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String _url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ8nqfnmxH7hXRfEUDHi2JtMDf3_Ox69iS2g&s';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Проекты'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Текущий проект:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_project,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
                  Container(
                    width: 150,
                    height: 55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: _url,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ошибка',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),

            if (_tasksCount != null) ...[
              const SizedBox(height: 30),
              Card(
                color: Colors.blue[50],
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.task, color: Colors.blue, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Количество задач: $_tasksCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 30),
              const Card(
                color: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Нажмите "Задачи проектов" чтобы добавить задачи',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _nextProject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Следующий проект'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _navigateToProjectTasks(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Задачи проектов'),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

