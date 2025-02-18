
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

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String Invalid_INPUT_Message = "Invalid input Failure";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  final InputConverter inputConveter;

  NumberTriviaBloc({required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConveter})
      : super(Empty()) {
    String _mapFailureToMessage(Failure failure) {
      switch (failure.runtimeType) {
        case ServerFailure:
          return SERVER_FAILURE_MESSAGE;
        case CacheFailure:
          return CACHE_FAILURE_MESSAGE;
        default:
          return 'Unexpected error';
      }
    }

    Stream<NumberTriviaState> _eitherLoadedOrErrorState(
        Either<Failure, NumberTrivia> failureOrTrivia,
        ) async* {
      yield failureOrTrivia.fold(
            (failure) => ErrorState(errorMessage: _mapFailureToMessage(failure)),
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
        emit(ErrorState(errorMessage: Invalid_INPUT_Message)) ;
      }, (integer) async*{
        emit( Loading());
        final failureOrTrivia =
        await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    });


  }
}
