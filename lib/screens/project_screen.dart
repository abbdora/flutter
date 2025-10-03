import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  final String currentProject;
  final Function(String) onProjectUpdated;

  const ProjectScreen({
    super.key,
    required this.currentProject,
    required this.onProjectUpdated,
  });

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late String _project;

  @override
  void initState() {
    super.initState();
    _project = widget.currentProject;
  }

  void _nextProject() {
    setState(() {
      final projects = ["Flutter", "Java", "Python", "Базы данных", "Сети"];
      final currentIndex = projects.indexOf(_project);
      _project = projects[(currentIndex + 1) % projects.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Текущий проект'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Текущий проект:', style: TextStyle(fontSize: 18)),
            Text(_project,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _nextProject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Следующий проект'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onProjectUpdated(_project);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}