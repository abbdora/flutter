import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'news_api.g.dart';

@RestApi(baseUrl: "https://newsapi.org/v2/")
abstract class NewsApi {
  factory NewsApi(Dio dio, {String? baseUrl}) = _NewsApi;

  // 1. Последние новости по категории
  @GET("top-headlines")
  Future<Map<String, dynamic>> getTopHeadlines({
    @Query("category") String? category,
    @Query("language") String? language,
    @Query("country") String? country,
    @Query("pageSize") int pageSize = 20,
    @Query("page") int page = 1,
    @Query("apiKey") String apiKey,
  });

  // 2. Новости по ключевому слову
  @GET("everything")
  Future<Map<String, dynamic>> searchEverything({
    @Query("q") required String query,
    @Query("sortBy") String? sortBy,
    @Query("language") String? language,
    @Query("pageSize") int pageSize = 20,
    @Query("page") int page = 1,
    @Query("apiKey") String apiKey,
  });

  // 3. Новости по источнику
  @GET("top-headlines")
  Future<Map<String, dynamic>> getHeadlinesBySource({
    @Query("sources") required String sources,
    @Query("pageSize") int pageSize = 20,
    @Query("page") int page = 1,
    @Query("apiKey") String apiKey,
  });

  // 4. Все источники новостей
  @GET("top-headlines/sources")
  Future<Map<String, dynamic>> getSources({
    @Query("category") String? category,
    @Query("language") String? language,
    @Query("country") String? country,
    @Query("apiKey") String apiKey,
  });

  // 5. Новости по стране и категории
  @GET("top-headlines")
  Future<Map<String, dynamic>> getHeadlinesByCountryAndCategory({
    @Query("country") required String country,
    @Query("category") required String category,
    @Query("pageSize") int pageSize = 20,
    @Query("page") int page = 1,
    @Query("apiKey") String apiKey,
  });
}