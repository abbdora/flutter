import 'package:flutter/material.dart';
import 'package:test_aapp/screens/project_screen.dart';
import 'package:test_aapp/screens/rating_screen.dart';
import 'package:test_aapp/screens/tasks_screen.dart';
import 'package:test_aapp/screens/work_hours_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String workStatus = "Безработный";
  int completedTasks = 3;
  double workRating = 4.2;
  String currentProject = "Flutter";
  int workHours = 120;

  void _changeStatus() {
    setState(() {
      if (workStatus == "Безработный") {
        workStatus = "Самозанятый";
      } else if (workStatus == "Самозанятый") {
        workStatus = "Официально трудоустроен";
      } else {
        workStatus = "Безработный";
      }
    });
  }

  void _updateTasks(int newTasks) {
    setState(() {
      completedTasks = newTasks;
    });
  }

  void _updateRating(double newRating) {
    setState(() {
      workRating = newRating;
    });
  }

  void _updateProject(String newProject) {
    setState(() {
      currentProject = newProject;
    });
  }

  void _updateWorkHours(int newHours) {
    setState(() {
      workHours = newHours;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Абаренова Дарья Дмитриевна\nИКБО-06-22\n22И1556',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.pinkAccent,
                )),
            const SizedBox(height: 30),

            // Статус работы
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Статус:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(workStatus, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _changeStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Сменить'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Кнопки навигации
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksScreen(
                    currentTasks: completedTasks,
                    onTasksUpdated: _updateTasks,
                  )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Задачи ($completedTasks/10)'),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingScreen(
                    currentRating: workRating,
                    onRatingUpdated: _updateRating,
                  )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Рейтинг (${workRating.toStringAsFixed(1)})'),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectScreen(
                    currentProject: currentProject,
                    onProjectUpdated: _updateProject,
                  )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Проект: $currentProject'),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkHoursScreen(
                    currentHours: workHours,
                    onHoursUpdated: _updateWorkHours,
                  )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Рабочее время (${_formatTime(workHours)})'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}ч ${mins}м';
  }
}
