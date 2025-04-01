import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String orderId;
  final String userId;

  const ChatPage({required this.orderId, required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details order")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Id orders: $orderId", style: const TextStyle(fontSize: 18)),
            Text("Id user buying: $userId",
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
