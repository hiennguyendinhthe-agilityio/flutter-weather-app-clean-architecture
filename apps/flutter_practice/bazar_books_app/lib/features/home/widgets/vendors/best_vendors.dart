import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BestVendors extends StatelessWidget {
  const BestVendors({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BlocBuilder<VendorBloc, FetchDataState<Vendor>>(
        builder: (context, state) {
          if (state.status == FetchDataStatus.error) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          return Skeletonizer(
            enabled: state.status == FetchDataStatus.loading,
            child: ((state.status == FetchDataStatus.loaded) &&
                    (state.data?.isEmpty ?? false))
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<VendorBloc>().add(GetBestVendorsEvent());
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (state.status == FetchDataStatus.loaded
                        ? state.data?.length ?? 0
                        : 3),
                    itemBuilder: (_, index) {
                      final Vendor vendor = state.status ==
                                  FetchDataStatus.loading ||
                              state.data == null
                          ? Vendor(id: index.toString())
                          : state.data?[index] ?? Vendor(id: index.toString());

                      return BazUiVendorCard(
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
