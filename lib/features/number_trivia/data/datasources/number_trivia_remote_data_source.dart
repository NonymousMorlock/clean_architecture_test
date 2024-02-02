import 'dart:convert';

import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  NumberTriviaRemoteDataSourceImpl(this.client);
  http.Client client;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) throw ServerException();
    return NumberTriviaModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
