import '../../core/models/news_article_model.dart';
import '../repositories/news_repository.dart';

class SearchNewsUseCase {
  final NewsRepository repository;

  SearchNewsUseCase({required this.repository});

  Future<List<NewsArticleModel>> execute({
    required String query,
    String? sortBy,
    String? language,
  }) async {
    if (query.isEmpty) {
      throw ArgumentError('Поисковый запрос не может быть пустым');
    }

    try {
      return await repository.searchNews(
        query: query,
        sortBy: sortBy,
        language: language,
      );
    } catch (e) {
      throw Exception('Ошибка в UseCase поиска: $e');
    }
  }
}