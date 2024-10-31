// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibilityEvent extends AuthEvent {}
