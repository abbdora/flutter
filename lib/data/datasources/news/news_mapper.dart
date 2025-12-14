import '../../../core/models/news_article_model.dart';
import 'news_article_dto.dart';

extension NewsArticleMapper on NewsArticleDto {
  NewsArticleModel toModel() {
    return NewsArticleModel(
      id: '${source.id ?? source.name}_${DateTime.tryParse(publishedAt)?.millisecondsSinceEpoch ?? 0}',
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: DateTime.tryParse(publishedAt) ?? DateTime.now(),
      content: content,
      author: author,
      sourceName: source.name,
    );
  }
}

extension NewsArticleListMapper on List<NewsArticleDto> {
  List<NewsArticleModel> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}

extension NewsSourceMapper on NewsSourceDto {
  NewsSourceModel toModel() {
    return NewsSourceModel(
      id: id,
      name: name,
      description: description,
      url: url,
      category: category,
      language: language,
      country: country,
    );
  }
}

extension NewsSourceListMapper on List<NewsSourceDto> {
  List<NewsSourceModel> toModels() {
    return map((dto) => dto.toModel()).toList();
  }
}