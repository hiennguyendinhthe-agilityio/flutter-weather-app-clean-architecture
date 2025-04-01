// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bazar_books_app/features/profile/data/favorite_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bloc/bloc.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _repo;

  FavoriteBloc(this._repo) : super(const FavoriteState()) {
    on<GetFavoriteProducts>(_onGetFavoriteProducts);
  }

  Future<void> _onGetFavoriteProducts(
    GetFavoriteProducts event,
    Emitter<FavoriteState> emit,
  ) async {
    final query = _repo.getFavorites(event.userId);

    return emit.forEach<QueryState<List<Product>>>(
      query.stream,
      onData: (queryState) {
        if (queryState.status == QueryStatus.error) {
          return state.copyWith(
            status: FavoriteStatus.failure,
            errorMessage: ErrorHandler.handle(queryState.error).failure.message,
          );
        }
        return state.copyWith(
          favorites: queryState.data ?? [],
          status: queryState.status == QueryStatus.loading
              ? FavoriteStatus.loading
              : FavoriteStatus.success,
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: FavoriteStatus.failure,
        errorMessage: ErrorHandler.handle(error).failure.message,
      ),
    );
  }
}
