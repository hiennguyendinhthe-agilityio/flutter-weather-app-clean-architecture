import 'package:bazar_books_design/core/models/auth_model/user.dart';
import 'package:equatable/equatable.dart';

abstract class MyAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyAccountInitialState extends MyAccountState {}

class MyAccountLoadingState extends MyAccountState {}

class ProfileLoadedState extends MyAccountState {
  final User user;

  ProfileLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends MyAccountState {
  final String message;

  ProfileErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
