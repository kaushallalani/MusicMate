import 'package:get_it/get_it.dart';
import 'package:musicmate/pages/authentication/bloc/authentication_bloc.dart';
import 'package:musicmate/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:musicmate/repositories/firebase_repository.dart';
import 'package:musicmate/repositories/firebase_repository_impl.dart';
import 'package:musicmate/repositories/user_repository.dart';

final GetIt serviceLocater = GetIt.instance;

Future<void> init() async {
  serviceLocater
    ..registerFactory(() => AuthenticationBloc(serviceLocater.call(), serviceLocater.call()))
    ..registerFactory(() => DashboardBloc(serviceLocater.call(),serviceLocater.call()))
    ..registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl())
    ..registerLazySingleton<UserRepository>(() => UserRepository());

  ///Authentication bloc
}
