import 'dart:io';

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
  final File? avatar;
  final String? message;

  ProfileLoadedState(
    this.user, {
    this.message,
    this.avatar,
  });

  @override
  List<Object?> get props => [user, avatar, message];
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthenticationLoading extends ProfileState {}

class Unauthenticated extends ProfileState {}

class AvatarErrorState extends ProfileState {
  final String message;

  AvatarErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AvatarLoadingState extends ProfileState {}
