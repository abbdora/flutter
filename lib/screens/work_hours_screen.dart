import 'package:flutter/material.dart';

class WorkHoursScreen extends StatefulWidget {
  final int currentHours;
  final Function(int) onHoursUpdated;

  const WorkHoursScreen({
    super.key,
    required this.currentHours,
    required this.onHoursUpdated,
  });

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  late int _workHours;
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final List<ProjectTime> _projects = [];

  @override
  void initState() {
    super.initState();
    _workHours = widget.currentHours;
  }

  void _addHours() {
    setState(() {
      _workHours += 15;
    });
  }

  void _removeHours() {
    setState(() {
      if (_workHours >= 15) _workHours -= 15;
    });
  }

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '${mins}м';
    if (mins == 0) return '${hours}ч';
    return '${hours}ч ${mins}м';
  }

  void _addProject() {
    final projectName = _projectController.text.trim();
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;

    if (projectName.isNotEmpty && (hours > 0 || minutes > 0)) {
      final totalMinutes = hours * 60 + minutes;

      setState(() {
        _projects.add(ProjectTime(
          projectName: projectName,
          minutes: totalMinutes,
        ));
        _projectController.clear();
        _hoursController.clear();
        _minutesController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Рабочее время'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Рабочее время сегодня:', style: TextStyle(fontSize: 18)),
            Text(_formatTime(_workHours),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _projectController,
                decoration: const InputDecoration(
                  hintText: 'Название проекта',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hoursController,
                      decoration: const InputDecoration(
                        hintText: 'Часы',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: _minutesController,
                      decoration: const InputDecoration(
                        hintText: 'Минуты',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: _addProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text('Добавить'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _removeHours,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('-15 мин'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _addHours,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('+15 мин'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _projects
                      .map(
                        (project) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.work, color: Colors.blue),
                          title: Text(project.projectName),
                          subtitle: Text(_formatTime(project.minutes)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _projects.remove(project);
                              });
                            },
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onHoursUpdated(_workHours);
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

  @override
  void dispose() {
    _projectController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }
}

class ProjectTime {
  final String projectName;
  final int minutes;

  ProjectTime({
    required this.projectName,
    required this.minutes,
  });
}