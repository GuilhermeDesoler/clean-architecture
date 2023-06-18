import 'dart:convert';

import 'package:flutter_project/core/error/exceptions.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockClienteSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockClienteFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('GetConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''Should perform a GET request on a URL with a number
         being the endpoint adn with application/json header''', () async {
      // arrange
      setUpMockClienteSuccess200();
      // act
      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {
          'ContentType': 'application/json',
        },
      ));
    });

    test(
        'Should return NumberTriviaModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockClienteSuccess200();
      // act
      final result = await numberTriviaRemoteDataSourceImpl
          .getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other error code',
        () async {
      // arrange
      setUpMockClienteFailure404();
      // act
      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('GetRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''Should perform a GET request on a URL with random
         being the endpoint adn with application/json header''', () async {
      // arrange
      setUpMockClienteSuccess200();
      // act
      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // assert
      verify(mockClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {
          'ContentType': 'application/json',
        },
      ));
    });

    test(
        'Should return NumberTriviaModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockClienteSuccess200();
      // act
      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other error code',
        () async {
      // arrange
      setUpMockClienteFailure404();
      // act
      final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
