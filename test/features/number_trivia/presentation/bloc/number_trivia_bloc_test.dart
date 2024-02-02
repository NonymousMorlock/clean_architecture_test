import 'package:clean_architecture_test/core/error/failures.dart';
import 'package:clean_architecture_test/core/usecases/use_case.dart';
import 'package:clean_architecture_test/core/utils/input_converter.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_test/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
void main() {
  late NumberTriviaBloc bLoC;
  late MockGetConcreteNumberTrivia concreteNumberTrivia;
  late MockGetRandomNumberTrivia randomNumberTrivia;
  late MockInputConverter inputConverter;

  setUp(() {
    concreteNumberTrivia = MockGetConcreteNumberTrivia();
    randomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bLoC = NumberTriviaBloc(
      concrete: concreteNumberTrivia,
      random: randomNumberTrivia,
      converter: inputConverter,
    );
  });

  test('initialState should be empty', () {
    expect(bLoC.state, const Empty());
    // expectLater(
    //   bLoC.stream.asBroadcastStream(),
    //   emitsInOrder(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
    // );
  });

  void setUpInputConversionSuccess(int tNumber) {
    when(inputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumber));
  }

  void setUpInputConversionFailure() {
    when(inputConverter.stringToUnsignedInt(any))
        .thenReturn(Left(InvalidInputFailure()));
  }

  group('GetTriviaForConcreteNumberEvent', () {
    const tNumberString = '1';
    const tNumber = 1;
    const tNumberTrivia = NumberTrivia(number: tNumber, text: 'Test Trivia');

    test(
      'should call the input converter to validate and convert the string to '
      'an unsigned int',
      () async {
        setUpInputConversionSuccess(tNumber);
        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(inputConverter.stringToUnsignedInt(any));
        verify(inputConverter.stringToUnsignedInt(tNumberString));
        verifyNoMoreInteractions(inputConverter);
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        setUpInputConversionFailure();
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Error(inputFailure)]),
        );

        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        setUpInputConversionSuccess(tNumber);
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(concreteNumberTrivia(any));

        verify(concreteNumberTrivia(const Params(number: tNumber)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        setUpInputConversionSuccess(tNumber);
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Loaded(tNumberTrivia)]),
        );
        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        setUpInputConversionSuccess(tNumber);
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Error(serverFailure)]),
        );
        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with the proper message when getting '
      'data fails',
      () async {
        setUpInputConversionSuccess(tNumber);
        when(concreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Error(cacheFailure)]),
        );
        bLoC.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumberEvent', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'Test Trivia');

    test(
      'should get data from the random use case',
      () async {
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        bLoC.add(const GetTriviaForRandomNumber());
        await untilCalled(randomNumberTrivia(any));
        verify(randomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully ',
      () async {
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Loaded(tNumberTrivia)]),
        );
        bLoC.add(const GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Error(serverFailure)]),
        );
        bLoC.add(const GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with the proper message when getting '
      'data fails',
      () async {
        when(randomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        await expectLater(
          bLoC.stream.asBroadcastStream(),
          emitsInOrder([const Loading(), const Error(cacheFailure)]),
        );
        bLoC.add(const GetTriviaForRandomNumber());
      },
    );
  });
}
