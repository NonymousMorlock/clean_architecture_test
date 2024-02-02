import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/network/network_info.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepoImpl implements NumberTriviaRepo {
  NumberTriviaRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int? number,
  ) async =>
      _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async =>
      _getTrivia(remoteDataSource.getRandomNumberTrivia);

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    Future<NumberTriviaModel> Function() getTriv,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getTriv();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
