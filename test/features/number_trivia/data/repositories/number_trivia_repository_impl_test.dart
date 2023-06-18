import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/error/exceptions.dart';
import 'package:flutter_project/core/error/failures.dart';
import 'package:flutter_project/core/network/network_info.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_project/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  // NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockNumberTriviaRemoteDataSource,
      numberTriviaLocalDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('GetConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is online', () {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'Should return remote data when the call to remote data is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
        );
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'Should cache the data locally when the call to remote data is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
        );
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'Should return server failure when the call to remote data is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber),
        );
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present ',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('Should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
  group('GetRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      numberTriviaRepositoryImpl.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'Should return remote data when the call to remote data is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        );
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'Should cache the data locally when the call to remote data is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        );
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'Should return server failure when the call to remote data is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(
          mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(),
        );
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present ',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('Should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
