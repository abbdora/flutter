import '../../core/models/github_repository_model.dart';

abstract class PortfolioRepository {
  Future<List<GithubRepositoryModel>> getGithubRepos(String username);
  Future<GithubRepositoryModel> getGithubRepo(String owner, String repoName);
  Future<Map<String, int>> getRepoLanguages(String owner, String repoName);
  Future<String> getRepoReadme(String owner, String repoName);
  Future<List<GithubRepositoryModel>> searchProjects(String query);

  Future<List<Map<String, dynamic>>> getRepoContributors(String owner, String repoName);

  Future<List<GithubRepositoryModel>> getCustomProjects();
  Future<void> addCustomProject(GithubRepositoryModel project);
  Future<void> updateCustomProject(GithubRepositoryModel project);
  Future<void> deleteCustomProject(String projectId);
}