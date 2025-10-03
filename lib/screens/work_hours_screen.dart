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
    return '${hours}ч ${mins}м';
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
}