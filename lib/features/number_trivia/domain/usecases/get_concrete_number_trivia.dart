import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/usecases/use_case.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/repos/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params?> {
  GetConcreteNumberTrivia(this.repo);
  final NumberTriviaRepo repo;

  @override
  Future<Either<Failure?, NumberTrivia?>?>? call(Params? params) async =>
      await repo.getConcreteNumberTrivia(params?.number);
}

class Params extends Equatable {
  const Params({this.number});
  final int? number;

  @override
  List<dynamic> get props => [number];
}
