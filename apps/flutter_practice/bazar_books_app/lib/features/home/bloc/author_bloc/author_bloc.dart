// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/author_repository/author_repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'author_event.dart';

class AuthorBloc extends Bloc<AuthorEvent, FetchDataState<Author>> {
  final AuthorRepository repository;

  AuthorBloc({required this.repository})
      : super(const FetchDataState<Author>.initial()) {
    on<GetAuthorsEvent>(_onFetchAuthors);
    on<FetchAuthorProfileEvent>(_onFetchAuthorProfile);
  }

  Future<void> _onFetchAuthors(
      AuthorEvent event, Emitter<FetchDataState<Author>> emit) async {
    emit(const FetchDataState<Author>.loading());

    try {
      final authors = await repository.fetchAuthors();

      if (authors.isEmpty) {
        emit(const FetchDataState<Author>.initial());
      } else {
        emit(FetchDataState<Author>.loaded(authors));
      }
    } catch (e) {
      emit(
          FetchDataState<Author>.error(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onFetchAuthorProfile(FetchAuthorProfileEvent event,
      Emitter<FetchDataState<Author>> emit) async {
    emit(const FetchDataState<Author>.loading());

    try {
      final authors = await repository.fetchAuthorProfile(event.id);

      emit(FetchDataState<Author>.loaded([authors]));
    } catch (e) {
      emit(
          FetchDataState<Author>.error(ErrorHandler.handle(e).failure.message));
    }
  }
}
