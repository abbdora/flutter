import '../../core/models/github_repository_model.dart';
import '../repositories/portfolio_repository.dart';

class GetRepoDetailsUseCase {
  final PortfolioRepository repository;

  GetRepoDetailsUseCase({required this.repository});

  Future<GithubRepositoryModel> execute(String owner, String repo) async {
    if (owner.isEmpty || repo.isEmpty) {
      throw ArgumentError('Владелец и название репозитория обязательны');
    }

    try {
      final project = await repository.getGithubRepo(owner, repo);
      return project;
    } catch (e) {
      throw Exception('Не удалось загрузить детали репозитория: $e');
    }
  }
}