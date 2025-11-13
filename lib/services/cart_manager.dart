// lib/services/cart_manager.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

/// Simple singleton cart manager.
/// Uses ChangeNotifier so you can listen for updates if you wire it to Provider
/// or other state management later.
class CartManager extends ChangeNotifier {
  CartManager._internal();
  static final CartManager instance = CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Add item to cart. If same product id + size exists, increment quantity.
  void addItem(CartItem item) {
    try {
      final idx = _items.indexWhere((e) => e.id == item.id && e.size == item.size);
      if (idx == -1) {
        _items.add(item);
      } else {
        _items[idx].quantity += item.quantity;
      }
      notifyListeners();
    } catch (e) {
      // swallow unexpected errors but print for debugging
      if (kDebugMode) print('CartManager.addItem error: $e');
    }
  }

  void removeItem(String id, {String? size}) {
    _items.removeWhere((e) => e.id == id && (size == null || e.size == size));
    notifyListeners();
  }

  void updateQuantity(String id, String size, int quantity) {
    final idx = _items.indexWhere((e) => e.id == id && e.size == size);
    if (idx != -1) {
      if (quantity <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount => _items.fold<int>(0, (a, b) => a + b.quantity);

  int get subtotal => _items.fold<int>(0, (a, b) => a + b.totalPrice);

  // Example: shipping or VAT can be calculated here or externally
  int get shippingFee => 80; // sample static fee
  double get vatPercent => 0.0;

  double get vatAmount => subtotal * (vatPercent / 100);

  double get total => subtotal + shippingFee + vatAmount;
}
