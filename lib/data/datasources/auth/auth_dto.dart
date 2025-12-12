class AuthCredentialsDto {
  final String login;
  final String password;
  final String accessToken;
  final String refreshToken;
  final bool isLoggedIn;

  const AuthCredentialsDto({
    required this.login,
    required this.password,
    required this.accessToken,
    required this.refreshToken,
    required this.isLoggedIn,
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'isLoggedIn': isLoggedIn,
  };

  static AuthCredentialsDto fromJson(Map<String, dynamic> json) {
    return AuthCredentialsDto(
      login: json['login'] as String,
      password: json['password'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      isLoggedIn: json['isLoggedIn'] as bool,
    );
  }
}

class LoginRequestDto {
  final String login;
  final String password;

  const LoginRequestDto({
    required this.login,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };

  static LoginRequestDto fromJson(Map<String, dynamic> json) {
    return LoginRequestDto(
      login: json['login'] as String,
      password: json['password'] as String,
    );
  }
}

class LoginResponseDto {
  final bool success;
  final String? errorMessage;
  final String? accessToken;
  final String? refreshToken;

  const LoginResponseDto({
    required this.success,
    this.errorMessage,
    this.accessToken,
    this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'errorMessage': errorMessage,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  static LoginResponseDto fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      success: json['success'] as bool,
      errorMessage: json['errorMessage'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}