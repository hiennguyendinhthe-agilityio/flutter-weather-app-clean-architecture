import 'package:bazar_books_app/features/auth/presentation/sign_in.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/widgets/product/products.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/product_bloc.dart';
import 'widgets/vendors/best_vendors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final apiService = ApiService(Dio());

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
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(apiService)
                ..add(
                  GetProductsEvent(),
                ),
            ),
            BlocProvider<VendorBloc>(
              create: (BuildContext context) => VendorBloc(apiService)
                ..add(
                  GetVendorsEvent(),
                ),
            ),
          ],
          child: Column(
            children: [
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
