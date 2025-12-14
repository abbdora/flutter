import '../datasources/news/news_mapper.dart';
import '../../core/models/news_article_model.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news/news_api_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDataSource _dataSource;

  NewsRepositoryImpl(this._dataSource);

  @override
  Future<List<NewsArticleModel>> getTopHeadlines({
    String? category = 'technology',
    String? language = 'en',
    String? country,
  }) async {
    try {
      final articles = await _dataSource.getTopHeadlinesByCategory(
        category: category,
        language: language,
        country: country,
      );
      return articles.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить топ новости: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> searchNews({
    required String query,
    String? sortBy = 'publishedAt',
    String? language = 'en',
  }) async {
    try {
      final articles = await _dataSource.searchNews(
        query: query,
        sortBy: sortBy,
        language: language,
      );
      return articles.toModels();
    } catch (e) {
      throw Exception('Не удалось выполнить поиск новостей: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getHeadlinesBySource({
    required String source,
  }) async {
    try {
      final articles = await _dataSource.getHeadlinesBySource(
        source: source,
      );
      return articles.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить новости источника: $e');
    }
  }

  @override
  Future<List<NewsSourceModel>> getNewsSources({
    String? category = 'technology',
    String? language = 'en',
    String? country,
  }) async {
    try {
      final sources = await _dataSource.getNewsSources(
        category: category,
        language: language,
        country: country,
      );
      return sources.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить источники: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getHeadlinesByCountryAndCategory({
    required String country,
    required String category,
  }) async {
    try {
      final articles = await _dataSource.getHeadlinesByCountryAndCategory(
        country: country,
        category: category,
      );
      return articles.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить новости: $e');
    }
  }
}