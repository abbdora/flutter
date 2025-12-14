import '../../core/models/github_repository_model.dart';
import '../repositories/portfolio_repository.dart';

class SearchGithubReposUseCase {
  final PortfolioRepository repository;

  SearchGithubReposUseCase({required this.repository});

  Future<List<GithubRepositoryModel>> execute(String query) async {
    if (query.isEmpty) {
      throw ArgumentError('Поисковый запрос не может быть пустым');
    }

    try {
      final projects = await repository.searchProjects(query);
      return projects;
    } catch (e) {
      throw Exception('Не удалось выполнить поиск: $e');
    }
  }
}