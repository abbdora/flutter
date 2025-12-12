import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/check_auth_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';

class AuthCubitState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthCubitState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthCubitState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthCubitState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}

class AuthCubit extends Cubit<AuthCubitState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthUseCase checkAuthUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthUseCase = checkAuthUseCase,
        super(const AuthCubitState()) {
    _checkAuthStatus();
  }

  Future<void> login(String login, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _loginUseCase(login, password);

    if (result.success) {
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        error: result.errorMessage,
      ));
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    emit(const AuthCubitState(isAuthenticated: false));
  }

  Future<void> _checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));

    final isAuthenticated = await _checkAuthUseCase();

    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: isAuthenticated,
    ));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}

