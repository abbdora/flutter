import 'package:dio/dio.dart';
import 'github_repo_dto.dart';

class GithubDataSource {
  final Dio _dio;

  GithubDataSource(this._dio);

  Future<List<GithubRepoDto>> getUserRepositories(String username) async {
    try {
      final response = await _dio.get(
        '/users/$username/repos',
        queryParameters: {
          'sort': 'updated',
          'direction': 'desc',
          'per_page': 50,
          'page': 1,
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => GithubRepoDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке репозиториев: ${e.message}');
    }
  }

  Future<GithubRepoDto> getRepository(String owner, String repo) async {
    try {
      final response = await _dio.get('/repos/$owner/$repo');
      return GithubRepoDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке репозитория: ${e.message}');
    }
  }

  Future<Map<String, int>> getRepositoryLanguages(String owner, String repo) async {
    try {
      final response = await _dio.get('/repos/$owner/$repo/languages');
      return Map<String, int>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Ошибка при загрузке языков: ${e.message}');
    }
  }

  Future<List<GithubRepoDto>> searchRepositories(String query) async {
    try {
      final response = await _dio.get(
        '/search/repositories',
        queryParameters: {
          'q': query,
          'sort': 'stars',
          'order': 'desc',
          'per_page': 30,
        },
      );

      final List<dynamic> items = response.data['items'];
      return items.map((item) => GithubRepoDto.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка при поиске репозиториев: ${e.message}');
    }
  }
}