import 'package:flutter/material.dart';
import 'cart_screen.dart';

class OrdersScreen extends StatelessWidget {
  final List<String> cartItems;
  final double totalAmount;
  final VoidCallback onClearCart;

  const OrdersScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    return CartScreen(
      onCheckout: onClearCart,
    );
  }
}
