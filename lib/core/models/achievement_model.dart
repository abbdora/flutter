class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;
  final String? imageUrl;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.imageUrl,
  });

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? category,
    String? imageUrl,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

