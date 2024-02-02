import 'dart:convert';

import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('you messed up badly', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')) as Map<String, dynamic>,
    );
    test(
        'should perform a GET request on URL with number being the endpoint and with application/json header',
        () {
      setUpMockHttpClientSuccess200();
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      verify(
        mockClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        setUpMockHttpClientSuccess200();
        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
        expect(result, tNumberTriviaModel);
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
        verifyNoMoreInteractions(mockClient);
      },
    );

    test(
      'should throw ServerException when the response code is not 200',
      () async {
        setUpMockHttpClientFailure404();
        final call = dataSourceImpl.getConcreteNumberTrivia;
        expect(
          () => call(tNumber),
          throwsA(const TypeMatcher<ServerException>()),
        );
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
        verifyNoMoreInteractions(mockClient);
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')) as Map<String, dynamic>,
    );

    test('should perform a GET request on URL with application/json header',
        () {
      setUpMockHttpClientSuccess200();
      dataSourceImpl.getRandomNumberTrivia();
      verify(
        mockClient.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        setUpMockHttpClientSuccess200();
        final result = await dataSourceImpl.getRandomNumberTrivia();
        expect(result, equals(tNumberTriviaModel));
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
        verifyNoMoreInteractions(mockClient);
      },
    );

    test(
      'should throw ServerException when the response code is not 200',
      () async {
        setUpMockHttpClientFailure404();
        final call = dataSourceImpl.getRandomNumberTrivia;
        expect(call, throwsA(const TypeMatcher<ServerException>()));
        verify(
          mockClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
        verifyNoMoreInteractions(mockClient);
      },
    );
  });
}
