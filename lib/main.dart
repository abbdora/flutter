import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_aapp/features/project/screens/project_screen.dart';
import 'package:test_aapp/features/rating/screens/rating_screen.dart';
import 'package:test_aapp/features/tasks/screens/tasks_screen.dart';
import 'package:test_aapp/features/hours/screens/hours_screen.dart';

import 'features/hours/models/hour.dart';
import 'features/hours/screens/hour_form_screen.dart';
import 'features/hours/state/hours_container.dart';

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
      home: const MainScreen(initialIndex: 0),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, required this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<String> _appBarTitles = [
    'Профиль',
    'Рейтинг',
    'Проект',
    'Учёт времени'
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(initialIndex: index),
        ),
      );
    }
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const ProfileScreen();
      case 1:
        return RatingScreen(
          currentRating: 4.2,
          onRatingUpdated: (newRating) {},
        );
      case 2:
        return ProjectScreen(
          currentProject: "Flutter",
          onProjectUpdated: (newProject) {},
        );
      case 3:
        return const HoursContainer();
      default:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_appBarTitles[_currentIndex]),
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Рейтинг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Проект',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Время',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String workStatus = "Безработный";
  int completedTasks = 3;
  double workRating = 4.2;
  String currentProject = "Flutter";
  int workHours = 120;

  String _url = 'https://foni.papik.pro/uploads/posts/2024-10/foni-papik-pro-v0do-p-kartinki-ofisnii-rabotnik-na-prozrachnom-f-14.png';

  final List<Hour> hoursList = [
    Hour(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectName: 'Проект на Flutter',
      hours: 3,
      minutes: 30,
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Абаренова Дарья Дмитриевна',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.pinkAccent,
                )),
            const SizedBox(height: 50),

            Container(
              width: 350,
              height: 255,
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

          ],
        ),
      ),
    );
  }
}