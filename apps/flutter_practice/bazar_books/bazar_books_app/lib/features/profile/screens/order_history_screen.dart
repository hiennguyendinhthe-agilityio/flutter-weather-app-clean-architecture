import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String? orderId;

  const OrderHistoryScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: Center(
        child: Text(
            orderId != null ? "Order ID: $orderId" : "No order history found"),
      ),
    );
  }
}
