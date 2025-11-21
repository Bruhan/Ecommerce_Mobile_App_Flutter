// lib/services/order_manager.dart
// Minimal OrderManager singleton with ValueNotifier<List<OrderModel>>
// This matches the OrdersScreen usage.

import 'package:flutter/foundation.dart';
import 'package:ecommerce_mobile/models/order_model.dart';

class OrderManager {
  OrderManager._internal() {
    // Start with an empty list — you can seed demo orders here if needed.
    _orders.value = [];
  }

  static final OrderManager _instance = OrderManager._internal();
  static OrderManager get instance => _instance;

  // ValueNotifier so UI can listen to changes
  final ValueNotifier<List<OrderModel>> _orders = ValueNotifier<List<OrderModel>>([]);
  ValueListenable<List<OrderModel>> get orders => _orders;

  // read snapshot
  List<OrderModel> get currentOrders => List<OrderModel>.from(_orders.value);

  // add order (new orders at front)
  void addOrder(OrderModel order) {
    final list = List<OrderModel>.from(_orders.value);
    list.insert(0, order);
    _orders.value = list;
  }

  // set/replace all orders (e.g. from API)
  void setOrders(List<OrderModel> list) {
    _orders.value = List<OrderModel>.from(list);
  }

  void removeOrder(String id) {
    final list = List<OrderModel>.from(_orders.value)..removeWhere((o) => o.id == id);
    _orders.value = list;
  }

  void clear() {
    _orders.value = [];
  }
}
