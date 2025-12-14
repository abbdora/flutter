import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/models/github_repository_model.dart';
import '../../core/models/news_article_model.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/github/github_api_data_source.dart';
import '../datasources/news/news_api_data_source.dart';
import '../datasources/github/github_repo_mapper.dart';
import '../datasources/news/news_mapper.dart';

class PortfolioRepositoryImpl implements PortfolioRepository, NewsRepository {
  final GithubApiDataSource githubDataSource;
  final NewsApiDataSource newsDataSource;

  PortfolioRepositoryImpl({
    required this.githubDataSource,
    required this.newsDataSource,
  });

  @override
  Future<List<GithubRepositoryModel>> getGithubRepos(String username) async {
    try {
      final repos = await githubDataSource.getUserRepositories(username);
      return repos.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить репозитории: $e');
    }
  }

  @override
  Future<GithubRepositoryModel> getGithubRepo(String owner, String repoName) async {
    try {
      final repo = await githubDataSource.getRepository(owner, repoName);
      return repo.toModel();
    } catch (e) {
      throw Exception('Не удалось загрузить репозиторий: $e');
    }
  }

  @override
  Future<Map<String, int>> getRepoLanguages(String owner, String repoName) async {
    try {
      return await githubDataSource.getRepositoryLanguages(owner, repoName);
    } catch (e) {
      throw Exception('Не удалось загрузить языки: $e');
    }
  }

  @override
  Future<String> getRepoReadme(String owner, String repoName) async {
    try {
      final response = await Dio().get<String>(
        'https://api.github.com/repos/$owner/$repoName/readme',
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3.raw'},
          responseType: ResponseType.plain,
        ),
      );

      return response.statusCode == 200 && response.data != null
          ? response.data!
          : 'README недоступен';
    } catch (_) {
      return 'Не удалось загрузить README';
    }
  }

  @override
  Future<List<GithubRepositoryModel>> searchProjects(String query) async {
    try {
      final repos = await githubDataSource.searchRepositories(query);
      return repos.toModels();
    } catch (e) {
      throw Exception('Не удалось выполнить поиск: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRepoContributors(String owner, String repoName) async {
    try {
      return await githubDataSource.getRepositoryContributors(owner, repoName);
    } catch (e) {
      print('Ошибка при загрузке участников: $e');
      return [];
    }
  }

  @override
  Future<List<GithubRepositoryModel>> getCustomProjects() async {
    return [];
  }

  @override
  Future<void> addCustomProject(GithubRepositoryModel project) async {
    // TODO
  }

  @override
  Future<void> updateCustomProject(GithubRepositoryModel project) async {
    // TODO
  }

  @override
  Future<void> deleteCustomProject(String projectId) async {
    // TODO
  }

  @override
  Future<List<NewsArticleModel>> getTopHeadlines({
    String? category = 'technology',
    String? language = 'en',
    String? country,
  }) async {
    try {
      final articles = await newsDataSource.getTopHeadlinesByCategory(
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
      final articles = await newsDataSource.searchNews(
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
      final articles = await newsDataSource.getHeadlinesBySource(
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
      final sources = await newsDataSource.getNewsSources(
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
      final articles = await newsDataSource.getHeadlinesByCountryAndCategory(
        country: country,
        category: category,
      );
      return articles.toModels();
    } catch (e) {
      throw Exception('Не удалось загрузить новости: $e');
    }
  }
}