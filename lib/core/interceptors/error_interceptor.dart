import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final userMessage = _getUserMessage(err);

    final newError = DioException(
      requestOptions: err.requestOptions,
      error: err.error,
      response: err.response,
      type: err.type,
      message: userMessage,
    );

    super.onError(newError, handler);
  }

  String _getUserMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Превышено время ожидания. Проверьте интернет.';

      case DioExceptionType.connectionError:
        return 'Нет подключения к интернету.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(err);

      case DioExceptionType.cancel:
        return 'Запрос отменен.';

      case DioExceptionType.unknown:
        return 'Ошибка сети. Проверьте подключение.';

      default:
        return 'Произошла ошибка.';
    }
  }

  String _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;

    switch (statusCode) {
      case 400:
        return 'Неверный запрос.';
      case 401:
        return 'Не авторизован. Проверьте ключ API.';
      case 403:
        return 'Доступ запрещен.';
      case 404:
        return 'Ресурс не найден.';
      case 429:
        return 'Слишком много запросов. Попробуйте позже.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Ошибка сервера. Попробуйте позже.';
      default:
        return 'Ошибка соединения.';
    }
  }
}