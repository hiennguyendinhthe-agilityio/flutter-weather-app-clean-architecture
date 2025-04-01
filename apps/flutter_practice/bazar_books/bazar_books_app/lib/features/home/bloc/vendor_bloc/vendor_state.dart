import 'package:bazar_books_design/core/models/vendor_model/vendor_model.dart';
import 'package:equatable/equatable.dart';

enum VendorStatus { loading, initial, success, failure }

class VendorState extends Equatable {
  final VendorStatus status;
  final List<Vendor>? vendors;
  final bool hasReachedMax;
  final String errorMessage;

  const VendorState({
    this.status = VendorStatus.initial,
    this.vendors,
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [vendors, status, hasReachedMax, errorMessage];

  VendorState copyWith({
    VendorStatus? status,
    List<Vendor>? vendors,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return VendorState(
      status: status ?? this.status,
      vendors: vendors ?? this.vendors,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
