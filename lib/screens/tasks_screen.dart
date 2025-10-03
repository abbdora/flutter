import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final int currentTasks;
  final Function(int) onTasksUpdated;

  const TasksScreen({
    super.key,
    required this.currentTasks,
    required this.onTasksUpdated,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late int _tasksCompleted;

  @override
  void initState() {
    super.initState();
    _tasksCompleted = widget.currentTasks;
  }

  void _addTask() {
    setState(() {
      if (_tasksCompleted < 10) _tasksCompleted++;
    });
  }

  void _removeTask() {
    setState(() {
      if (_tasksCompleted > 0) _tasksCompleted--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Выполнено задач:', style: TextStyle(fontSize: 18)),
            Text('$_tasksCompleted/10',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.pink)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _removeTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('-1'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('+1'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onTasksUpdated(_tasksCompleted);
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