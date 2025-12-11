class ProjectDto {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String status;
  final int progress;
  final List<String> performers;
  final String detailedDescription;

  ProjectDto({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.progress,
    required this.performers,
    required this.detailedDescription,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'status': status,
    'progress': progress,
    'performers': performers,
    'detailedDescription': detailedDescription,
  };

  static ProjectDto fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int,
      performers: List<String>.from(json['performers'] as List),
      detailedDescription: json['detailedDescription'] as String,
    );
  }
}