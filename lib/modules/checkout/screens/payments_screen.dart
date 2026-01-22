import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/services/order_manager.dart';
import 'package:ecommerce_mobile/models/order_model.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';

import '../../../globals/text_styles.dart';
import '../../../widgets/checkout_success_dialog.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _priceDetailsKey = GlobalKey();
  bool _priceDetailsVisible = false;
  String _selectedPayment = 'UPI';
  bool _isPlacing = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, double> _priceBreakdown() {
    final cart = CartManager.instance;

    final double subtotal = cart.subtotal;
    final double vat = cart.vatAmount;
    final double shipping = cart.shippingFee;
    final double discount = cart.couponDiscount;
    final double total = cart.totalPrice;

    return {
      'subtotal': subtotal,
      'vat': vat,
      'shipping': shipping,
      'discount': discount,
      'total': total,
    };
  }

  Future<void> _scrollToPriceDetails() async {
    setState(() => _priceDetailsVisible = true);

    await Future.delayed(const Duration(milliseconds: 60));
    final ctx = _priceDetailsKey.currentContext;

    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  OrderModel _buildOrderFromCart(String orderId) {
    final cartItems = CartManager.instance.items;

    final orderItems = cartItems.map((e) {
      return OrderItem(
        id: e.id.toString(),
        title: e.title ?? 'Product',
        size: e.size ?? '',
        price: e.price.toDouble(),
        imageUrl: e.imageUrl ?? '',
      );
    }).toList();

    return OrderModel(
      id: orderId,
      items: orderItems,
      status: OrderStatus.packing,
      orderDate: DateTime.now(),
      address: '',
      deliveryPersonName: '',
      deliveryPersonPhone: '',
    );
  }

  Future<void> _onPayPressed() async {
    if (_isPlacing) return;
    setState(() => _isPlacing = true);

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final newOrderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final orderModel = _buildOrderFromCart(newOrderId);

      OrderManager.instance.addOrder(orderModel);

      if (!mounted) return;

      /// ✅ ONLY CHANGE: Custom Checkout Success Dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return CheckoutSuccessDialog(
            title: 'Congratulations!',
            message: 'Your order has been placed successfully.',
            actionText: 'Track Your Order',
            onTrack: () {
              Navigator.of(dialogContext).pop();

              Navigator.of(context, rootNavigator: true).pushNamed(
                Routes.orders,
                arguments: {
                  'openTrack': true,
                  'orderId': newOrderId,
                },
              );
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  Widget _paymentMethodTile({
    required String id,
    required String title,
    String? subtitle,
    IconData? icon,
  }) {
    final selected = _selectedPayment == id;

    return InkWell(
      onTap: () => setState(() => _selectedPayment = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 22),
            if (icon != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700)),
                  if (subtitle != null) const SizedBox(height: 6),
                  if (subtitle != null)
                    Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceDetailsCard() {
    final pb = _priceBreakdown();

    return Container(
      key: _priceDetailsKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Details', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          _row('Subtotal', pb['subtotal']!),
          _row('Discount', -pb['discount']!),
          _row('Shipping', pb['shipping']!),
          const Divider(height: 24),
          _row('Total Amount', pb['total']!, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: bold
                  ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)
                  : AppTextStyles.body),
          Text('₹${value.toStringAsFixed(0)}',
              style: bold ? AppTextStyles.h2 : AppTextStyles.body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _priceBreakdown()['total']!;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            _paymentMethodTile(
              id: 'UPI',
              title: 'UPI',
              subtitle: 'Pay via any UPI app',
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 10),
            _paymentMethodTile(
              id: 'CARD',
              title: 'Credit / Debit Card',
              subtitle: 'Add card to pay securely',
              icon: Icons.credit_card,
            ),
            const SizedBox(height: 10),
            _paymentMethodTile(
              id: 'COD',
              title: 'Cash on Delivery',
              subtitle: 'Pay with cash on delivery',
              icon: Icons.money,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _scrollToPriceDetails,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹${total.toStringAsFixed(0)}', style: AppTextStyles.h2),
                  Text('View price details', style: AppTextStyles.caption),
                ],
              ),
            ),
            if (_priceDetailsVisible) ...[
              const SizedBox(height: 12),
              _priceDetailsCard(),
            ],
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ElevatedButton(
            onPressed: _isPlacing ? null : _onPayPressed,
            child: _isPlacing
                ? const CircularProgressIndicator()
                : const Text('PAY'),
          ),
        ),
      ),
    );
  }
}
