// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter_project/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringTounsignedInteger(String str) {
    try {
      final integer = int.parse(str);

      if (integer < 0) throw const FormatException();

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
