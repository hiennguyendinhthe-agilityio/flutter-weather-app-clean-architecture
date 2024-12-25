import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyAccountInitialState extends ProfileState {}

class MyAccountLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ApiUser user;

  ProfileLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthenticationLoading extends ProfileState {}

class Unauthenticated extends ProfileState {}
