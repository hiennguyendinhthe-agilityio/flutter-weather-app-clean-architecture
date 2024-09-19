import 'package:bazar_books_app/features/home/bloc/vendor_bloc.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BestVendors extends StatelessWidget {
  const BestVendors({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BlocBuilder<VendorBloc, GetVendorsState>(
        builder: (context, state) {
          if (state.status == GetVendorsStatus.error) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          return Skeletonizer(
            enabled: state.status == GetVendorsStatus.loading,
            child: (state.status == GetVendorsStatus.loaded
                    ? (state.vendors?.isEmpty ?? true)
                    : state.status != GetVendorsStatus.loading)
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<VendorBloc>().add(GetVendorsEvent());
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (state.status == GetVendorsStatus.loaded
                        ? state.vendors?.length ?? 0
                        : 3),
                    itemBuilder: (_, index) {
                      final Vendor vendor =
                          state.status == GetVendorsStatus.loading
                              ? Vendor(id: index.toString())
                              : state.vendors![index];

                      return VendorCard(
                        imageUrl: vendor.imageUrl,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
