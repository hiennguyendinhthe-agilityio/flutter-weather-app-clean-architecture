import 'package:flutter/material.dart';
import '../widgets/cocoloco_bottom_nav_bar.dart';
import 'browse_screen.dart';
import 'chat_screen.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<String> _cartItems = [];
  double _totalAmount = 0.0;

  void _addToCart(String title, double price) {
    setState(() {
      _cartItems.add(title);
      _totalAmount += price;
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _totalAmount = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order completed! See you at the pickup counter.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BrowseScreen(
        onAddToCart: _addToCart,
      ),
      FavoritesScreen(
        onAddToCart: _addToCart,
      ),
      OrdersScreen(
        cartItems: _cartItems,
        totalAmount: _totalAmount,
        onClearCart: _clearCart,
      ),
      const ChatScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CocolocoBottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
