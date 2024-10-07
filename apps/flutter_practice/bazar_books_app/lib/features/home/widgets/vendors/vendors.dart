import 'package:bazar_books_app/features/home/widgets/vendors/vendors_grid.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
            fontSize: context.getFontSize(tablet: 30),
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
          VendorsGrid(category: context.bazS.allTabBar),
          VendorsGrid(category: context.bazS.booksTabBar),
          VendorsGrid(category: context.bazS.poemsTabBar),
          VendorsGrid(category: context.bazS.specialForYouTabBar),
          VendorsGrid(category: context.bazS.stationeryTabBar),
        ],
      ),
    );
  }
}
