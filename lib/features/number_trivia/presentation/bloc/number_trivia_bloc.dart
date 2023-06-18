// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_project/core/util/imput_converter.dart';
import 'package:flutter_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_project/features/number_trivia/domain/usecases/get_croncrete_number_trivia.dart';

import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc({
    required this.getTriviaForConcreteNumber,
    required this.getTriviaForRandomNumber,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        inputConverter.stringTounsignedInteger(event.numberString);
      }
    });
  }

  final GetTriviaForConcreteNumber getTriviaForConcreteNumber;
  final GetTriviaForRandomNumber getTriviaForRandomNumber;
  final InputConverter inputConverter;
}
