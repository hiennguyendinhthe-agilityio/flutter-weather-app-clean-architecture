import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserInfoEvent extends ProfileEvent {}

class ChangeAvatarEvent extends ProfileEvent {
  final ImageSource source;

  ChangeAvatarEvent({required this.source});

  @override
  List<Object?> get props => [source];
}
