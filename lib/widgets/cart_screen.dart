// lib/modules/home/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cart', style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.md),
          const Text('Your cart is empty.'),
        ],
      ),
    );
  }
}
