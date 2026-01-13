import 'package:flutter/foundation.dart';
import 'package:ecommerce_mobile/models/order_model.dart';

class OrderManager {
  OrderManager._internal() {
    
    _orders.value = [];
  }

  static final OrderManager _instance = OrderManager._internal();
  static OrderManager get instance => _instance;

 
  final ValueNotifier<List<OrderModel>> _orders = ValueNotifier<List<OrderModel>>([]);
  ValueListenable<List<OrderModel>> get orders => _orders;

 
  List<OrderModel> get currentOrders => List<OrderModel>.from(_orders.value);

  
  void addOrder(OrderModel order) {
    final list = List<OrderModel>.from(_orders.value);
    list.insert(0, order);
    _orders.value = list;
  }

 
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
