import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'github_repo_dto.dart';

part 'github_api.g.dart';

@RestApi(baseUrl: "https://api.github.com/")
abstract class GithubApi {
  factory GithubApi(Dio dio, {String? baseUrl}) = _GithubApi;

  @GET("users/{username}/repos")
  Future<List<GithubRepoDto>> getUserRepos(
      @Path("username") String username,
      @Query("sort") String? sort,
      @Query("direction") String? direction,
      @Query("per_page") int perPage,
      @Query("page") int page,
      );

  @GET("repos/{owner}/{repo}")
  Future<GithubRepoDto> getRepo(
      @Path("owner") String owner,
      @Path("repo") String repo,
      );

  @GET("repos/{owner}/{repo}/languages")
  Future<Map<String, int>> getRepoLanguages(
      @Path("owner") String owner,
      @Path("repo") String repo,
      );

  @GET("repos/{owner}/{repo}/readme")
  Future<dynamic> getRepoReadme(
      @Path("owner") String owner,
      @Path("repo") String repo,
      );

  @GET("search/repositories")
  Future<Map<String, dynamic>> searchRepos(
      @Query("q") String query,
      @Query("sort") String? sort,
      @Query("order") String? order,
      @Query("per_page") int perPage,
      @Query("page") int page,
      );

  @GET("repos/{owner}/{repo}/contributors")
  Future<List<dynamic>> getRepoContributors(
      @Path("owner") String owner,
      @Path("repo") String repo,
      @Query("per_page") int perPage,
      );
}