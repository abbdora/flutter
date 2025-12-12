import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();
  static SecureStorageHelper get instance => _instance;

  late FlutterSecureStorage _storage;

  static const String _keyLogin = 'secure_login';
  static const String _keyPassword = 'secure_password';
  static const String _keyAccessToken = 'secure_access_token';
  static const String _keyRefreshToken = 'secure_refresh_token';
  static const String _keyIsLoggedIn = 'secure_is_logged_in';

  static const iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  static const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  SecureStorageHelper._internal();

  Future<void> init() async {
    _storage = const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iOSOptions,
    );
  }

  Future<void> saveLogin(String login) async {
    await _storage.write(
      key: _keyLogin,
      value: login,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> getLogin() async {
    return await _storage.read(
      key: _keyLogin,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> savePassword(String password) async {
    await _storage.write(
      key: _keyPassword,
      value: password,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> getPassword() async {
    return await _storage.read(
      key: _keyPassword,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: _keyAccessToken,
      value: token,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: _keyAccessToken,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: _keyRefreshToken,
      value: token,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: _keyRefreshToken,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    await _storage.write(
      key: _keyIsLoggedIn,
      value: isLoggedIn.toString(),
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }

  Future<bool> isLoggedIn() async {
    final value = await _storage.read(
      key: _keyIsLoggedIn,
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
    return value == 'true';
  }

  Future<void> saveCredentials({
    required String login,
    required String password,
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveLogin(login);
    await savePassword(password);
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveLoginStatus(true);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll(
      iOptions: iOSOptions,
      aOptions: androidOptions,
    );
  }
}