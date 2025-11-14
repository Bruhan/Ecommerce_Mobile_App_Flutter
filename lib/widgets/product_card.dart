import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/responsive.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double? discount;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.discount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardRadius = Responsive.scaleWidth(context, AppRadii.md);
    final double imageHeight = Responsive.isTablet(context)
        ? Responsive.scaleWidth(context, 240)
        : Responsive.scaleWidth(context, 180);

    final double titleFont = Responsive.scaleWidth(context, 14);
    final double priceFont = Responsive.scaleWidth(context, 13);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(cardRadius),
            child: Image.network(
              imageUrl,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontSize: titleFont,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Responsive.scaleWidth(context, 4)),
          Text(
            '₹${price.toInt()}',
            style: AppTextStyles.caption.copyWith(
              fontSize: priceFont,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
