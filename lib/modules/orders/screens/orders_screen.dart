import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/models/order_model.dart';
import 'package:ecommerce_mobile/modules/orders/screens/track_order_screen.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/services/order_manager.dart'; // <<-- ensure this exists

class OrdersScreen extends StatefulWidget {
  static const routeName = Routes.orders;
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _error;
  bool _processedDeepLink = false;

  // Safe text style getters — fallback if tokens missing
  TextStyle _h2() => AppTextStyles.h2 ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle _h3() =>
      AppTextStyles.body?.copyWith(fontSize: 16, fontWeight: FontWeight.w700) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle _body() => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle _caption() => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // snapshot-safe getter
  List<OrderModel> _currentOrdersSnapshot() {
    final vl = OrderManager.instance.orders;
    if (vl is ValueNotifier<List<OrderModel>>) {
      return List<OrderModel>.from(vl.value);
    }
    return <OrderModel>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_processedDeepLink) {
      _processedDeepLink = true;

      final args = ModalRoute.of(context)?.settings.arguments;
      debugPrint('OrdersScreen received args: $args');

      if (args is Map && args['openTrack'] == true && args['orderId'] != null) {
        final String orderId = args['orderId'].toString();

        // attempt immediate open
        final currentOrders = _currentOrdersSnapshot();
        OrderModel? existing;
        try {
          existing = currentOrders.firstWhere((o) => o.id.toString() == orderId.toString());
        } catch (_) {
          existing = null;
        }

        if (existing != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(order: existing!)));
            } catch (e) {
              debugPrint('Failed to push TrackOrder (immediate): $e');
              Navigator.push(context, MaterialPageRoute(builder: (_) => TrackOrderScreen(order: existing!)));
            }
          });
        } else {
          final vl = OrderManager.instance.orders;
          if (vl is ValueNotifier<List<OrderModel>>) {
            void listener() {
              final updated = List<OrderModel>.from(vl.value);
              OrderModel? found;
              try {
                found = updated.firstWhere((o) => o.id.toString() == orderId.toString());
              } catch (_) {
                found = null;
              }

              if (found != null) {
                try {
                  vl.removeListener(listener);
                } catch (_) {}
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    try {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(order: found!)));
                    } catch (e) {
                      debugPrint('Failed to push TrackOrder (deferred): $e');
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TrackOrderScreen(order: found!)));
                    }
                  });
                }
              }
            }

            vl.addListener(listener);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order not loaded yet. Check My Orders later.')));
            });
          }
        }
      }
    }
  }

  String _statusText(OrderStatus s) {
    switch (s) {
      case OrderStatus.packing:
        return 'Packing';
      case OrderStatus.picked:
        return 'Picked';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.packing:
        return Colors.orange.shade600;
      case OrderStatus.picked:
        return Colors.amber.shade700;
      case OrderStatus.inTransit:
        return Colors.blue.shade600;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return Colors.green.shade600;
      case OrderStatus.cancelled:
        return Colors.red.shade600;
    }
  }

  Widget _statusPill(OrderStatus s) {
    final label = _statusText(s);
    final bg = _statusColor(s).withOpacity(0.12);
    final fg = _statusColor(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: _caption().copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }

  Widget _orderCard(OrderModel order, {required bool ongoing}) {
    final item = order.items.isNotEmpty ? order.items.first : null;
    final image = item?.imageUrl ?? '';
    final title = item?.title ?? 'Unknown title';
    final authorOrSize = item?.size ?? '';
    final price = item?.price ?? 0;
    final status = order.status;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image.isNotEmpty
                  ? Image.network(image, width: 84, height: 110, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 84, height: 110, color: AppColors.bg))
                  : Container(width: 84, height: 110, color: AppColors.bg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _h3(), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(authorOrSize, style: _caption()),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${price.toStringAsFixed(0)}', style: _h2().copyWith(fontSize: 16)),
                      const SizedBox(width: 8),
                      _statusPill(status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Ordered ${_formatDate(order.orderDate)}', style: _caption()),
                  const SizedBox(height: 4),
                  Text(order.id, style: _caption()),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('TRACK pressed for order ${order.id} -> forcing root navigator push');
                        try {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (_) => TrackOrderScreen(order: order)),
                          );
                        } catch (e) {
                          debugPrint('Direct root push failed: $e — falling back to local push.');
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TrackOrderScreen(order: order)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary ?? Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 40),
                      ),
                      child: Text(ongoing ? 'Track Order' : 'Leave Review', style: _body().copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(leading: const Icon(Icons.receipt), title: const Text('View Invoice'), onTap: () => Navigator.pop(context)),
                            ListTile(leading: const Icon(Icons.refresh), title: const Text('Reorder'), onTap: () => Navigator.pop(context)),
                            ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help'), onTap: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')} ${_monthShort(d.month)} ${d.year}';
  }

  String _monthShort(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    if (m >=1 && m <=12) return months[m-1];
    return '';
  }

  Widget _listFor(List<OrderModel> list, {required bool ongoing}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(ongoing ? 'No ongoing orders' : 'No completed orders', style: _caption()),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        final o = list[i];
        return _orderCard(o, ongoing: ongoing);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text('My Orders', style: _h2()),
          centerTitle: true,
        ),
        body: Center(child: Text(_error!, style: _body())),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('My Orders', style: _h2()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.textPrimary ?? Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  tabs: const [
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ValueListenableBuilder<List<OrderModel>>(
                      valueListenable: OrderManager.instance.orders,
                      builder: (context, orders, _) {
                        final ongoing = orders.where((o) => !(o.isCompleted) && o.status != OrderStatus.cancelled).toList();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: _listFor(ongoing, ongoing: true),
                        );
                      },
                    ),
                    ValueListenableBuilder<List<OrderModel>>(
                      valueListenable: OrderManager.instance.orders,
                      builder: (context, orders, _) {
                        final completed = orders.where((o) => o.isCompleted).toList();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: _listFor(completed, ongoing: false),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
