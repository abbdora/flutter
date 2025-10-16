import 'package:flutter/material.dart';
import '../models/hour.dart';
import '../widgets/hour_table.dart';

class HoursScreen extends StatelessWidget {
  final List<Hour> hours;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemove;

  const HoursScreen({
    super.key,
    required this.hours,
    required this.onAddTap,
    required this.onRemove,
  });

  int get totalMinutes => hours.fold(0, (sum, h) => sum + h.hours * 60 + h.minutes);

  String _formatTotalTime() {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h == 0) return '${m}м';
    if (m == 0) return '${h}ч';
    return '${h}ч ${m}м';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учёт рабочего времени'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Общее время: ${_formatTotalTime()}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add),
              label: const Text('Добавить проект'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: HoursTable(
                hours: hours,
                onRemove: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

