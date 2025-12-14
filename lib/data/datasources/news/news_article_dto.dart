import 'package:json_annotation/json_annotation.dart';

part 'news_article_dto.g.dart';

@JsonSerializable()
class NewsArticleDto {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  @JsonKey(name: 'urlToImage') final String? urlToImage;
  @JsonKey(name: 'publishedAt') final String publishedAt;
  final String? content;

  NewsArticleDto({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory NewsArticleDto.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleDtoToJson(this);
}

@JsonSerializable()
class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
  Map<String, dynamic> toJson() => _$SourceToJson(this);
}

@JsonSerializable()
class NewsSourceDto {
  final String id;
  final String name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  NewsSourceDto({
    required this.id,
    required this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  factory NewsSourceDto.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NewsSourceDtoToJson(this);
}