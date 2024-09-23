// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vendor_event.dart';

class VendorBloc extends Bloc<VendorEvent, FetchDataState<Vendor>> {
  VendorBloc({required this.vendorRepository})
      : super(const FetchDataState<Vendor>.initial()) {
    on<GetVendorsEvent>(_onGetVendors);
  }

  final Repository vendorRepository;
  Future<void> _onGetVendors(
      GetVendorsEvent event, Emitter<FetchDataState<Vendor>> emit) async {
    emit(const FetchDataState<Vendor>.loading());

    try {
      final vendors = await vendorRepository.fetchVendors();

      emit(FetchDataState<Vendor>.loaded(vendors));
    } catch (e) {
      emit(
          FetchDataState<Vendor>.error(ErrorHandler.handle(e).failure.message));
    }
  }
}
