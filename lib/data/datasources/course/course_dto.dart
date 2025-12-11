class CourseDto {
  final String id;
  final String title;
  final String platform;
  final String dateCompleted;
  final String status;
  final bool hasCertificate;

  CourseDto({
    required this.id,
    required this.title,
    required this.platform,
    required this.dateCompleted,
    required this.status,
    this.hasCertificate = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'platform': platform,
    'dateCompleted': dateCompleted,
    'status': status,
    'hasCertificate': hasCertificate,
  };

  static CourseDto fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      platform: json['platform'] as String,
      dateCompleted: json['dateCompleted'] as String,
      status: json['status'] as String,
      hasCertificate: json['hasCertificate'] as bool? ?? false,
    );
  }
}