// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final Repository productRepository;
  DetailBloc({required this.productRepository})
      : super(const DetailState(
          fetchDataState: FetchDataState.initial(),
          isFavorite: false,
          quantity: 1,
        )) {
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateAmountEvent>(_onUpdateAmount);
  }

  void _onFetchProductDetails(
      FetchProductDetailsEvent event, Emitter<DetailState> emit) async {
    emit(state.copyWith(fetchDataState: const FetchDataState.loading()));
    try {
      final product = await productRepository.fetchProductDetails(event.id);
      emit(state.copyWith(
        fetchDataState: FetchDataState.loaded([product]),
      ));
    } catch (e) {
      emit(state.copyWith(
        fetchDataState: FetchDataState.error(e.toString()),
      ));
    }
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<DetailState> emit) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onUpdateAmount(UpdateAmountEvent event, Emitter<DetailState> emit) {
    final newAmount = event.newAmount < 1 ? 1 : event.newAmount;
    emit(state.copyWith(amount: newAmount));
  }
}
