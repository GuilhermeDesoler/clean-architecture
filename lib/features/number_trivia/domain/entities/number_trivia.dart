import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  const NumberTrivia({
    required this.text,
    required this.number,
  }) : super();

  final String text;
  final int number;

  @override
  List<Object?> get props => [text, number];
}
