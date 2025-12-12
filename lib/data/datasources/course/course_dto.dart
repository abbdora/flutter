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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'platform': platform,
      'date_completed': dateCompleted,
      'status': status,
      'has_certificate': hasCertificate ? 1 : 0,
    };
  }

  static CourseDto fromMap(Map<String, dynamic> map) {
    return CourseDto(
      id: map['id'] as String,
      title: map['title'] as String,
      platform: map['platform'] as String,
      dateCompleted: map['date_completed'] as String,
      status: map['status'] as String,
      hasCertificate: map['has_certificate'] == 1,
    );
  }
}