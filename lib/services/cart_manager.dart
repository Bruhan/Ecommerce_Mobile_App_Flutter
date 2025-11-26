// lib/services/cart_manager.dart
import 'package:flutter/foundation.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';
import 'package:ecommerce_mobile/services/saved_manager.dart';

class CartManager extends ChangeNotifier {
  CartManager._internal();
  static final CartManager instance = CartManager._internal();

  // Items
  final List<CartItem> _items = [];

  // public read-only view
  List<CartItem> get items => List.unmodifiable(_items);

  // shipping / vat (defaults — you can change as needed)
  double shippingFee = 0.0;
  double vatAmount = 0.0;

  // Coupon
  String? couponCode;
  double couponDiscount = 0.0;

  // --- Item management methods ---

  /// Add item to cart. If an item with same `id` exists, increment its quantity instead of adding duplicate.
  /// NOTE: Merges by `id` only. If you want to keep different `size`/format as separate items, change index check.
  void addItem(CartItem item) {
    final idx = _items.indexWhere((it) => it.id == item.id);
    if (idx >= 0) {
      // Merge quantities into the existing entry
      final existing = _items[idx];
      existing.quantity = existing.quantity + item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  /// Remove by id+size — this will move the item to Saved items instead of permanent deletion.
  /// If you need a hard remove, call removePermanently(...)
  void removeItem(dynamic id, {String? size}) {
    moveToSaved(id, size: size);
    // notifyListeners() handled inside moveToSaved
  }

  /// Update quantity; if quantity <= 0 then move to Saved items.
  void updateQuantity(dynamic id, String? size, int quantity) {
    final idx = _items.indexWhere((it) => it.id == id && (size == null || it.size == size));
    if (idx >= 0) {
      if (quantity <= 0) {
        moveToSaved(id, size: size);
        return;
      }
      final it = _items[idx];
      it.quantity = quantity;
      notifyListeners();
    }
  }

  /// Hard remove without moving to saved (for internal use if needed)
  void removePermanently(dynamic id, {String? size}) {
    _items.removeWhere((it) => it.id == id && (size == null || it.size == size));
    notifyListeners();
  }

  /// Move an item (or all matching items with same id) to SavedManager and remove from cart.
  /// Returns the removed CartItem (combined) if found, otherwise null.
  /// SavedManager expects a Map<String, dynamic>, so we call toMap() on a representative item.
  CartItem? moveToSaved(dynamic id, {String? size}) {
    // Gather all items matching the id (ignore size when collecting so duplicates are merged)
    final matching = _items.where((it) => it.id == id).toList();
    if (matching.isEmpty) return null;

    // Remove all matching items from cart
    _items.removeWhere((it) => it.id == id);
    notifyListeners();

    // Combine into a single representative CartItem to save (quantity will be sum)
    final totalQty = matching.fold<int>(0, (acc, it) => acc + it.quantity);
    final rep = CartItem(
      id: matching[0].id,
      title: matching[0].title,
      imageUrl: matching[0].imageUrl,
      price: matching[0].price,
      size: matching[0].size,
      quantity: totalQty,
    );

    try {
      // SavedManager stores maps — we don't care about quantity in saved list but we pass it anyway.
      SavedManager.instance.add(rep.toMap());
    } catch (e) {
      debugPrint('Error adding to saved: $e');
    }

    return rep;
  }

  void clearItems() {
    _items.clear();
    couponCode = null;
    couponDiscount = 0.0;
    notifyListeners();
  }

  // --- Price getters (all doubles) ---
  double get subtotal {
    double s = 0.0;
    for (final it in _items) {
      s += (it.price) * (it.quantity);
    }
    return s;
  }

  double get totalVat => vatAmount;

  // final computed total that respects coupon discount
  double get totalPrice {
    final s = subtotal;
    final total = (s + shippingFee + vatAmount) - couponDiscount;
    return total < 0 ? 0.0 : total;
  }

  int get itemCount => _items.length;

  // --- Coupon functions ---
  void applyCoupon(String code, double discount) {
    couponCode = code;
    couponDiscount = discount;
    notifyListeners();
  }

  void removeCoupon() {
    couponCode = null;
    couponDiscount = 0.0;
    notifyListeners();
  }
}
