import 'package:dio/dio.dart';
import 'news_api.dart';
import 'news_article_dto.dart';

class NewsApiDataSource {
  static const String _apiKey = 'dc9f39ff9864455bacfd22c5a6f98406';
  final NewsApi _newsApi;

  NewsApiDataSource(Dio dio) : _newsApi = NewsApi(dio);

  Future<List<NewsArticleDto>> getTopHeadlinesByCategory({
    String? category = 'technology',
    String? language = 'en',
    String? country,
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _newsApi.getTopHeadlines(
        category: category,
        language: language,
        country: country,
        pageSize: pageSize,
        page: page,
        apiKey: _apiKey,
      );
      final articles = response['articles'] as List;
      return articles.map((item) => NewsArticleDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке новостей: ${e.message}');
    }
  }

  // 2. Новости по ключевому слову
  Future<List<NewsArticleDto>> searchNews({
    required String query,
    String? sortBy = 'publishedAt',
    String? language = 'en',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _newsApi.searchEverything(
        query: query,
        sortBy: sortBy,
        language: language,
        pageSize: pageSize,
        page: page,
        apiKey: _apiKey,
      );
      final articles = response['articles'] as List;
      return articles.map((item) => NewsArticleDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при поиске новостей: ${e.message}');
    }
  }

  // 3. Новости по источнику
  Future<List<NewsArticleDto>> getHeadlinesBySource({
    required String source,
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _newsApi.getHeadlinesBySource(
        sources: source,
        pageSize: pageSize,
        page: page,
        apiKey: _apiKey,
      );
      final articles = response['articles'] as List;
      return articles.map((item) => NewsArticleDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке новостей источника: ${e.message}');
    }
  }

  // 4. Все источники новостей
  Future<List<NewsSourceDto>> getNewsSources({
    String? category = 'technology',
    String? language = 'en',
    String? country,
  }) async {
    try {
      final response = await _newsApi.getSources(
        category: category,
        language: language,
        country: country,
        apiKey: _apiKey,
      );
      final sources = response['sources'] as List;
      return sources.map((item) => NewsSourceDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке источников: ${e.message}');
    }
  }

  // 5. Новости по стране и категории
  Future<List<NewsArticleDto>> getHeadlinesByCountryAndCategory({
    required String country,
    required String category,
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _newsApi.getHeadlinesByCountryAndCategory(
        country: country,
        category: category,
        pageSize: pageSize,
        page: page,
        apiKey: _apiKey,
      );
      final articles = response['articles'] as List;
      return articles.map((item) => NewsArticleDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке новостей: ${e.message}');
    }
  }
}