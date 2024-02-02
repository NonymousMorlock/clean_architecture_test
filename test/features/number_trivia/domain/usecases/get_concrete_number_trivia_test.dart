import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepo>()])
import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late final MockNumberTriviaRepo repo;
  late final GetConcreteNumberTrivia useCase;

  setUp(() {
    repo = MockNumberTriviaRepo();
    useCase = GetConcreteNumberTrivia(repo);
  });

  const testNumber = 1;
  const testTriv = NumberTrivia(number: 1, text: 'test');
  test('get trivia for the number from the repo', () async {
    when(repo.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => const Right(testTriv));
    final result = await useCase(const Params(number: testNumber));
    expect(result, const Right(testTriv));
    verify(repo.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(repo);
  });
}
