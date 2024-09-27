import 'package:bazar_books_app/features/home/widgets/vendors/vendors_grid.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/tabbar/tabbar.dart';
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
          style: context.textTheme.titleLarge,
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
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Books'),
          Tab(text: 'Poems'),
          Tab(text: 'Special for you'),
          Tab(text: 'Stationery'),
          Tab(text: 'Stationery'),
        ],
        child: const [
          VendorsGrid(),
          Center(child: Text('Books')),
          Center(child: Text('Poems')),
          Center(child: Text('Special for you')),
          Center(child: Text('Stationery')),
          Center(child: Text('Stationery')),
        ],
      ),
    );
  }
}
