import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/network/network_info.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_test/features/number_trivia/data/repos/number_trivia_repo_impl.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
import 'number_trivia_repo_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepoImpl repo;
  late MockNumberTriviaRemoteDataSource remoteDataSource;
  late MockNumberTriviaLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    localDataSource = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();

    repo = NumberTriviaRepoImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  // void onlineTests(Function body) {
  //   group("device is online", () {
  //     setUp(() {
  //       when(networkInfo.isConnected).thenAnswer((_) async => true);
  //     });

  //     body();
  //   });
  // }

  // void offlineTests(Function body) {
  //   group("device is offline", () {
  //     setUp(() {
  //       when(networkInfo.isConnected).thenAnswer((_) async => false);
  //     });

  //     body();
  //   });
  // }

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;
    const testTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: testNumber);
    const NumberTrivia testTrivia = testTriviaModel;

    test('check internet connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repo.getConcreteNumberTrivia(testNumber);
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testTriviaModel);
        final result = await repo.getConcreteNumberTrivia(testNumber);

        expect(result, equals(const Right(testTrivia)));

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));

        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testTriviaModel);

        await repo.getConcreteNumberTrivia(testNumber);
        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(localDataSource.cacheNumberTrivia(testTriviaModel));
        verifyNoMoreInteractions(localDataSource);
        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        final result = await repo.getConcreteNumberTrivia(testNumber);
        expect(result, equals(Left(ServerFailure())));
        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(localDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testTriviaModel);

          final result = await repo.getConcreteNumberTrivia(testNumber);

          verify(repo.getConcreteNumberTrivia(testNumber));
          verifyZeroInteractions(remoteDataSource);
          verify(localDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(testTrivia)));
        },
      );

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repo.getConcreteNumberTrivia(testNumber);
        expect(result, equals(Left(CacheFailure())));
        verify(repo.getConcreteNumberTrivia(testNumber));
        verify(localDataSource.getLastNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
      });
    });
  });

  /// GET RANDOM NUMBER

  group('getRandomNumberTrivia', () {
    const testTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);
    const NumberTrivia testTrivia = testTriviaModel;
    test('check internet connectivity', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      await repo.getRandomNumberTrivia();
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        final result = await repo.getRandomNumberTrivia();

        expect(result, equals(const Right(testTrivia)));
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);
        await repo.getRandomNumberTrivia();
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(testTriviaModel));
        verifyNoMoreInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
      });
      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await repo.getRandomNumberTrivia();

        expect(result, equals(Left(ServerFailure())));
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(remoteDataSource);
        verifyZeroInteractions(localDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testTriviaModel);

        final result = await repo.getRandomNumberTrivia();
        expect(result, equals(const Right(testTrivia)));
        verify(localDataSource.getLastNumberTrivia());
        verify(repo.getRandomNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repo.getRandomNumberTrivia();
        expect(result, equals(Left(CacheFailure())));
        verify(localDataSource.getLastNumberTrivia());
        verify(repo.getRandomNumberTrivia());
        verifyZeroInteractions(remoteDataSource);
        verifyNoMoreInteractions(localDataSource);
      });
    });
  });
}
