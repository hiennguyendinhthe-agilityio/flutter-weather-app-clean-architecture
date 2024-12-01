import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserInfoEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
