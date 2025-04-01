import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';

class OffersAndPromosScreen extends StatelessWidget {
  const OffersAndPromosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          context.bazS.offersAndPromosTtile,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: context.fontSize(SizeType.m),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Coming soon',
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: context.fontSize(SizeType.m),
          ),
        ),
      ),
    );
  }
}
