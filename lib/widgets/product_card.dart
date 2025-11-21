// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../globals/theme.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final double? discount; // 0.52 => 52%
  final VoidCallback? onTap;

  // NEW options
  final String? author;
  final double? rating; // 4.5
  final String? badge; // e.g. "Best Seller", "New", "Sale"

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.discount,
    this.onTap,
    this.author,
    this.rating,
    this.badge,
  });

  Widget _buildStars(double r, {double size = 12}) {
    final full = r.floor();
    final half = (r - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        IconData icon;
        if (i < full) icon = Icons.star;
        else if (i == full && half) icon = Icons.star_half;
        else icon = Icons.star_border;
        return Icon(icon, size: size, color: Colors.amber.shade700);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAuthor = author != null && author!.trim().isNotEmpty;
    final hasRating = rating != null && rating! > 0;
    final showBadge = badge != null && badge!.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.bg,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.bg,
                        alignment: Alignment.center,
                        child: const Icon(Icons.menu_book_rounded, size: 32),
                      ),
                    ),
                  ),
                ),

                // Badge / ribbon (top-left)
                if (showBadge)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: badge!.toLowerCase().contains('sale')
                              ? [Colors.red.shade400, Colors.red.shade700]
                              : badge!.toLowerCase().contains('new')
                                  ? [Colors.blue.shade400, Colors.blue.shade700]
                                  : [Colors.orange.shade400, Colors.orange.shade700],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Text(badge!, style: AppTextStyles.caption?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ),

                // heart overlay top-right (keeps previous look)
                Positioned(
                  top: 8,
                  right: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.favorite_border_rounded, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title
          Text(
            title,
            style: AppTextStyles.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Author
          if (hasAuthor) ...[
            const SizedBox(height: 2),
            Text(
              author!,
              style: AppTextStyles.caption?.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Rating row (small)
          if (hasRating) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                _buildStars(rating ?? 0.0, size: 12),
                const SizedBox(width: 6),
                Text((rating ?? 0.0).toStringAsFixed(1), style: AppTextStyles.caption),
              ],
            ),
          ],

          const SizedBox(height: 6),

          // Price + discount
          Row(
            children: [
              Text('₹ $price', style: AppTextStyles.body),
              if (discount != null) ...[
                const SizedBox(width: 8),
                Text(
                  '-${(discount! * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.caption?.copyWith(color: AppColors.danger),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
