import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/bloc/playback/playback_bloc.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/controllers/dio.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/repositories/auth_repository_impl.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';
import 'package:musicmate/repositories/dashboard_repository_impl.dart';
import 'package:musicmate/repositories/spotify_repository.dart';
import 'package:musicmate/repositories/spotify_repository_impl.dart';
import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/spotify_authentication.dart';

final GetIt serviceLocater = GetIt.instance;

Future<void> init() async {
  serviceLocater
    ..registerFactory(
        () => AuthenticationBloc(serviceLocater.call(), serviceLocater.call()))
    ..registerFactory(() => DashboardBloc(serviceLocater.call(),
        serviceLocater.call(), serviceLocater.call(), serviceLocater.call()))
    ..registerFactory(() => SessionBloc(serviceLocater.call(),
        serviceLocater.call(), serviceLocater.call(), serviceLocater.call()))
    ..registerFactory(
        () => PlaybackBloc(serviceLocater.call(), serviceLocater.call()))
    ..registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl())
    ..registerLazySingleton<UserRepository>(() => UserRepository())
    ..registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(
        firebaseFirestore: serviceLocater.call(),
        serviceLocater.call(),
        serviceLocater.call()))
    ..registerLazySingleton<SpotifyRepository>(() => SpotifyRepositoryImpl(
        spotifyAuthentication: serviceLocater.call(),
        userRepository: serviceLocater.call()));

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  const GoogleSignIn googleSignIn = GoogleSignIn();
  final DioController controller = DioController();
  final SpotifyAuthentication spotifyAuthentication = SpotifyAuthentication();

  serviceLocater
    ..registerLazySingleton(() => auth)
    ..registerLazySingleton(() => firestore)
    ..registerLazySingleton(() => googleSignIn)
    ..registerLazySingleton(() => controller)
    ..registerLazySingleton(() => spotifyAuthentication);
}
