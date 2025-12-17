import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/services/order_manager.dart';
import 'package:ecommerce_mobile/models/order_model.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';

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
    // Defensive reads - ensure doubles
    final double subtotal = (cart.subtotal is num) ? (cart.subtotal as num).toDouble() : 0.0;
    final double vat = (cart.vatAmount is num) ? (cart.vatAmount as num).toDouble() : 0.0;
    final double shipping = (cart.shippingFee is num) ? (cart.shippingFee as num).toDouble() : 0.0;
    final double total = (cart.totalPrice is num) ? (cart.totalPrice as num).toDouble() : 0.0;

    // couponDiscount may or may not be present; fallback to 0
    double discount = 0.0;
    try {
      final cd = (cart.couponDiscount);
      if (cd is num) discount = (cd as num).toDouble();
    } catch (_) {}

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

    // Wait a frame to ensure UI updated then scroll
    await Future.delayed(const Duration(milliseconds: 60));
    final ctx = _priceDetailsKey.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    } else if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  OrderModel _buildOrderFromCart(String orderId) {
    final cartItems = CartManager.instance.items;
    final orderItems = cartItems.map((e) {
      final id = e.id.toString();
      final title = e.title ?? 'Product';
      final size = e.size ?? '';
      final price = (e.price is num) ? (e.price as num).toDouble() : 0.0;
      final imageUrl = e.imageUrl ?? '';
      return OrderItem(id: id, title: title, size: size, price: price, imageUrl: imageUrl);
    }).toList();

    // Use the compact OrderModel constructor used in your codebase.
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
      // Simulate payment processing (replace with real integration later)
      await Future.delayed(const Duration(milliseconds: 700));

      final newOrderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final orderModel = _buildOrderFromCart(newOrderId);

      try {
        OrderManager.instance.addOrder(orderModel);
      } catch (e) {
        debugPrint('PaymentsScreen: failed to add order to OrderManager: $e');
      }

      // TODO: If/when you add CartManager.clear() call it here:
      // CartManager.instance.clear();

      if (!mounted) return;

      // --- SAFE DIALOG PATTERN: dialog returns a result, then we navigate AFTER it is dismissed ---
      final String? dialogResult = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          // Use dialogContext exclusively inside here
          return AlertDialog(
            title: const Text('Order placed'),
            content: const Text('Your order has been placed successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  // pop with result 'track'
                  Navigator.of(dialogContext).pop('track');
                },
                child: const Text('Track Order'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop('orders');
                },
                child: const Text('My Orders'),
              ),
            ],
          );
        },
      );

      // showDialog completed and dialog route has been removed from navigator.
      // Now navigate based on dialogResult using the screen context (safe).
      if (!mounted) return;
      if (dialogResult == 'track') {
        // Navigate to orders screen and open track for the created order
        Navigator.of(context).pushNamed(Routes.orders, arguments: {'openTrack': true, 'orderId': newOrderId});
      } else if (dialogResult == 'orders') {
        Navigator.of(context).pushNamed(Routes.orders);
      }
    } catch (e, st) {
      debugPrint('PaymentsScreen: payment error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  Widget _paymentMethodTile({required String id, required String title, String? subtitle, IconData? icon}) {
    final selected = _selectedPayment == id;
    return InkWell(
      onTap: () => setState(() => _selectedPayment = id),
      borderRadius: BorderRadius.circular(8),
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                if (subtitle != null) const SizedBox(height: 6),
                if (subtitle != null) Text(subtitle, style: AppTextStyles.caption),
              ]),
            ),
            const SizedBox(width: 8),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.primary : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _priceDetailsCard() {
    final pb = _priceBreakdown();

    // Gilroy styles for price details
    final TextStyle gilroyHeader = AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700, fontFamily: 'Gilroy');
    final TextStyle gilroyLabel = AppTextStyles.body.copyWith(fontFamily: 'Gilroy');
    final TextStyle gilroyValue = AppTextStyles.body.copyWith(fontFamily: 'Gilroy');

    return Container(
      key: _priceDetailsKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Use Gilroy for the header
        Text('Price Details', style: gilroyHeader),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Price (${CartManager.instance.items.length} items)', style: gilroyLabel),
          Text('₹${pb['subtotal']!.toStringAsFixed(2)}', style: gilroyValue.copyWith(fontWeight: FontWeight.w700))
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Discount on MRP', style: gilroyLabel.copyWith(fontSize: gilroyLabel.fontSize ?? 14)),
          Text('- ₹${pb['discount']!.toStringAsFixed(2)}', style: gilroyValue.copyWith(color: AppColors.success))
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Platform Fee', style: gilroyLabel),
          Text('₹0.00', style: gilroyValue)
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Shipping', style: gilroyLabel),
          Text('₹${pb['shipping']!.toStringAsFixed(2)}', style: gilroyValue)
        ]),
        const SizedBox(height: 12),
        const Divider(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total Amount', style: gilroyLabel.copyWith(fontWeight: FontWeight.w800)),
          Text('₹${pb['total']!.toStringAsFixed(2)}', style: gilroyValue.copyWith(fontWeight: FontWeight.w900, fontSize: 18))
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text('You save ₹${pb['discount']!.toStringAsFixed(0)} on this order', style: AppTextStyles.body.copyWith(color: AppColors.success))),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pb = _priceBreakdown();
    final total = pb['total']!;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Payments'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 6),

            // Payment methods header
            Text('Payment Method', style: AppTextStyles.h2.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            // Methods list (UPI / Card / COD)
            Column(children: [
              _paymentMethodTile(id: 'UPI', title: 'UPI', subtitle: 'Pay via any UPI app', icon: Icons.account_balance_wallet),
              const SizedBox(height: 10),
              _paymentMethodTile(id: 'CARD', title: 'Credit / Debit Card', subtitle: 'Add card to pay securely', icon: Icons.credit_card),
              const SizedBox(height: 10),
              _paymentMethodTile(id: 'COD', title: 'Cash on Delivery', subtitle: 'Pay with cash on delivery', icon: Icons.money),
            ]),

            const SizedBox(height: 18),

            // Price details toggle row (scrolls to and reveals card)
            GestureDetector(
              onTap: _scrollToPriceDetails,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Use Gilroy for the bold total in the toggle row as well
                Text('₹${total.toStringAsFixed(0)}', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w900, fontFamily: 'Gilroy')),
                Row(children: [
                  Text('View price details', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                  const SizedBox(width: 6),
                  Icon(_priceDetailsVisible ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
                ]),
              ]),
            ),

            const SizedBox(height: 12),

            if (_priceDetailsVisible) _priceDetailsCard(),

            const SizedBox(height: 140), // space so content not hidden by bottom bar
          ]),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          decoration: BoxDecoration(color: AppColors.bg, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
          child: Row(children: [
            Expanded(
              child: InkWell(
                onTap: _scrollToPriceDetails,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  // bottom-left uses Gilroy
                  Text('₹${total.toStringAsFixed(0)}', style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w900, fontFamily: 'Gilroy')),
                  const SizedBox(height: 4),
                  Text('View price details', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ]),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 150,
              height: 48,
              child: ElevatedButton(
                onPressed: _isPlacing ? null : _onPayPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF326638), // green
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isPlacing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('PAY', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
