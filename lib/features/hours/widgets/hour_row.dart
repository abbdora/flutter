import 'package:flutter/material.dart';
import '../models/hour.dart';

class HourRow extends StatelessWidget {
  final Hour hour;
  final ValueChanged<String> onRemove;

  const HourRow({
    super.key,
    required this.hour,
    required this.onRemove,
  });

  String _formatTime(int hours, int minutes) {
    if (hours == 0) return '${minutes}м';
    if (minutes == 0) return '${hours}ч';
    return '${hours}ч ${minutes}м';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      key: ValueKey(hour.id),
      leading: Icon(Icons.work, color: Colors.blue),
      title: Text(
        hour.projectName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _formatTime(hour.hours, hour.minutes),
        style: TextStyle(color: colorScheme.secondary),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: colorScheme.error),
        onPressed: () => onRemove(hour.id),
      ),
    );
  }
}

