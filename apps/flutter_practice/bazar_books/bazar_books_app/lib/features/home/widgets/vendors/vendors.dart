import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Vendors extends StatelessWidget {
  const Vendors({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VendorBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.go(RoutePaths.home);
            },
          ),
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
      ),
    );
  }
}

class GetListVendor extends StatelessWidget {
  const GetListVendor({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            context.read<VendorBloc>().add(VendorRefresh());
          },
          child: const _List(),
        ),
      ),
    );
  }
}

class _List extends StatefulWidget {
  const _List();

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<VendorBloc>().add(VendorFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorBloc, VendorState>(
      builder: (context, state) {
        final data = state.vendors;
        if (data != null) {
          return ResponsiveGridListBuilder(
            minItemWidth: 1,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 12,
            verticalGridSpacing: 12.h,
            gridItems: List.generate(
              !state.hasReachedMax && state.status == VendorStatus.loading
                  ? data.length + 1
                  : data.length,
              (index) {
                if (index < data.length) {
                  return BazUiVendorCard(
                    headlines: data[index].headlines ?? Constants.titleDefault,
                    imageUrl: data[index].imageUrl,
                    subheads: StarRating(
                      rating: data[index].numberStar ?? 0,
                      numberStar: const SizedBox(width: 10, height: 10),
                    ),
                  );
                }
                return const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: BazUiCircularProgressIndicator(),
                  ),
                );
              },
            ),
            builder: (BuildContext context, List<Widget> items) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                },
              );
            },
          );
        }
        if (state.status == VendorStatus.loading) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Text("no posts found");
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<VendorBloc>().add(VendorNextPage());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
