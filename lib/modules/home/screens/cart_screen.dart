import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: CartManager.instance,
        builder: (context, _) {
          final items = CartManager.instance.items;
          final subtotal = CartManager.instance.subtotal;
          final shipping = CartManager.instance.shippingFee;
          final vatAmount = CartManager.instance.vatAmount;
          final total = CartManager.instance.total;

          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) {
                      final CartItem item = items[i];
                      return _CartTile(
                        item: item,
                        onDelete: () {
                          CartManager.instance.removeItem(item.id, size: item.size);
                        },
                        onIncrement: () {
                          CartManager.instance.updateQuantity(item.id, item.size, item.quantity + 1);
                        },
                        onDecrement: () {
                          CartManager.instance.updateQuantity(item.id, item.size, item.quantity - 1);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // summary
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _summaryRow('Sub-total', '\₹${subtotal.toString()}'),
                      const SizedBox(height: AppSpacing.sm),
                      _summaryRow('VAT (%)', '\₹${vatAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: AppSpacing.sm),
                      _summaryRow('Shipping fee', '\₹${shipping.toString()}'),
                      const Divider(height: AppSpacing.lg * 1.2),
                      _summaryRow('Total', '\₹${total.toStringAsFixed(0)}', isTotal: true),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // checkout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      
                      Navigator.pushNamed(context, Routes.checkout); // if exists
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Go To Checkout', style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: AppColors.primary,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w700) : AppTextStyles.caption),
        Text(value, style: isTotal ? AppTextStyles.h2.copyWith(fontSize: 18) : AppTextStyles.body),
      ],
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartTile({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(item.imageUrl, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: AppSpacing.md),

          // title + size + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Size ${item.size}', style: AppTextStyles.caption),
                const SizedBox(height: 8),
                Text('\₹${item.price}', style: AppTextStyles.body),
              ],
            ),
          ),

          // qty controls
          Column(
            children: [
              InkWell(onTap: onDelete, child: Icon(Icons.delete_outline, color: Colors.red.shade400)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _QtyButton(icon: Icons.remove, onTap: onDecrement),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.fieldBorder)),
                    child: Text('${item.quantity}'),
                  ),
                  _QtyButton(icon: Icons.add, onTap: onIncrement),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({Key? key, required this.icon, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.fieldBorder)),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
