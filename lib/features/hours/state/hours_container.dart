import 'package:flutter/material.dart';
import '../models/hour.dart';
import '../screens/hours_screen.dart';

class HoursContainer extends StatefulWidget {
  const HoursContainer({super.key});

  @override
  State<HoursContainer> createState() => _HoursContainerState();
}

class _HoursContainerState extends State<HoursContainer> {
  final List<Hour> _hours = [];

  Hour? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  void _addHour(Hour hour) {
    setState(() {
      _hours.add(hour);
    });
  }

  void _removeHour(String id) {
    final index = _hours.indexWhere((h) => h.id == id);
    if (index == -1) return;

    setState(() {
      _recentlyDeleted = _hours[index];
      _recentlyDeletedIndex = index;
      _hours.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Проект удалён'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
              setState(() {
                _hours.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
              });
            }
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HoursScreen(
    );
  }
}
