import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/hour.dart';
import '../widgets/hour_table.dart';
import 'hour_form_screen.dart';

class HoursScreen extends StatelessWidget {
  final List<Hour> hours;
  final ValueChanged<Hour> onHourAdded;
  final ValueChanged<String> onRemove;

  const HoursScreen({
    super.key,
    required this.hours,
    required this.onHourAdded,
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

  void _navigateToForm(BuildContext context) async {
    final Hour? newHour = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HourFormScreen()),
    );

    if (newHour != null) {
      onHourAdded(newHour);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _url = 'https://images-cdn.onlinetestpad.net/fc/49/c773895c4abaa1638494862748dc.jpg';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: _url,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ошибка',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _navigateToForm(context),
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

