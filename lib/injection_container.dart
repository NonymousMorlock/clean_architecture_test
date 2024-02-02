import 'package:clean_architecture_test/core/network/network_info.dart';
import 'package:clean_architecture_test/core/utils/input_converter.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/repos/number_trivia_repo_impl.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initFeatures();
}

Future<void> _initFeatures() async {
  /// BLoC
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      converter: sl(),
    ),
  );

  /// Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  /// Core
  sl.registerLazySingleton(InputConverter.new);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Repo
  sl.registerLazySingleton<NumberTriviaRepo>(
    () => NumberTriviaRepoImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(sl()),
  );

  /// External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(http.Client.new);
  sl.registerLazySingleton(DataConnectionChecker.new);
}
