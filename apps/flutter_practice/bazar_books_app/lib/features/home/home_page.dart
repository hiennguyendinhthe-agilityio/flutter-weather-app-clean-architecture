import 'package:bazar_books_app/features/auth/presentation/sign_in.dart';
import 'package:bazar_books_app/features/home/widgets/product/products.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/product_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final productApi = ApiService(Dio());

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
      body: BlocProvider(
        create: (context) => ProductBloc(productApi)
          ..add(
            GetProductsEvent(),
          ),
        child: const Products(),
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
