import 'package:bloc/bloc.dart';
import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/usecases/use_case.dart';
import 'package:clean_architecture_test/core/utils/input_converter.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

typedef ConcreteEvent = GetTriviaForConcreteNumber;
typedef RandomEvent = GetTriviaForRandomNumber;
typedef StateEmitter = Emitter<NumberTriviaState>;

const String serverFailure = 'Server Failure';
const String cacheFailure = 'Cache Failure';
const String inputFailure =
    'Invalid input - Must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required InputConverter converter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter,
        super(const Empty()) {
    _eventHandler();
  }
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  void _eventHandler() {
    on<NumberTriviaEvent>((event, emit) {
      emit(const Loading());
    });

    on<ConcreteEvent>(_concreteEventHandler);

    on<RandomEvent>(_randomEventHandler);
  }

  Future<void> _randomEventHandler(RandomEvent event, StateEmitter emit) async {
    final result = await getRandomNumberTrivia(NoParams());
    result?.fold(
      (failure) => emit(Error(failure!.message)),
      (trivia) => emit(Loaded(trivia!)),
    );
  }

  Future<void> _concreteEventHandler(
    ConcreteEvent event,
    StateEmitter emit,
  ) async {
    final inputEither = inputConverter.stringToUnsignedInt(event.number);
    await inputEither.fold(
      (failure) async => emit(const Error(inputFailure)),
      (number) async {
        final result = await getConcreteNumberTrivia(Params(number: number));
        await result?.fold(
          (failure) async => emit(Error(failure!.message)),
          (trivia) async => emit(Loaded(trivia!)),
        );
      },
    );
  }
}

extension FailureMessage on Failure {
  String get message {
    switch (runtimeType) {
      case ServerFailure:
        return serverFailure;
      case CacheFailure:
        return cacheFailure;
      default:
        return 'Unexpected Error';
    }
  }
}
