import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'app_router.dart';
import 'features/intro/cubit/auth_cubit.dart';
import 'features/main/cubit/main_cubit.dart';
import 'data/datasources/local/preferences_helper.dart';
import 'data/datasources/local/secure_storage_helper.dart';
import 'data/datasources/auth/auth_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'core/dependency_container.dart';
import 'domain/usecases/check_auth_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await initDependencies();
  await PreferencesHelper.instance.init();
  await SecureStorageHelper.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorageHelper.instance;
    final authDataSource = AuthLocalDataSource(secureStorage);
    final authRepository = AuthRepositoryImpl(authDataSource);

    final loginUseCase = LoginUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final checkAuthUseCase = CheckAuthUseCase(authRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            loginUseCase: loginUseCase,
            logoutUseCase: logoutUseCase,
            checkAuthUseCase: checkAuthUseCase,
          ),
        ),
        BlocProvider(create: (context) => MainCubit()),
      ],
      child: MaterialApp.router(
        title: 'Рабочее портфолио',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}