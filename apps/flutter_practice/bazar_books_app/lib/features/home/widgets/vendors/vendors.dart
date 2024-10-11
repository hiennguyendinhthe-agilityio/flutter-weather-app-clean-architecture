import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Vendors extends StatelessWidget {
  const Vendors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: BazUiBuiltInImage.icSearch(),
            onPressed: () {},
          ),
        ],
        title: Text(
          context.bazS.vendorTitle,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: context.fontSize(SizeType.m),
          ),
        ),
        centerTitle: true,
      ),
      body: BazUiTabbarView(
        headline: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.bazS.vendorSubtitle,
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                context.bazS.vendorTitle,
                style: context.textTheme.titleLarge
                    ?.copyWith(color: context.colorScheme.primary),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        tabs: [
          Tab(text: context.bazS.allTabBar),
          Tab(text: context.bazS.booksTabBar),
          Tab(text: context.bazS.poemsTabBar),
          Tab(text: context.bazS.specialForYouTabBar),
          Tab(text: context.bazS.stationeryTabBar),
        ],
        child: [
          GetListVendor(category: context.bazS.allTabBar),
          GetListVendor(category: context.bazS.booksTabBar),
          GetListVendor(category: context.bazS.poemsTabBar),
          GetListVendor(category: context.bazS.specialForYouTabBar),
          GetListVendor(category: context.bazS.stationeryTabBar),
        ],
      ),
    );
  }
}

class GetListVendor extends StatefulWidget {
  final String category;
  const GetListVendor({super.key, required this.category});

  @override
  State<GetListVendor> createState() => _GetListVendorState();
}

class _GetListVendorState extends State<GetListVendor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  /// Listen to the scroll position of the grid view. When the user scrolls
  /// to the bottom of the list, and the state is not loading or loading more,
  /// it triggers the [FetchMoreVendorsEvent] to fetch more vendors.
  void _onScroll() {
    final state = context.read<VendorBloc>().state;

    // Check if user scrolled near the bottom and status is not already loading
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        state.status != FetchDataStatus.loadMore &&
        state.status != FetchDataStatus.loading) {
      context.read<VendorBloc>().add(FetchMoreVendorsEvent(widget.category));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorBloc, FetchDataState<Vendor>>(
      builder: (context, state) {
        // Check if there's an error and display error message
        if (state.status == FetchDataStatus.error) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }

        // Filter the vendors based on category
        final filteredVendors = widget.category == context.bazS.allTabBar
            ? state.data
            : state.data
                ?.where((vendor) => vendor.publications == widget.category)
                .toList();

        return Stack(
          children: [
            GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 23),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    context.getAspectRatio(mobile: 0.8, tablet: 0.9),
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (filteredVendors?.length ?? 0) +
                  (state.status == FetchDataStatus.loadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= filteredVendors!.length) {
                  // Show loading spinner if loading more items
                  return const Center(child: BazUiCircularProgressIndicator());
                }

                final Vendor vendor = filteredVendors[index];
                return BazUiVendorCard(
                  headlines: vendor.headlines ?? Constants.titleDefault,
                  imageUrl: vendor.imageUrl,
                  subheads: StarRating(
                    rating: vendor.numberStar ?? 0,
                    numberStar: const SizedBox(width: 10, height: 10),
                  ),
                );
              },
            ),
            // Show a loading indicator over the GridView if we're in the loading state
            if (state.status == FetchDataStatus.loading)
              const Center(
                child: Skeletonizer(
                  enabled: true,
                  child: BazUiCircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
