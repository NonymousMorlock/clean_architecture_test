import 'package:clean_architecture_test/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an int when the string represents an unsigned int',
      () async {
        const str = '123';

        final result = inputConverter.stringToUnsignedInt(str);

        expect(result, equals(const Right(123)));
      },
    );

    test(
      'should return a Failure when the string is not an int',
      () async {
        const str = 'abc';
        final result = inputConverter.stringToUnsignedInt(str);
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );

    test(
      'should return a Failure when the string is a negative int',
      () async {
        const str = '-123';
        final result = inputConverter.stringToUnsignedInt(str);
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
  });
}
