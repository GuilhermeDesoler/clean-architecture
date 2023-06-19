import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_project/core/network/network_info.dart';
import 'package:flutter_project/core/util/imput_converter.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_project/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_project/features/number_trivia/domain/usecases/get_croncrete_number_trivia.dart';
import 'package:flutter_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(
      () => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton<GetRandomNumberTrivia>(
      () => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: sl(),
      numberTriviaLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
