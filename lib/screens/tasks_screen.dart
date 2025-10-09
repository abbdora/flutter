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
  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];

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

  void _addNewTask() {
    final taskName = _taskController.text.trim();
    if (taskName.isNotEmpty) {
      setState(() {
        _tasks.add({
          'name': taskName,
          'completed': false,
          'id': DateTime.now().millisecondsSinceEpoch,
        });
        _taskController.clear();
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Выполнено задач:', style: TextStyle(fontSize: 18)),
                Text('$_tasksCompleted/10',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 20),
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
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Введите задачу',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNewTask,
                  child: const Text('Добавить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  key: ValueKey(task['id']),
                  leading: Checkbox(
                    value: task['completed'],
                    onChanged: (value) {
                      _toggleTask(index);
                    },
                  ),
                  title: Text(
                    task['name'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}