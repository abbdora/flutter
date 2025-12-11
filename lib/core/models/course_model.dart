class CourseModel {
  final String id;
  final String title;
  final String platform;
  final String dateCompleted;
  final String status; 
  final bool hasCertificate;

  const CourseModel({
    required this.id,
    required this.title,
    required this.platform,
    required this.dateCompleted,
    required this.status,
    this.hasCertificate = false,
  });

  CourseModel copyWith({
    String? id,
    String? title,
    String? platform,
    String? dateCompleted,
    String? status,
    bool? hasCertificate,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      status: status ?? this.status,
      hasCertificate: hasCertificate ?? this.hasCertificate,
    );
  }
}