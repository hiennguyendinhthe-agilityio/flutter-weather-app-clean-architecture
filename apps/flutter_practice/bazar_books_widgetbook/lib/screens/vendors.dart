// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/bloc/vendor_bloc/vendor_bloc.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_app/features/home/widgets/vendors/vendors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent vendorsScreenWidgetbooks() {
  return WidgetbookComponent(
    name: 'VendorsScreen',
    useCases: [
      WidgetbookUseCase(
        name: 'VendorsScreen',
        builder: (context) {
          return BlocProvider<VendorBloc>(
            create: (BuildContext context) =>
                VendorBloc(vendorRepository: getIt<Repository>())
                  ..add(
                    FetchAllVendorsEvent(),
                  ),
            child: const Vendors(),
          );
        },
      ),
    ],
  );
}
