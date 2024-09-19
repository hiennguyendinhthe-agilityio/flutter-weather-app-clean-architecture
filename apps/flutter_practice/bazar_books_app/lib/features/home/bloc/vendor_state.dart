part of 'vendor_bloc.dart';

enum GetVendorsStatus { initial, loading, loaded, error }

class GetVendorsState {
  final GetVendorsStatus status;
  final List<Vendor>? vendors;
  final String? errorMessage;

  const GetVendorsState._({
    this.status = GetVendorsStatus.initial,
    this.vendors,
    this.errorMessage,
  });

  const GetVendorsState.initial() : this._();

  const GetVendorsState.loading() : this._(status: GetVendorsStatus.loading);

  const GetVendorsState.loaded(List<Vendor> vendors)
      : this._(status: GetVendorsStatus.loaded, vendors: vendors);

  const GetVendorsState.error(String errorMessage)
      : this._(status: GetVendorsStatus.error, errorMessage: errorMessage);

  List<Object?> get props => [status, vendors, errorMessage];
}
