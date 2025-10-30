import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/hour.dart';

class HourFormScreen extends StatefulWidget {
  const HourFormScreen({super.key});

  @override
  State<HourFormScreen> createState() => _HourFormScreenState();
}

class _HourFormScreenState extends State<HourFormScreen> {
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  void _submit() {
    final project = _projectController.text.trim();
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;

    if (project.isNotEmpty && (hours > 0 || minutes > 0)) {
      final hour = Hour(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectName: project,
        hours: hours,
        minutes: minutes,
      );
      context.pop(hour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить проект'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _projectController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Название проекта',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Часы',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Минуты',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Сохранить'),
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