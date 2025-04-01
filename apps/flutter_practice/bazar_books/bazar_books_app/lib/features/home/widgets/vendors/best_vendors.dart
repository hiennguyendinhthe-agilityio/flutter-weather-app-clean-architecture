import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_state.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BestVendors extends StatelessWidget {
  const BestVendors({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0.h,
      child: BlocBuilder<VendorBloc, VendorState>(
        builder: (context, state) {
          if (state.status == VendorStatus.failure) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          return Skeletonizer(
            enabled: state.status == VendorStatus.loading,
            child: ((state.status == VendorStatus.success) &&
                    (state.vendors?.isEmpty ?? false))
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<VendorBloc>().add(GetBestVendors());
                    },
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (state.status == VendorStatus.success
                        ? state.vendors?.length ?? 0
                        : 3),
                    itemBuilder: (_, index) {
                      final Vendor vendor =
                          state.status == VendorStatus.loading ||
                                  state.vendors == null
                              ? Vendor(id: index.toString())
                              : state.vendors?[index] ??
                                  Vendor(id: index.toString());

                      return ListItemWidget(
                        imageUrl: vendor.imageUrl,
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
          );
        },
      ),
    );
  }
}
