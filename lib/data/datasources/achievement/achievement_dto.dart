class AchievementDto {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;
  final String? imageUrl;

  AchievementDto({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
    'category': category,
    'imageUrl': imageUrl,
  };

  static AchievementDto fromJson(Map<String, dynamic> json) {
    return AchievementDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}