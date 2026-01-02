import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import '../../../models/order_model.dart';
import 'package:ecommerce_mobile/routes/routes.dart';


class TrackOrderScreen extends StatelessWidget {
  final OrderModel order;
  const TrackOrderScreen({super.key, required this.order});

  String _etaForStatus(OrderStatus s) {
    switch (s) {
      case OrderStatus.packing:
        return 'Estimated: 2-3 days — preparing your order';
      case OrderStatus.picked:
        return 'Estimated: 1-3 days — with the pickup team';
      case OrderStatus.inTransit:
        return 'Estimated: 1-2 days — on the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Order cancelled';
      default:
        return '';
    }
  }

  Color _stepColor(bool done) => done ? (AppColors.primary ?? Colors.black) : Colors.grey.shade300;
  TextStyle _titleStyle() => AppTextStyles.h2 ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle _subtitleStyle() => AppTextStyles.caption ?? const TextStyle(fontSize: 13, color: Colors.grey);

  Widget _step({
    required String title,
    required String subtitle,
    required bool done,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // timeline marker
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: done ? (AppColors.primary ?? Colors.black) : Colors.white,
                border: Border.all(color: _stepColor(done), width: done ? 0 : 1.5),
                shape: BoxShape.circle,
                boxShadow: done
                    ? [
                        BoxShadow(color: (AppColors.primary ?? Colors.black).withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))
                      ]
                    : null,
              ),
              child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 56,
                color: Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(vertical: 6),
              ),
          ],
        ),

        const SizedBox(width: 14),

        // content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _titleStyle().copyWith(fontSize: 15)),
                const SizedBox(height: 6),
                Text(subtitle, style: _subtitleStyle()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -------------------- Helpers to safely extract numeric/text values --------------------
  double _safeNum(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    try {
      return (value as dynamic).toDouble();
    } catch (_) {
      return 0.0;
    }
  }

  // Try to get a numeric field from order by multiple possible property names
  double _getOrderNumber(dynamic orderObj, List<String> candidates) {
    for (final key in candidates) {
      try {
        if (orderObj is Map) {
          if (orderObj.containsKey(key)) return _safeNum(orderObj[key]);
        } else {
          final val = (orderObj as dynamic).toJson != null
              ? (orderObj as dynamic).toJson()[key]
              : (orderObj as dynamic).__proto__ == null // fallback attempt
                  ? null
                  : (orderObj as dynamic).noSuchMethod; // will fail gracefully below
          if (val != null) return _safeNum(val);
        }
      } catch (_) {
        // ignore and try next
      }
    }

    // try direct dynamic access as last resort
    for (final key in candidates) {
      try {
        final v = (orderObj as dynamic)[key];
        if (v != null) return _safeNum(v);
      } catch (_) {}
      try {
        final v2 = (orderObj as dynamic).noSuchMethod;
        if (v2 != null) return _safeNum(v2);
      } catch (_) {}
    }
    return 0.0;
  }

  // Extract a string-like field safely
  String _getOrderString(dynamic orderObj, List<String> candidates) {
    for (final key in candidates) {
      try {
        if (orderObj is Map) {
          if (orderObj.containsKey(key) && orderObj[key] != null) return orderObj[key].toString();
        } else {
          final v = (orderObj as dynamic).toJson != null ? (orderObj as dynamic).toJson()[key] : null;
          if (v != null) return v.toString();
        }
      } catch (_) {}
      try {
        final v2 = (orderObj as dynamic)[key];
        if (v2 != null) return v2.toString();
      } catch (_) {}
      try {
        final v3 = (orderObj as dynamic).noSuchMethod;
        if (v3 != null) return v3.toString();
      } catch (_) {}
    }
    return '';
  }

  // Safely compute subtotal from items (supports Map items or typed objects)
  double _computeSubtotal(List<dynamic>? items) {
    if (items == null) return 0.0;
    double s = 0.0;
    for (final e in items) {
      double price = 0.0;
      int qty = 1;
      try {
        if (e is Map) {
          price = _safeNum(e['price'] ?? e['mrp'] ?? e['amount'] ?? e['unitPrice'] ?? 0);
          qty = (e['quantity'] ?? e['qty'] ?? 1) is num ? (e['quantity'] ?? e['qty'] ?? 1).toInt() : int.tryParse((e['quantity'] ?? e['qty'] ?? '1').toString()) ?? 1;
        } else {
          // attempt to access common fields on OrderItem
          try {
            final p = (e as dynamic).price ?? (e as dynamic).mrp ?? (e as dynamic).amount ?? (e as dynamic).unitPrice;
            price = _safeNum(p);
          } catch (_) {
            price = 0.0;
          }
          try {
            final q = (e as dynamic).quantity ?? (e as dynamic).qty ?? 1;
            qty = (q is num) ? q.toInt() : int.tryParse(q.toString()) ?? 1;
          } catch (_) {
            qty = 1;
          }
        }
      } catch (_) {
        price = 0.0;
        qty = 1;
      }
      s += price * qty;
    }
    return s;
  }

  // Extract items list safely from order (returns empty list on failure)
  List<dynamic> _extractItems(dynamic orderObj) {
    try {
      if (orderObj == null) return [];
      if (orderObj is Map) {
        final val = orderObj['items'] ?? orderObj['orderItems'] ?? orderObj['products'];
        if (val is List) return val;
      } else {
        // try typed property
        try {
          final val = (orderObj as dynamic).items ?? (orderObj as dynamic).orderItems ?? (orderObj as dynamic).products;
          if (val is List) return val;
        } catch (_) {}
        // try toJson fallback
        try {
          final json = (orderObj as dynamic).toJson();
          if (json != null) {
            final val2 = json['items'] ?? json['orderItems'] ?? json['products'];
            if (val2 is List) return val2;
          }
        } catch (_) {}
      }
    } catch (_) {}
    return [];
  }

  // -------------------- Order Details Modal --------------------
  void _showOrderDetails(BuildContext context) {
    final items = _extractItems(order);
    final subtotal = _computeSubtotal(items);

    // shipping: look for several candidate names
    final shipping = _getOrderNumber(order, ['shippingFee', 'shipping', 'shippingCharge', 'shipping_cost', 'shippingFeeAmount']);
    final vat = _getOrderNumber(order, ['vat', 'tax', 'taxAmount', 'gst']) ;
    // discount
    final discount = _getOrderNumber(order, ['discount', 'couponDiscount', 'discountAmount']);

    final totalFromOrder = _getOrderNumber(order, ['total', 'orderTotal', 'totalPrice', 'grandTotal']);
    final total = totalFromOrder > 0 ? totalFromOrder : (subtotal + shipping + vat - discount);

    final deliveryAddress = _getOrderString(order, ['address', 'shippingAddress', 'deliveryAddress']);
    final deliveryName = _getOrderString(order, ['deliveryPersonName', 'deliveryName', 'courierName']);
    final deliveryPhone = _getOrderString(order, ['deliveryPersonPhone', 'deliveryPhone', 'courierPhone']);
    final orderId = _getOrderString(order, ['id', 'orderId', 'order_id']);

    // deliveredAt
    final deliveredAt = _getOrderString(order, ['deliveredAt', 'delivered_on', 'deliveredAtDate', 'deliveredDate', 'completedAt']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        Widget itemRow(dynamic it) {
          String title = '';
          String img = '';
          String priceStr = '';
          String qtyStr = '';
          try {
            if (it is Map) {
              title = (it['title'] ?? it['name'] ?? '').toString();
              img = (it['imageUrl'] ?? it['image'] ?? '').toString();
              final priceVal = _safeNum(it['price'] ?? it['mrp'] ?? it['unitPrice'] ?? 0);
              priceStr = '\₹${priceVal.toStringAsFixed(priceVal == priceVal.toInt() ? 0 : 2)}';
              qtyStr = (it['quantity'] ?? it['qty'] ?? 1).toString();
            } else {
              // typed object
              try {
                title = (it as dynamic).title ?? (it as dynamic).name ?? '';
              } catch (_) {}
              try {
                img = (it as dynamic).imageUrl ?? (it as dynamic).image ?? '';
              } catch (_) {}
              try {
                final priceVal = _safeNum((it as dynamic).price ?? (it as dynamic).mrp ?? (it as dynamic).unitPrice ?? 0);
                priceStr = '\₹${priceVal.toStringAsFixed(priceVal == priceVal.toInt() ? 0 : 2)}';
              } catch (_) {}
              try {
                qtyStr = ((it as dynamic).quantity ?? (it as dynamic).qty ?? 1).toString();
              } catch (_) {}
            }
          } catch (_) {}

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: img.isNotEmpty
                      ? Image.network(img, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.bg ?? Colors.grey.shade100))
                      : Container(width: 56, height: 56, color: AppColors.bg ?? Colors.grey.shade100),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.isNotEmpty ? title : 'Product', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(priceStr.isNotEmpty ? priceStr : '-', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.fieldBorder ?? Colors.grey.shade300)),
                  child: Text('x$qtyStr', style: AppTextStyles.caption),
                ),
              ],
            ),
          );
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  Row(
                    children: [
                      if (items.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (() {
                            final it = items.first;
                            final img = (it is Map ? (it['imageUrl'] ?? '') : (it?.imageUrl ?? ''))?.toString() ?? '';
                            if (img.isNotEmpty) {
                              return Image.network(img, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: AppColors.bg ?? Colors.grey.shade100));
                            } else {
                              return Container(width: 72, height: 72, color: AppColors.bg ?? Colors.grey.shade100);
                            }
                          })(),
                        )
                      else
                        Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.bg ?? Colors.grey.shade100, borderRadius: BorderRadius.circular(8))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order #${orderId.isNotEmpty ? orderId : '—'}', style: AppTextStyles.caption?.copyWith(color: AppColors.textSecondary ?? Colors.grey)),
                            const SizedBox(height: 6),
                            Text(order.status.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(), style: AppTextStyles.h2?.copyWith(fontSize: 18)),
                            const SizedBox(height: 6),
                            Text(_etaForStatus(order.status), style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Big status card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: (order.status == OrderStatus.delivered) ? (AppColors.surface ?? Colors.white) : (AppColors.bg ?? Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: (order.status == OrderStatus.delivered) ? (AppColors.primary ?? Colors.green) : Colors.transparent, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(order.status == OrderStatus.delivered ? Icons.check_circle : Icons.local_shipping_outlined,
                                color: order.status == OrderStatus.delivered ? Colors.green : (AppColors.primary ?? Colors.black), size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text((order.status == OrderStatus.delivered) ? 'Delivered' : order.status.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(),
                                  style: AppTextStyles.h2?.copyWith(fontSize: 18, color: (order.status == OrderStatus.delivered) ? Colors.green : null)),
                            ),
                            if (deliveredAt.isNotEmpty) Text(deliveredAt, style: AppTextStyles.caption),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 14, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(6)))),
                              const SizedBox(width: 8),
                              Icon(Icons.check_circle, size: 14, color: (order.status.index >= 3) ? Colors.green : Colors.grey.shade300),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('See all updates', style: AppTextStyles.body?.copyWith(color: AppColors.primary ?? Colors.black)),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Items list
                  Text('Items in this order', style: AppTextStyles.h2?.copyWith(fontSize: 16)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface ?? Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
                    ),
                    child: Column(children: [for (final it in items) itemRow(it)]),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Delivery details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface ?? Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Delivery details', style: AppTextStyles.h2?.copyWith(fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.home_outlined, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(child: Text(deliveryAddress.isNotEmpty ? deliveryAddress : 'No address provided', style: _subtitleStyle())),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Icon(Icons.person_outline, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(child: Text(deliveryName.isNotEmpty ? '$deliveryName • $deliveryPhone' : '—', style: _subtitleStyle())),
                      ]),
                    ]),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Price details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface ?? Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Price details', style: AppTextStyles.h2?.copyWith(fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Listing price', style: AppTextStyles.body), Text('\₹${subtotal.toStringAsFixed(0)}')]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Shipping', style: AppTextStyles.body), Text('\₹${shipping.toStringAsFixed(0)}')]),
                      const SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('VAT', style: AppTextStyles.body), Text('\₹${vat.toStringAsFixed(0)}')]),
                      const Divider(height: AppSpacing.md * 1.2),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total amount', style: AppTextStyles.h2?.copyWith(fontSize: 16)),
                        Text('\₹${total.toStringAsFixed(0)}', style: AppTextStyles.h2?.copyWith(fontSize: 16))
                      ]),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Download Invoice')));
                        },
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Download Invoice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary ?? Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Order id + CTA
                  Row(children: [
                    Expanded(child: Text('Order ID', style: AppTextStyles.caption?.copyWith(color: AppColors.textSecondary ?? Colors.grey))),
                    Expanded(child: Text(orderId.isNotEmpty ? orderId : '—', textAlign: TextAlign.right, style: AppTextStyles.body)),
                  ]),

                  const SizedBox(height: AppSpacing.sm),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushNamed(ctx, Routes.home);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: AppColors.fieldBorder ?? Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Shop more', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Order status flow (ordered sequence)
    final statusOrder = [OrderStatus.packing, OrderStatus.picked, OrderStatus.inTransit, OrderStatus.delivered];

    final currentIndex = statusOrder.indexOf(order.status);
    final safeIndex = currentIndex < 0 ? 0 : currentIndex;

    final deliveryAddress = _getOrderString(order, ['address', 'shippingAddress', 'deliveryAddress']);
    final orderId = _getOrderString(order, ['id', 'orderId', 'order_id']);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Track Order', style: AppTextStyles.h2 ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top status card (no map)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface ?? Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Order #${orderId.isNotEmpty ? orderId : '—'}', style: AppTextStyles.caption?.copyWith(color: AppColors.textSecondary ?? Colors.grey) ?? const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(order.status.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(), style: AppTextStyles.h2?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: (AppColors.primary ?? Colors.black).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                  child: Text(_etaForStatus(order.status), style: AppTextStyles.caption?.copyWith(color: AppColors.primary ?? Colors.black) ?? const TextStyle(color: Colors.black)),
                ),
              ]),
              const SizedBox(height: AppSpacing.sm),

              // small progress indicator (visual)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: List.generate(statusOrder.length, (i) {
                    final done = i <= safeIndex;
                    return Expanded(
                      child: Container(
                        height: 6,
                        margin: EdgeInsets.only(left: i == 0 ? 0 : 8, right: i == statusOrder.length - 1 ? 0 : 0),
                        decoration: BoxDecoration(color: done ? (AppColors.primary ?? Colors.black) : Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                      ),
                    );
                  }),
                ),
              ),
            ]),
          ),

          const SizedBox(height: AppSpacing.md),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(color: AppColors.surface ?? Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Order Status', style: AppTextStyles.h2?.copyWith(fontSize: 16)),
                      const SizedBox(height: AppSpacing.sm),
                      _step(title: 'Packing', subtitle: 'We are preparing your items', done: safeIndex >= 0, isLast: false),
                      const SizedBox(height: 8),
                      _step(title: 'Picked', subtitle: 'Handed over to the logistics partner', done: safeIndex >= 1, isLast: false),
                      const SizedBox(height: 8),
                      _step(title: 'In Transit', subtitle: 'On the way to destination', done: safeIndex >= 2, isLast: false),
                      const SizedBox(height: 8),
                      _step(title: 'Delivered', subtitle: 'Delivered to recipient address', done: safeIndex >= 3, isLast: true),
                    ]),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Actions
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact support tapped')));
                        },
                        icon: const Icon(Icons.help_outline),
                        label: Text('Get Help', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: BorderSide(color: AppColors.fieldBorder ?? Colors.grey.shade300), padding: const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showOrderDetails(context),
                        icon: const Icon(Icons.receipt_long),
                        label: Text('Order Details', style: AppTextStyles.body?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary ?? Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                  ]),

                  const SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
