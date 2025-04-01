part of 'vendor_bloc.dart';

sealed class VendorEvent {}

class GetBestVendors extends VendorEvent {}

class VendorFetched extends VendorEvent {
  List<Object?> get props => [];
}

class VendorNextPage extends VendorEvent {
  List<Object?> get props => [];
}

class VendorRefresh extends VendorEvent {
  List<Object?> get props => [];
}
