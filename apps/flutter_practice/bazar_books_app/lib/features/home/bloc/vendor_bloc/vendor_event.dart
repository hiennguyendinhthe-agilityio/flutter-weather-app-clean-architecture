part of 'vendor_bloc.dart';

@immutable
sealed class VendorEvent {}

class GetBestVendorsEvent extends VendorEvent {}

class FetchAllVendorsEvent extends VendorEvent {}

// Add a new event for loading more vendors
class FetchMoreVendorsEvent extends VendorEvent {}
