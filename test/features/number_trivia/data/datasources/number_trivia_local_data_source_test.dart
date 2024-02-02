import 'dart:convert';

import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'number_trivia_local_data_source_test.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(mockPrefs);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')) as Map<String, dynamic>,
    );
    test(
        'should return NumberTriviaModel from Shared Preferences when one exists in cache',
        () async {
      when(mockPrefs.getString(any)).thenReturn(fixture('trivia.json'));
      final result = await dataSourceImpl.getLastNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
      verify(mockPrefs.getString(kCachedNumberTriviaKey));
    });

    test(
        'should throw a CacheException when there is no NumberTriviaModel in cache',
        () async {
      when(mockPrefs.getString(any)).thenReturn(null);
      final call = dataSourceImpl.getLastNumberTrivia;
      expect(call, throwsA(const TypeMatcher<CacheException>()));
      verify(mockPrefs.getString(kCachedNumberTriviaKey));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'Test Trivia');
    test('should call SharedPreferences to cache the data', () {
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      verify(
        mockPrefs.setString(
          kCachedNumberTriviaKey,
          jsonEncode(tNumberTriviaModel),
        ),
      );
    });
  });
}
