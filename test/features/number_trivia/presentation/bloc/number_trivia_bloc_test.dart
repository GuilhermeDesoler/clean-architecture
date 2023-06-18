import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/util/imput_converter.dart';
import 'package:flutter_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetTriviaForConcreteNumber,
  GetTriviaForRandomNumber,
  InputConverter,
])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetTriviaForConcreteNumber mockGetTriviaForConcreteNumber;
  late MockGetTriviaForRandomNumber mockGetTriviaForRandomNumber;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetTriviaForConcreteNumber = MockGetTriviaForConcreteNumber();
    mockGetTriviaForRandomNumber = MockGetTriviaForRandomNumber();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getTriviaForConcreteNumber: mockGetTriviaForConcreteNumber,
      getTriviaForRandomNumber: mockGetTriviaForRandomNumber,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(numberTriviaBloc.state, equals(Empty()));
  });

  group('GetTriviaForCroncreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test', number: tNumberParsed);

    test(
        'Should call the InputConverter to validade and convert the string to an unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringTounsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringTounsignedInteger(any));
      // assert
      verify(mockInputConverter.stringTounsignedInteger(tNumberString));
    });
  });
}
