import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_dto.dart';
import '../datasources/auth/auth_local_data_source.dart';
import '../datasources/auth/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<LoginResult> login(String login, String password) async {
    try {
      if (login.isNotEmpty && password.isNotEmpty) {
        final accessToken = 'access_token_${DateTime.now().millisecondsSinceEpoch}';
        final refreshToken = 'refresh_token_${DateTime.now().millisecondsSinceEpoch}';

        final credentials = AuthMapper.createCredentials(
          login: login,
          password: password,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        await _localDataSource.saveCredentials(credentials);

        return const LoginResult(success: true);
      } else {
        return const LoginResult(
          success: false,
          errorMessage: 'Неверные учетные данные',
        );
      }
    } catch (e) {
      return LoginResult(
        success: false,
        errorMessage: 'Ошибка сети: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearAllCredentials();
  }

  @override
  Future<bool> checkIfLoggedIn() async {
    return await _localDataSource.isUserLoggedIn();
  }

  Future<AuthCredentialsDto?> getSavedCredentials() async {
    return await _localDataSource.getCredentials();
  }

  Future<String?> getCurrentAccessToken() async {
    return await _localDataSource.getAccessToken();
  }

  Future<void> updateAccessToken(String newToken) async {
    await _localDataSource.saveAccessToken(newToken);
  }

  Future<bool> hasSavedCredentials() async {
    return await _localDataSource.hasSavedCredentials();
  }
}