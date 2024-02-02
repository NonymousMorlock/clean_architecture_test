import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required String text, required super.number})
      : super(text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) =>
      NumberTriviaModel(
        text: jsonMap['text'] as String,
        number: (jsonMap['number'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'number': number,
      };
}
