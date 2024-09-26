part of 'vendor_bloc.dart';

@immutable
sealed class VendorEvent {}

class GetVendorsEvent extends VendorEvent {}
