// lib/models/order_model.dart

enum OrderStatus { packing, picked, inTransit, delivered, completed, cancelled }

class OrderItem {
  final String id;
  final String title;
  final String size;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.title,
    required this.size,
    required this.price,
    required this.imageUrl,
  });
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime orderDate;
  final String address;
  final String deliveryPersonName;
  final String deliveryPersonPhone;

  OrderModel({
    required this.id,
    required this.items,
    required this.status,
    required this.orderDate,
    required this.address,
    required this.deliveryPersonName,
    required this.deliveryPersonPhone,
  });

  bool get isCompleted => status == OrderStatus.delivered || status == OrderStatus.completed;
}
