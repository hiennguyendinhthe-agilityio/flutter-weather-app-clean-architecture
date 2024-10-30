import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class PostsFetched extends PostEvent {
  @override
  List<Object?> get props => [];
}

class PostsNextPage extends PostEvent {
  @override
  List<Object?> get props => [];
}
