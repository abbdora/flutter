class GithubRepositoryModel {
  final String id;
  final String name;
  final String fullName;
  final String? description;
  final String htmlUrl;
  final String? language;
  final int stars;
  final int forks;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<String>? topics;

  GithubRepositoryModel({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    this.language,
    required this.stars,
    required this.forks,
    required this.updatedAt,
    required this.createdAt,
    this.topics,
  });

  String get formattedUpdatedDate {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays == 0) return 'Сегодня';
    if (difference.inDays == 1) return 'Вчера';
    if (difference.inDays < 7) return '${difference.inDays} д. назад';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7} нед. назад';
    return '${updatedAt.day}.${updatedAt.month}.${updatedAt.year}';
  }

  List<String> get technologies {
    final techs = <String>[];
    if (language != null && language!.isNotEmpty) {
      techs.add(language!);
    }
    if (topics != null) {
      techs.addAll(topics!.take(3));
    }
    return techs;
  }
}