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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'category': category,
      'image_url': imageUrl,
    };
  }

  static AchievementDto fromMap(Map<String, dynamic> map) {
    return AchievementDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      category: map['category'] as String,
      imageUrl: map['image_url'] as String?,
    );
  }
}