import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<LoginResult> call(String login, String password) {
    return _repository.login(login, password);
  }
}