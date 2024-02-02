import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/usecases/use_case.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  GetRandomNumberTrivia(this.repo);
  NumberTriviaRepo repo;

  @override
  Future<Either<Failure?, NumberTrivia?>?>? call(NoParams? noParams) async =>
      await repo.getRandomNumberTrivia();
}
