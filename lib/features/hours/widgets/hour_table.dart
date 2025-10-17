import 'package:flutter/material.dart';
import '../models/hour.dart';
import 'hour_row.dart';

class HoursTable extends StatelessWidget {
  final List<Hour> hours;
  final ValueChanged<String> onRemove;

  const HoursTable({
    super.key,
    required this.hours,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: hours.length,
      itemBuilder: (context, index) {
        return HourRow(
          hour: hours[index],
          onRemove: onRemove,
        );
      },
    );
  }
}


