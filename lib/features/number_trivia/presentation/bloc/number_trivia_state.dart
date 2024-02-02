part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {
  const Empty();
}

class Loading extends NumberTriviaState {
  const Loading();
}

class Loaded extends NumberTriviaState {
  const Loaded(this.trivia);
  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  const Error(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
