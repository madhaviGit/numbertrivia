part of 'number_trivia_bloc.dart';

@immutable
sealed class NumberTriviaEvent {}

class RandomNumberTriviaEvent extends NumberTriviaEvent {}

class ConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  ConcreteNumberTriviaEvent(this.numberString);
}
