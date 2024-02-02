import 'package:clean_architecture_test/core/usecases/use_case.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepo>()])
import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late MockNumberTriviaRepo repo;
  late GetRandomNumberTrivia useCase;

  setUp(() {
    repo = MockNumberTriviaRepo();
    useCase = GetRandomNumberTrivia(repo);
  });

  const testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('get trivia for a random number from the repo', () async {
    when(repo.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(testNumberTrivia));

    final result = await useCase(NoParams());

    expect(result, const Right(testNumberTrivia));
    verify(repo.getRandomNumberTrivia());
    verifyNoMoreInteractions(repo);
  });
}
