import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/error/exceptions.dart';

import 'package:flutter_project/core/platform/network_info.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_project/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../models/number_trivia_model.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRepositoryImpl({
    required this.numberTriviaRemoteDataSource,
    required this.numberTriviaLocalDataSource,
    required this.networkInfo,
  });

  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    final deviceIsOnline = await networkInfo.isConnected;

    if (deviceIsOnline) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
