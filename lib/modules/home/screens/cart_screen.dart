import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Your Cart", style: AppTextStyles.h1),
    );
  }
}
