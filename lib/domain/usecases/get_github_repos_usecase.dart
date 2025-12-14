import '../../core/models/github_repository_model.dart';
import '../repositories/portfolio_repository.dart';

class GetGithubReposUseCase {
  final PortfolioRepository repository;

  GetGithubReposUseCase({required this.repository});

  Future<List<GithubRepositoryModel>> execute(String username) async {
    if (username.isEmpty) {
      throw ArgumentError('Имя пользователя не может быть пустым');
    }

    if (username.length < 1) {
      throw ArgumentError('Имя пользователя слишком короткое');
    }

    try {
      final projects = await repository.getGithubRepos(username);
      projects.sort((a, b) => b.stars.compareTo(a.stars));

      return projects;
    } catch (e) {
      throw Exception('Не удалось загрузить репозитории: $e');
    }
  }
}