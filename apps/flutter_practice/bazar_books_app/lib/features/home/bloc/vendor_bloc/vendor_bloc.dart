// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_state.dart';
import 'package:bazar_books_app/features/home/data/vendor_repository/vendor_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';

part 'vendor_event.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  VendorBloc() : super(const VendorState()) {
    on<VendorFetched>(_onVendorFetched, transformer: restartable());
    on<VendorNextPage>(_onVendorNextPage);
    on<VendorRefresh>(_onVendorRefreshRequested);
    on<GetBestVendors>(_onGetVendors);
  }

  final _repo = VendorRepositoryImpl();
  final vendorRepository = VendorRepositoryImpl();

  Future<void> _onGetVendors(
    GetBestVendors event,
    Emitter<VendorState> emit,
  ) async {
    final query = _repo.getVendorsCached();

    return emit.forEach<QueryState<List<Vendor>>>(
      query.stream,
      onData: (queryState) {
        return state.copyWith(
          vendors: queryState.data ?? [],
          status: queryState.status == QueryStatus.loading
              ? VendorStatus.loading
              : VendorStatus.success,
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: VendorStatus.failure,
        errorMessage: ErrorHandler.handle(error).failure.message,
      ),
    );
  }

  FutureOr<void> _onVendorFetched(
    VendorFetched event,
    Emitter<VendorState> emit,
  ) async {
    final query = _repo.getVendors();

    return emit.forEach<InfiniteQueryState<List<Vendor>>>(
      query.stream,
      onData: (queryState) {
        return state.copyWith(
          vendors: queryState.data?.expand((page) => page).toList() ?? [],
          status: queryState.status == QueryStatus.loading
              ? VendorStatus.loading
              : VendorStatus.success,
          hasReachedMax: queryState.hasReachedMax,
        );
      },
      onError: (error, stackTrace) => state.copyWith(
        status: VendorStatus.failure,
        errorMessage: ErrorHandler.handle(error).failure.message,
      ),
    );
  }

  Future<void> _onVendorRefreshRequested(
    VendorRefresh event,
    Emitter<VendorState> emit,
  ) async {
    emit(state.copyWith(status: VendorStatus.loading));
    try {
      await _repo.refreshVendors();
      emit(state.copyWith(status: VendorStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: VendorStatus.failure,
          errorMessage: ErrorHandler.handle(error).failure.message,
        ),
      );
    }
  }

  void _onVendorNextPage(VendorEvent _, Emitter<VendorState> __) {
    _repo.getVendors().getNextPage();
  }
}
