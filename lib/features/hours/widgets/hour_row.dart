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

  double _getProgressPercentage(int hours, int minutes) {
    final totalMinutes = hours * 60 + minutes;
    return (totalMinutes / 480).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgressPercentage(hour.hours, hour.minutes);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.work_history, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hour.projectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20),
                  onPressed: () => onRemove(hour.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _formatTime(hour.hours, hour.minutes),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}% дня',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: progress > 0.7 ? Colors.orange : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
