// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, GetVendorsState> {
  VendorBloc(this.vendorApi) : super(const GetVendorsState.initial()) {
    on<GetVendorsEvent>(_onGetVendors);
  }

  final ApiService vendorApi;

  Future<void> _onGetVendors(
      GetVendorsEvent event, Emitter<GetVendorsState> emit) async {
    emit(const GetVendorsState.loading());

    try {
      final vendors = await vendorApi.fetchVendors();

      emit(GetVendorsState.loaded(vendors));
    } catch (e) {
      emit(GetVendorsState.error(ErrorHandler.handle(e).failure.message));
    }
  }
}
