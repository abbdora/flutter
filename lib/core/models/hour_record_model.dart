class HourRecordModel {
  final String id;
  final String projectName;
  final String task;
  final int hours;
  final int minutes;
  final String date;

  const HourRecordModel({
    required this.id,
    required this.projectName,
    required this.task,
    required this.hours,
    required this.minutes,
    required this.date,
  });

  HourRecordModel copyWith({
    String? id,
    String? projectName,
    String? task,
    int? hours,
    int? minutes,
    String? date,
  }) {
    return HourRecordModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      task: task ?? this.task,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      date: date ?? this.date,
    );
  }
}