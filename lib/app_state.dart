import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final String workStatus;
  final String currentProject;
  final VoidCallback onChangeStatus;
  final VoidCallback onNextProject;

  const AppState({
    super.key,
    required this.workStatus,
    required this.currentProject,
    required this.onChangeStatus,
    required this.onNextProject,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppState oldWidget) {
    return workStatus != oldWidget.workStatus ||
        currentProject != oldWidget.currentProject;
  }
}

