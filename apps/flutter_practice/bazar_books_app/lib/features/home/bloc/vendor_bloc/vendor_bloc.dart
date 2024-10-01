// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vendor_event.dart';

class VendorBloc extends Bloc<VendorEvent, FetchDataState<Vendor>> {
  VendorBloc({required this.vendorRepository})
      : super(const FetchDataState<Vendor>.initial()) {
    on<GetBestVendorsEvent>(_onGetVendors);
    on<FetchAllVendorsEvent>(_onFetchAllVendors);
    on<FetchMoreVendorsEvent>(_onFetchMoreVendors);
  }

  final Repository vendorRepository;
  int currentPage = 1;
  final int limit = 10;
  bool hasReachedEnd = false;

  Future<void> _onGetVendors(
      GetBestVendorsEvent event, Emitter<FetchDataState<Vendor>> emit) async {
    emit(const FetchDataState<Vendor>.loading());

    try {
      final vendors = await vendorRepository.fetchVendors();

      emit(FetchDataState<Vendor>.loaded(vendors));
    } catch (e) {
      emit(
          FetchDataState<Vendor>.error(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onFetchAllVendors(
      FetchAllVendorsEvent event, Emitter<FetchDataState<Vendor>> emit) async {
    emit(const FetchDataState<Vendor>.loading());

    try {
      final vendors = await vendorRepository.fetchVendors();

      // Add vendors to the state
      emit(FetchDataState<Vendor>.loaded(vendors));
    } catch (e) {
      emit(
          FetchDataState<Vendor>.error(ErrorHandler.handle(e).failure.message));
    }
  }

  Future<void> _onFetchMoreVendors(
      FetchMoreVendorsEvent event, Emitter<FetchDataState<Vendor>> emit) async {
    if (state.status == FetchDataStatus.loading ||
        state.status == FetchDataStatus.loadMore) {
      return;
    }

    emit(FetchDataState<Vendor>.loadingMore(state.data ?? []));

    try {
      // Call API to get new page data, using currentPage variable
      final List<Vendor> newVendors = await vendorRepository.fetchVendors(
        page: currentPage,
        limit: limit,
      );

      // Check if there is no new data, stop requesting more
      // Check if the API returns an empty list, meaning all data has been loaded
      if (newVendors.isEmpty) {
        hasReachedEnd = true;
      } else {
        currentPage++; // Increment current page for next load
      }

      currentPage++;

      // Update Vendor list by concatenating new data with existing data
      final updatedVendors = List<Vendor>.from(state.data ?? [])
        ..addAll(newVendors);

      // Emit loaded state with updated list
      emit(FetchDataState<Vendor>.loaded(updatedVendors));
    } catch (e) {
      // If there is an error, output an error status
      emit(
          FetchDataState<Vendor>.error(ErrorHandler.handle(e).failure.message));
    }
  }
}
