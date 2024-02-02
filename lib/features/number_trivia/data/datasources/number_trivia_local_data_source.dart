import 'dart:convert';

import 'package:clean_architecture_test/core/error/exceptions.dart';
import 'package:clean_architecture_test/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const kCachedNumberTriviaKey = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  NumberTriviaLocalDataSourceImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final cachedModel = prefs.getString(kCachedNumberTriviaKey);
    if (cachedModel != null) {
      return Future.value(
        NumberTriviaModel.fromJson(
          jsonDecode(cachedModel) as Map<String, dynamic>,
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    await prefs.setString(kCachedNumberTriviaKey, jsonEncode(triviaToCache));
  }
}
