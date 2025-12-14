import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[${options.method.toUpperCase()}] ${options.uri}');
    if (options.queryParameters.isNotEmpty) {
      print('Query: ${options.queryParameters}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode;
    final method = response.requestOptions.method.toUpperCase();
    final url = response.requestOptions.uri.toString();

    final statusIcon = statusCode != null && statusCode >= 200 && statusCode < 300 ? 'ОК' : 'НЕ ОК';
    print('$statusIcon [$method] $url -> $statusCode');

    if (response.data is Map) {
      final data = response.data as Map;
      print('Keys: ${data.keys.take(5).toList()}...');
    } else if (response.data is List) {
      print('Items: ${(response.data as List).length}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('[${err.requestOptions.method.toUpperCase()}] ${err.requestOptions.uri}');
    print('${err.type}: ${err.message}');
    if (err.response != null) {
      print('Status: ${err.response!.statusCode}');
    }
    super.onError(err, handler);
  }
}