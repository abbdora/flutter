import 'package:dio/dio.dart';
import 'github_api.dart';
import 'github_repo_dto.dart';
import 'dart:convert';

class GithubApiDataSource {
  final GithubApi _githubApi;

  GithubApiDataSource(Dio dio) : _githubApi = GithubApi(dio);

  Future<List<GithubRepoDto>> getUserRepositories(String username) async {
    try {
      return await _githubApi.getUserRepos(username, 'updated', 'desc', 50, 1);
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке репозиториев: ${e.message}');
    }
  }

  Future<GithubRepoDto> getRepository(String owner, String repo) async {
    try {
      return await _githubApi.getRepo(owner, repo);
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке репозитория: ${e.message}');
    }
  }

  Future<Map<String, int>> getRepositoryLanguages(String owner, String repo) async {
    try {
      return await _githubApi.getRepoLanguages(owner, repo);
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке языков: ${e.message}');
    }
  }

  Future<String> getRepositoryReadme(String owner, String repo) async {
    try {
      final response = await _githubApi.getRepoReadme(owner, repo);
      final content = response['content'] as String?;
      if (content != null) {
        return utf8.decode(base64.decode(content));
      }
      return 'README отсутствует';
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке README: ${e.message}');
    }
  }

  Future<List<GithubRepoDto>> searchRepositories(String query) async {
    try {
      final response = await _githubApi.searchRepos(query, 'stars', 'desc', 30, 1);
      final items = response['items'] as List;
      return items.map((item) => GithubRepoDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при поиске репозиториев: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getRepositoryContributors(String owner, String repo) async {
    try {
      final contributors = await _githubApi.getRepoContributors(owner, repo, 10);
      return contributors.map((item) => item as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке участников: ${e.message}');
    }
  }
}