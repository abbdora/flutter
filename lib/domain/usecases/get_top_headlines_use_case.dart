import '../../core/models/news_article_model.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesUseCase {
  final NewsRepository repository;

  GetTopHeadlinesUseCase({required this.repository});

  Future<List<NewsArticleModel>> execute({
    String? category,
    String? language,
    String? country,
  }) async {
    try {
      return await repository.getTopHeadlines(
        category: category,
        language: language,
        country: country,
      );
    } catch (e) {
      throw Exception('Ошибка в UseCase: $e');
    }
  }
}