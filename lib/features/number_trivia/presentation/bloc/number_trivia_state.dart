part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  const Loaded({required this.trivia});

  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

class ErrorState extends NumberTriviaState {
  const ErrorState({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
