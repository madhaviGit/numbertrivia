
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/Params.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidInputMessage = "Invalid input Failure";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  final InputConverter inputConveter;

  NumberTriviaBloc({required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConveter})
      : super(Empty()) {
    String mapFailureToMessage(Failure failure) {
      switch (failure.runtimeType) {
        case ServerFailure _:
          return serverFailureMessage;
        case CacheFailure _:
          return cacheFailureMessage;
        default:
          return 'Unexpected error';
      }
    }

    Stream<NumberTriviaState> eitherLoadedOrErrorState(
        Either<Failure, NumberTrivia> failureOrTrivia,
        ) async* {
      yield failureOrTrivia.fold(
            (failure) => ErrorState(errorMessage: mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia),
      );
    }
    on<NumberTriviaEvent>((event, emit) {
      emit(Loading());
    });
    on<ConcreteNumberTriviaEvent>((event, emit) {
      final inputEither = inputConveter.stringToUnsignedInteger(
          event.numberString);
      inputEither.fold((failure) async* {
        emit(ErrorState(errorMessage: invalidInputMessage)) ;
      }, (integer) async*{
        emit( Loading());
        final failureOrTrivia =
        await getConcreteNumberTrivia(Params(number: integer));
        yield* eitherLoadedOrErrorState(failureOrTrivia);
      });
    });


  }
}
