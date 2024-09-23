import 'package:bazar_books_app/features/auth/presentation/sign_in.dart';
import 'package:bazar_books_app/features/home/widgets/offer/offer.dart';
import 'package:bazar_books_app/features/home/widgets/product/products.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'widgets/author/authors.dart';
import 'widgets/vendors/best_vendors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: BazUiBuiltInImage.icSearch(),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: Text(
          'Home',
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: BazUiBuiltInImage.icBellOutline(),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Offer(),
              BazUiSection(
                title: context.bazS.homePageTopOfWeek,
                onSeeAllPressed: () {},
              ),
              const Products(),
              BazUiSection(
                title: context.bazS.homePageBestVendors,
                onSeeAllPressed: () {},
                text: context.bazS.generalSeeAll,
              ),
              const BestVendors(),
              BazUiSection(
                title: context.bazS.homePageAuthors,
                text: context.bazS.generalSeeAll,
                onSeeAllPressed: () {},
              ),
              const AuthorsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: BazUiBuiltInImage.icHomeFill(
                color: context.colorScheme.primary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: BazUiBuiltInImage.icMenuFill(
                color: context.colorScheme.tertiary),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: BazUiBuiltInImage.icCardFill(
                color: context.colorScheme.tertiary),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: BazUiBuiltInImage.icProfileFill(
                color: context.colorScheme.tertiary),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
