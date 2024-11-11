part of 'vendor_bloc.dart';

@immutable
sealed class VendorEvent {}

class GetBestVendorsEvent extends VendorEvent {}

class FetchMoreVendorsEvent extends VendorEvent {
  final String category;
  FetchMoreVendorsEvent(this.category);
}
