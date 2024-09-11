import 'package:bazar_books_app/features/home/models/home_models.dart';
import 'package:bazar_books_app/features/home/src/author/author_page.dart';
import 'package:bazar_books_app/features/home/src/vandors_page/vendors_page.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: BazUiBuiltInImage.icSearch(),
          onPressed: () {},
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselWithDots(),
            const SizedBox(height: 20),
            BazUiTextButton(
              text: 'See all',
              title: 'Top of Week',
              onSeeAllPressed: () {},
            ),
            const SizedBox(height: 10),
            const TopOfWeekBooks(),
            const SizedBox(height: 20),
            BazUiTextButton(
              text: 'See all',
              title: 'Best Vendors',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendorsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const BestVendors(),
            BazUiTextButton(
              text: 'See all',
              title: 'Authors',
              onSeeAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthorsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const AuthorsSection(),
          ],
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
