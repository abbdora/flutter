import '../../core/models/news_article_model.dart';

abstract class NewsRepository {
  // 1. Последние новости по категории
  Future<List<NewsArticleModel>> getTopHeadlines({
    String? category,
    String? language,
    String? country,
  });

  // 2. Новости по ключевому слову
  Future<List<NewsArticleModel>> searchNews({
    required String query,
    String? sortBy,
    String? language,
  });

  // 3. Новости по источнику
  Future<List<NewsArticleModel>> getHeadlinesBySource({
    required String source,
  });

  // 4. Все источники новостей
  Future<List<NewsSourceModel>> getNewsSources({
    String? category,
    String? language,
    String? country,
  });

  // 5. Новости по стране и категории
  Future<List<NewsArticleModel>> getHeadlinesByCountryAndCategory({
    required String country,
    required String category,
  });
}