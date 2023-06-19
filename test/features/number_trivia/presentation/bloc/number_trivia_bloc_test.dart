import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/error/failures.dart';
import 'package:flutter_project/core/usecases/usecase.dart';
import 'package:flutter_project/core/util/imput_converter.dart';
import 'package:flutter_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_project/features/number_trivia/domain/usecases/get_croncrete_number_trivia.dart';
import 'package:flutter_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  InputConverter,
])
@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
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

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringTounsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));

    test(
        'Should call the InputConverter to validade and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringTounsignedInteger(any));
      // assert
      verify(mockInputConverter.stringTounsignedInteger(tNumberString));
    });

    test('Should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringTounsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      const expected = ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE);
      expectLater(numberTriviaBloc.stream, emitsInOrder([expected]));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('Should get data from the concrete usecase', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('Should emit [Loading, ErroState] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'Should emit [Loading, ErroState] with a proper message for the error when getting the data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Loading(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test', number: 123);

    test('Should get data from the random usecase', () async {
      // arrange
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test('Should emit [Loading, ErroState] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const ErrorState(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test(
        'Should emit [Loading, ErroState] with a proper message for the error when getting the data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Loading(),
        const ErrorState(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.stream, emitsInOrder(expected));
      // act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });
}
