import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VendorsGrid extends StatefulWidget {
  const VendorsGrid({super.key});

  @override
  State<VendorsGrid> createState() => _VendorsGridState();
}

class _VendorsGridState extends State<VendorsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override

  /// Adds a listener to the scroll controller to listen to the scroll
  /// position of the grid view. When the user scrolls to the bottom of the
  /// list, and the state is not loading or loading more, it triggers the
  /// [FetchMoreVendorsEvent] to fetch more vendors.
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  /// Listen to the scroll position of the grid view. When the user scrolls
  /// to the bottom of the list, and the state is not loading or loading more,
  /// it triggers the [FetchMoreVendorsEvent] to fetch more vendors.
  void _onScroll() {
    final state = context.read<VendorBloc>().state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        state.status != FetchDataStatus.loadMore &&
        state.status != FetchDataStatus.loading) {
      context.read<VendorBloc>().add(FetchMoreVendorsEvent());
    }
  }

  @override

  /// Removes the scroll listener and disposes of the scroll controller to
  /// prevent memory leaks when the widget is disposed.
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double aspectRatio = screenWidth < 400 ? 0.8 : 0.75;

    return BlocBuilder<VendorBloc, FetchDataState<Vendor>>(
      builder: (context, state) {
        if (state.status == FetchDataStatus.error) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }

        return Skeletonizer(
          enabled: state.status == FetchDataStatus.loading,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 23),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: aspectRatio,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (state.data?.length ?? 0) +
                (state.status == FetchDataStatus.loadMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.data!.length) {
                return const Center(child: BazUiCircularProgressIndicator());
              }

              final Vendor vendor = state.data![index];

              return BazUiVendorCard(
                headlines: vendor.headlines ?? Constants.titleDefault,
                imageUrl: vendor.imageUrl,
                subheads: StarRating(
                  rating: vendor.numberStar ?? 0,
                  numberStar: const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
