import 'package:dio/dio.dart';
import './interceptors/logging_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient({String baseUrl = 'https://api.github.com/'})
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'PortfolioApp',
      },
    ),
  ) {
    _dio.interceptors.add(LoggingInterceptor());
  }

  Dio get dio => _dio;
}