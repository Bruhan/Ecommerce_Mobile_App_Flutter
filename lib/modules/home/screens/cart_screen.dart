import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';

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
          final total = CartManager.instance.totalPrice;

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
                        onDelete: () => _showRemoveOrSaveDialog(context, item),
                        onIncrement: () {
                          CartManager.instance.updateQuantity(item.id, item.size, item.quantity + 1);
                        },
                        onDecrement: () {
                          final newQty = item.quantity - 1;
                          if (newQty <= 0) {
                            _showRemoveOrSaveDialog(context, item);
                          } else {
                            CartManager.instance.updateQuantity(item.id, item.size, newQty);
                          }
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

  Future<void> _showRemoveOrSaveDialog(BuildContext context, CartItem item) async {
    final bool? action = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // header row: thumbnail + title
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.bg),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.h3),
                          const SizedBox(height: 6),
                          Text('Size ${item.size} • ₹${item.price}', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // message
                Text(
                  'Do you want to remove this item permanently or move it to Saved items? You can restore from Saved later.',
                  style: AppTextStyles.body?.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 18),

                // actions: Remove permanently (left) | Move to Saved items (right)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // return false indicates Remove permanently
                          Navigator.of(ctx).pop(false);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                        ),
                        child: Text('Remove permanently', style: AppTextStyles.body?.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // return true indicates Move to saved
                          Navigator.of(ctx).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                        ),
                        child: Text('Move to Saved items', style: AppTextStyles.body?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // action == true => Move to Saved items, action == false => Remove permanently, null => dismissed
    if (action == null) return;

    if (action == true) {
      // Move to Saved items
      final removed = CartManager.instance.moveToSaved(item.id, size: item.size);
      if (removed != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved "${removed.title}" to saved items'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                CartManager.instance.addItem(removed);
              },
            ),
          ),
        );

        // Auto-navigate to Saved screen if route exists
        try {
          Navigator.pushNamed(context, Routes.saved);
        } catch (_) {
          // silent fallback if saved route not defined
        }
      }
    } else {
      // Remove permanently (keep a copy for undo)
      final copy = CartItem(
        id: item.id,
        title: item.title,
        imageUrl: item.imageUrl,
        price: item.price,
        size: item.size,
        quantity: item.quantity,
      );
      CartManager.instance.removePermanently(item.id, size: item.size);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "${copy.title}" permanently'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              CartManager.instance.addItem(copy);
            },
          ),
        ),
      );
    }
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
              // IconButton opens the two-action dialog
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                tooltip: 'Remove or move to saved',
              ),
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
