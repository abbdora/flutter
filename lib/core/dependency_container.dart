import 'package:get_it/get_it.dart';
import '../data/datasources/github/github_api_data_source.dart';
import '../data/datasources/news/news_api_data_source.dart';
import '../data/repositories/portfolio_repository_impl.dart';
import '../domain/repositories/portfolio_repository.dart';
import '../domain/repositories/news_repository.dart';
import 'dio_client.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final githubDio = DioClient(baseUrl: 'https://api.github.com/').dio;
  final githubDataSource = GithubApiDataSource(githubDio);
  getIt.registerSingleton<GithubApiDataSource>(githubDataSource);

  final newsDio = DioClient(baseUrl: 'https://newsapi.org/v2/').dio;
  final newsDataSource = NewsApiDataSource(newsDio);
  getIt.registerSingleton<NewsApiDataSource>(newsDataSource);

  final repository = PortfolioRepositoryImpl(
    githubDataSource: githubDataSource,
    newsDataSource: newsDataSource,
  );

  getIt.registerSingleton<PortfolioRepository>(repository);
  getIt.registerSingleton<NewsRepository>(repository);
}