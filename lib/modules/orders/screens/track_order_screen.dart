// lib/modules/orders/screens/track_order_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import '../../../models/order_model.dart';

class TrackOrderScreen extends StatelessWidget {
  final OrderModel order;
  const TrackOrderScreen({super.key, required this.order});

  Widget _timelineItem({required String title, required String subtitle, required bool done}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: done ? (AppColors.primary ?? Colors.black) : Colors.white,
                border: Border.all(color: done ? (AppColors.primary ?? Colors.black) : Colors.grey, width: 2),
                shape: BoxShape.circle,
              ),
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h2 ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusOrder = [
      OrderStatus.packing,
      OrderStatus.picked,
      OrderStatus.inTransit,
      OrderStatus.delivered
    ];

    final currentIndex = statusOrder.indexOf(order.status);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Track Order', style: AppTextStyles.h2 ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // MAP PLACEHOLDER
          Container(
            height: 240,
            color: Colors.grey.shade100,
            child: Center(
              child: Icon(Icons.map_outlined, size: 64, color: Colors.grey.shade400),
            ),
          ),

          const SizedBox(height: 8),

          // Bottom card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Status', style: AppTextStyles.h2 ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        _timelineItem(
                          title: 'Packing',
                          subtitle: '2336 Jack Warren Rd, Delta Junction, Alaska',
                          done: currentIndex >= 0,
                        ),
                        const SizedBox(height: 12),
                        _timelineItem(
                          title: 'Picked',
                          subtitle: '2417 Tongass Ave #111, Ketchikan, Alaska',
                          done: currentIndex >= 1,
                        ),
                        const SizedBox(height: 12),
                        _timelineItem(
                          title: 'In Transit',
                          subtitle: '16 Rr 2, Ketchikan, Alaska 99901, USA',
                          done: currentIndex >= 2,
                        ),
                        const SizedBox(height: 12),
                        _timelineItem(
                          title: 'Delivered',
                          subtitle: order.address,
                          done: currentIndex >= 3,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.bg ?? Colors.grey.shade200,
                            child: Text(order.deliveryPersonName.isNotEmpty ? order.deliveryPersonName[0] : 'D'),
                          ),
                          title: Text(order.deliveryPersonName, style: AppTextStyles.h2 ?? const TextStyle(fontSize: 16)),
                          subtitle: Text('Delivery Guy'),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Call ${order.deliveryPersonPhone}')));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
