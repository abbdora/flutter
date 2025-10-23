import 'package:cached_network_image/cached_network_image.dart';
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
    const String _url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ8nqfnmxH7hXRfEUDHi2JtMDf3_Ox69iS2g&s';
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
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center,
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