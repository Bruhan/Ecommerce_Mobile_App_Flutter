import 'package:flutter/foundation.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';

class CartManager extends ChangeNotifier {
  CartManager._internal();
  static final CartManager instance = CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    // Try to find same item id+size and increment quantity
    final idx = _items.indexWhere((i) => i.id == item.id && i.size == item.size);
    if (idx >= 0) {
      _items[idx].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id, {required String size}) {
    _items.removeWhere((i) => i.id == id && i.size == size);
    notifyListeners();
  }

  void updateQuantity(String id, String size, int quantity) {
    final idx = _items.indexWhere((i) => i.id == id && i.size == size);
    if (idx >= 0) {
      _items[idx].quantity = quantity;
      if (_items[idx].quantity <= 0) _items.removeAt(idx);
      notifyListeners();
    }
  }

  // Simple summary getters
  int get subtotal => _items.fold(0, (s, i) => s + (i.price * i.quantity));
  int get shippingFee => _items.isEmpty ? 0 : 80;
  double get vatAmount => 0.0; // placeholder
  double get total => subtotal + shippingFee + vatAmount;
}
