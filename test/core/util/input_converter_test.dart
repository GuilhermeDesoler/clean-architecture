import 'package:flutter_project/core/util/imput_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('StringToUnsignedInt', () {
    test(
        'Should return an integer when the string represents an unsigned integer',
        () {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringTounsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });

    test('Should return Failure when the string is not an integer', () {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringTounsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('Should return Failure when the string is a negative integer', () {
      // arrange
      const str = '-123';
      // act
      final result = inputConverter.stringTounsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
