// lib/modules/orders/screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/models/order_model.dart';
import 'package:ecommerce_mobile/modules/orders/screens/track_order_screen.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/services/order_manager.dart';

import '../../../globals/text_styles.dart';

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

  // Safe style getters
  TextStyle _h2() => AppTextStyles.h2 ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle _h3() => AppTextStyles.body?.copyWith(fontSize: 16, fontWeight: FontWeight.w700)
      ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle _body() => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle _caption() => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    // Two tabs: Ongoing and Completed
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Snapshot-safe getter for existing orders
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

    if (_processedDeepLink) return;
    _processedDeepLink = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    debugPrint('OrdersScreen received args: $args');

    if (args is Map && args['openTrack'] == true && args['orderId'] != null) {
      final orderId = args['orderId'].toString();

      // try immediate open
      final currentOrders = _currentOrdersSnapshot();
      OrderModel? found;
      try {
        found = currentOrders.firstWhere((o) => o.id.toString() == orderId.toString());
      } catch (_) {
        found = null;
      }

      if (found != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(order: found!)));
        });
      } else {
        // listen until order appears
        final vl = OrderManager.instance.orders;
        if (vl is ValueNotifier<List<OrderModel>>) {
          void listener() {
            final updated = List<OrderModel>.from(vl.value);
            OrderModel? f;
            try {
              f = updated.firstWhere((o) => o.id.toString() == orderId.toString());
            } catch (_) {
              f = null;
            }
            if (f != null) {
              try {
                vl.removeListener(listener);
              } catch (_) {}
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(order: f!)));
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
    final fg = _statusColor(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: fg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: _caption().copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }

  Widget _orderCard(OrderModel order, {required bool ongoing}) {
    final item = order.items.isNotEmpty ? order.items.first : null;
    final image = item?.imageUrl ?? '';
    final title = item?.title ?? 'Unknown title';
    final subtitle = item?.size ?? '';
    final price = item?.price ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                  Text(subtitle, style: _caption()),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${price.toStringAsFixed(0)}', style: _h2().copyWith(fontSize: 16)),
                      const SizedBox(width: 8),
                      _statusPill(order.status),
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
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => TrackOrderScreen(order: order)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 40),
                    ),
                    child: Text(ongoing ? 'Track Order' : 'Leave Review', style: _body().copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 6),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
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
    return (m >= 1 && m <= 12) ? months[m - 1] : '';
  }

  // -----------------------------
  // Animated segmented control
  // driven by TabController.animation to avoid double-tap
  // -----------------------------

  Widget _animatedSegmentedControl() {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final gap = 8.0; // outer padding inside container (left+right total we subtract)
      final pillWidth = (totalWidth - gap) / 2;

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: SizedBox(
          height: 46,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Animated pill driven by TabController.animation
              AnimatedBuilder(
                animation: _tabController.animation!,
                builder: (context, child) {
                  // animation value will go 0.0 -> 1.0 (tab 0 -> tab 1)
                  final animValue = (_tabController.animation?.value ?? _tabController.index.toDouble()).clamp(0.0, 1.0);
                  final left = animValue * pillWidth;
                  return Transform.translate(
                    offset: Offset(left, 0),
                    child: child,
                  );
                },
                child: Container(
                  width: pillWidth,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                ),
              ),

              // Two tappable tabs
              Row(
                children: [
                  _animatedTab(label: 'Ongoing', index: 0),
                  _animatedTab(label: 'Completed', index: 1),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _animatedTab({required String label, required int index}) {
    // Use AnimatedBuilder to read animation value and compute selection factor
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // animateTo will start the controller animation immediately
          _tabController.animateTo(index, duration: const Duration(milliseconds: 320), curve: Curves.easeOutBack);
        },
        child: SizedBox(
          height: 46,
          child: Center(
            child: AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, _) {
                final val = (_tabController.animation?.value ?? _tabController.index.toDouble()).clamp(0.0, 1.0);
                // when index == 0: selectedFactor = 1 - val; when index == 1: selectedFactor = val
                final double selectedFactor = index == 0 ? (1.0 - val) : val;
                final double scale = 1.0 + 0.08 * selectedFactor; // scale up when selected
                final double opacity = 0.6 + 0.4 * selectedFactor; // fade
                final Color textColor = selectedFactor > 0.5 ? AppColors.primary : AppColors.textSecondary;

                final TextStyle style = selectedFactor > 0.5
                    ? _h3().copyWith(color: textColor)
                    : _body().copyWith(color: textColor);

                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: opacity,
                    child: Text(label, style: style),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // List builder
  // -----------------------------

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
      itemBuilder: (context, i) => _orderCard(list[i], ongoing: ongoing),
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
              // Animated pill segmented control
              _animatedSegmentedControl(),
              const SizedBox(height: AppSpacing.md),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Ongoing
                    ValueListenableBuilder<List<OrderModel>>(
                      valueListenable: OrderManager.instance.orders,
                      builder: (context, orders, _) {
                        final ongoing = orders.where((o) => !o.isCompleted && o.status != OrderStatus.cancelled).toList();
                        return _listFor(ongoing, ongoing: true);
                      },
                    ),

                    // Completed
                    ValueListenableBuilder<List<OrderModel>>(
                      valueListenable: OrderManager.instance.orders,
                      builder: (context, orders, _) {
                        final completed = orders.where((o) => o.isCompleted).toList();
                        return _listFor(completed, ongoing: false);
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
