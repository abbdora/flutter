class LoginResult {
  final bool success;
  final String? errorMessage;

  const LoginResult({required this.success, this.errorMessage});
}

abstract class AuthRepository {
  Future<LoginResult> login(String login, String password);
  Future<void> logout();
  Future<bool> checkIfLoggedIn();

  Future<String?> getCurrentAccessToken();
  Future<void> updateAccessToken(String newToken);
  Future<bool> hasSavedCredentials();
}