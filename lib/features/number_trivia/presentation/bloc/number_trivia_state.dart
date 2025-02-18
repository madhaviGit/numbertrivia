part of 'number_trivia_bloc.dart';

@immutable
sealed class NumberTriviaState {}

final class Empty extends NumberTriviaState {}
final class Loading extends NumberTriviaState {}
final class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({required this.trivia});
}

final class ErrorState extends NumberTriviaState {
  final String errorMessage;
  ErrorState({required this.errorMessage});
}
