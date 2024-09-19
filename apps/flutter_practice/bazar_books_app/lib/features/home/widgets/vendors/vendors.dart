import 'package:bazar_books_app/features/home/models/home_models.dart';
import 'package:bazar_books_design/widgets/tabbar/tabbar.dart';
import 'package:flutter/material.dart';

class Vendors extends StatelessWidget {
  const Vendors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BazUiTabbarView(
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Books'),
          Tab(text: 'Poems'),
          Tab(text: 'Special for you'),
          Tab(text: 'Stationery'),
          Tab(text: 'Stationery'),
        ],
        child: [
          VendorsGrid(),
          const Center(child: Text('Books')),
          const Center(child: Text('Poems')),
          const Center(child: Text('Special for you')),
          const Center(child: Text('Stationery')),
          const Center(child: Text('Stationery')),
        ],
      ),
    );
  }
}
