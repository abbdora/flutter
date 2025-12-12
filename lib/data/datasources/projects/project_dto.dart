class ProjectDto {
  final String id;
  final String title;
  final String description;
  final String status;
  final int progress;
  final String? imageUrl;

  ProjectDto({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    this.imageUrl,
  });

  // Для JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'name': title,
    'description': description,
    'status': status,
    'progress': progress,
    'imageUrl': imageUrl,
    'performers': [],
    'detailedDescription': description,
  };

  static ProjectDto fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as String,
      title: json['title'] ?? json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'progress': progress,
      'image_url': imageUrl,
    };
  }

  static ProjectDto fromMap(Map<String, dynamic> map) {
    return ProjectDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      progress: map['progress'] as int,
      imageUrl: map['image_url'] as String?,
    );
  }
}