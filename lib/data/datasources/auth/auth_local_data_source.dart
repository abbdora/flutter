import '../local/secure_storage_helper.dart';
import 'auth_dto.dart';

class AuthLocalDataSource {
  final SecureStorageHelper _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  Future<void> saveCredentials(AuthCredentialsDto credentials) async {
    await _secureStorage.saveCredentials(
      login: credentials.login,
      password: credentials.password,
      accessToken: credentials.accessToken,
      refreshToken: credentials.refreshToken,
    );
  }

  Future<AuthCredentialsDto?> getCredentials() async {
    final login = await _secureStorage.getLogin();
    final password = await _secureStorage.getPassword();
    final accessToken = await _secureStorage.getAccessToken();
    final refreshToken = await _secureStorage.getRefreshToken();
    final isLoggedIn = await _secureStorage.isLoggedIn();

    if (login == null || password == null) {
      return null;
    }

    return AuthCredentialsDto(
      login: login,
      password: password,
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      isLoggedIn: isLoggedIn,
    );
  }

  Future<bool> isUserLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  Future<String?> getLogin() async {
    return await _secureStorage.getLogin();
  }

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.saveAccessToken(token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.saveRefreshToken(token);
  }

  Future<void> saveLogin(String login) async {
    await _secureStorage.saveLogin(login);
  }

  Future<void> savePassword(String password) async {
    await _secureStorage.savePassword(password);
  }

  Future<void> clearAllCredentials() async {
    await _secureStorage.clearAll();
  }

  Future<bool> hasSavedCredentials() async {
    final login = await _secureStorage.getLogin();
    final password = await _secureStorage.getPassword();
    return login != null && password != null;
  }
}