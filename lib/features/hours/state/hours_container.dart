import 'package:flutter/material.dart';
import '../models/hour.dart';
import '../screens/hours_screen.dart';
import '../screens/hour_form_screen.dart';

enum HoursScreenType { list, form }

class HoursContainer extends StatefulWidget {
  const HoursContainer({super.key});

  @override
  State<HoursContainer> createState() => _HoursContainerState();
}

class _HoursContainerState extends State<HoursContainer> {
  HoursScreenType _currentScreen = HoursScreenType.list;
  final List<Hour> _hours = [];

  Hour? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  void _showForm() {
    setState(() {
      _currentScreen = HoursScreenType.form;
    });
  }

  void _showList() {
    setState(() {
      _currentScreen = HoursScreenType.list;
    });
  }

  void _addHour(Hour hour) {
    setState(() {
      _hours.add(hour);
      _currentScreen = HoursScreenType.list;
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
    Widget body = _currentScreen == HoursScreenType.list
        ? HoursScreen(
      hours: _hours,
      onAddTap: _showForm,
      onRemove: _removeHour,
    )
        : HourFormScreen(
      onSave: _addHour,
      onCancel: _showList,
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
      ),
    );
  }
}
