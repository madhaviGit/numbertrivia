import 'package:equatable/equatable.dart';

abstract class FailureMessage extends Equatable {
  final String message;

  const FailureMessage([this.message = 'An unexpected error']);
}

abstract class Failure extends Equatable {

@override
  List<Object> get props=>[];

}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}