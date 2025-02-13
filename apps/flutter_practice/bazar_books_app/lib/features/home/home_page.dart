import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/author_bloc/author_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/data/author_repository/author_repository.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_app/features/home/widgets/author/authors_section.dart';
import 'package:bazar_books_app/features/home/widgets/offer/offer.dart';
import 'package:bazar_books_app/features/home/widgets/product/products.dart';
import 'package:bazar_books_app/features/home/widgets/vendors/best_vendors.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/product_bloc/product_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RoutePaths.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                }),
            title: Text(
              context.bazS.generalTitleHome,
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: context.fontSize(SizeType.m),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: BazUiBuiltInImage.icBellOutline(),
                onPressed: () {
                  context.go(
                    '${RoutePaths.home}/${RoutePaths.notifications}',
                  );
                },
              ),
            ],
          ),
          body: MultiBlocProvider(
            providers: [
              BlocProvider<ProductBloc>(
                create: (BuildContext context) =>
                    ProductBloc(productRepository: getIt<ProductRepository>())
                      ..add(
                        GetProductsEvent(),
                      ),
              ),
              BlocProvider<VendorBloc>(
                create: (BuildContext context) => VendorBloc()
                  ..add(
                    GetBestVendors(),
                  ),
              ),
              BlocProvider<AuthorBloc>(
                create: (BuildContext context) =>
                    AuthorBloc(repository: getIt<AuthorRepository>())
                      ..add(
                        GetAuthorsEvent(),
                      ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                      onSeeAllPressed: () {
                        context.go(
                          '${RoutePaths.home}/${RoutePaths.vendors}',
                        );
                      },
                      text: context.bazS.generalSeeAll,
                    ),
                    const BestVendors(),
                    BazUiSection(
                      title: context.bazS.authorsTtile,
                      text: context.bazS.generalSeeAll,
                      onSeeAllPressed: () {
                        context.go(
                          '${RoutePaths.home}/${RoutePaths.authors}',
                        );
                      },
                    ),
                    const AuthorsSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
