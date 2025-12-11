class HourRecordDto {
  final String id;
  final String projectName;
  final String task;
  final int hours;
  final int minutes;
  final String date;

  HourRecordDto({
    required this.id,
    required this.projectName,
    required this.task,
    required this.hours,
    required this.minutes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectName': projectName,
    'task': task,
    'hours': hours,
    'minutes': minutes,
    'date': date,
  };

  static HourRecordDto fromJson(Map<String, dynamic> json) {
    return HourRecordDto(
      id: json['id'] as String,
      projectName: json['projectName'] as String,
      task: json['task'] as String,
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
      date: json['date'] as String,
    );
  }
}