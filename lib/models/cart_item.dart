// lib/models/cart_item.dart
class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final int price; // price per unit (integer cents/units as you currently use)
  final String size;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.quantity,
  });

  int get totalPrice => price * quantity;

  // simple serialization helpers (optional; useful if you want to persist cart)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      price: (map['price'] is int) ? map['price'] : int.tryParse(map['price']?.toString() ?? '0') ?? 0,
      size: map['size']?.toString() ?? '',
      quantity: (map['quantity'] is int) ? map['quantity'] : int.tryParse(map['quantity']?.toString() ?? '1') ?? 1,
    );
  }
}
