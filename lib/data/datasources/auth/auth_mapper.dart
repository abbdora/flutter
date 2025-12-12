import 'auth_dto.dart';


class AuthMapper {
  static Map<String, dynamic> loginRequestToMap(LoginRequestDto dto) {
    return {
      'username': dto.login,
      'password': dto.password,
    };
  }

  static LoginResponseDto mapToLoginResponse(Map<String, dynamic> json) {
    return LoginResponseDto(
      success: json['success'] ?? false,
      errorMessage: json['errorMessage'] ?? json['message'],
      accessToken: json['accessToken'] ?? json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  static AuthCredentialsDto createCredentials({
    required String login,
    required String password,
    required String accessToken,
    required String refreshToken,
  }) {
    return AuthCredentialsDto(
      login: login,
      password: password,
      accessToken: accessToken,
      refreshToken: refreshToken,
      isLoggedIn: true,
    );
  }

  static AuthCredentialsDto createDefaultCredentials() {
    return const AuthCredentialsDto(
      login: 'user@example.com',
      password: 'password123',
      accessToken: 'default_access_token',
      refreshToken: 'default_refresh_token',
      isLoggedIn: false,
    );
  }

  static bool isValidCredentials(AuthCredentialsDto? credentials) {
    if (credentials == null) return false;
    return credentials.login.isNotEmpty &&
        credentials.password.isNotEmpty &&
        credentials.isLoggedIn;
  }

  static String maskPassword(String password) {
    if (password.length <= 2) return '**';
    return '${password[0]}${'*' * (password.length - 2)}${password[password.length - 1]}';
  }
}