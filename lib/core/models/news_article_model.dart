class NewsArticleModel {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;
  final String? author;
  final String sourceName;
  final String? category;

  NewsArticleModel({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    this.author,
    required this.sourceName,
    this.category,
  });

  String get formattedPublishedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин. назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} д. назад';
    }
    return '${publishedAt.day}.${publishedAt.month}.${publishedAt.year}';
  }

  bool get hasImage => urlToImage != null && urlToImage!.isNotEmpty;
}

class NewsSourceModel {
  final String id;
  final String name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  NewsSourceModel({
    required this.id,
    required this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });
}