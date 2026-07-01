import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Session expired.'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to load local data.'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unknown error.'});
}
