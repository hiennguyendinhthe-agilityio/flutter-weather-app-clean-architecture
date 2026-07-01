import 'package:flutter_advanced_course/shop_app/core/models/cart_item.dart';
import 'package:flutter_advanced_course/shop_app/core/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  List<CartItem> build() => [];

  void addItem(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void decreaseItem(String productId) {
    final updated = List<CartItem>.from(state);
    final index = updated.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (updated[index].quantity <= 1) {
      updated.removeAt(index);
    } else {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
    }
    state = updated;
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void clearCart() => state = [];

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalCount => state.fold(0, (sum, item) => sum + item.quantity);
}
