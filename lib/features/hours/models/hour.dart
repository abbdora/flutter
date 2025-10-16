class Hour {
  final String id;
  final String projectName;
  final int hours;
  final int minutes;

  Hour({
    required this.id,
    required this.projectName,
    required this.hours,
    required this.minutes,
  });

  Hour copyWith({
    String? id,
    String? projectName,
    int? hours,
    int? minutes,
  }) {
    return Hour(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
    );
  }
}

