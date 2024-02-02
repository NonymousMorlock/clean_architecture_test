import 'dart:convert';

import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const testTriviaModel = NumberTriviaModel(number: 418, text: 'Test Text');
  // final json = await rootBundle.loadString("test/fixtures/trivia.json");

  test('should be a subclass of NumberTrivia entity', () {
    expect(testTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON number is an int', () {
      final jsonMap =
          jsonDecode(fixture('trivia.json')) as Map<String, dynamic>;

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(testTriviaModel));
    });

    test('should return a valid model when JSON number is a double', () {
      final jsonMap =
          jsonDecode(fixture('trivia_double.json')) as Map<String, dynamic>;

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map with the right data', () {
      final result = testTriviaModel.toJson();

      expect(result, equals({'text': 'Test Text', 'number': 418}));
      expect(result['number'], isA<int>());
    });
  });
}
