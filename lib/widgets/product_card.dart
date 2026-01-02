import 'package:flutter/material.dart';
import '../globals/theme.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final double? discount;
  final VoidCallback? onTap;
  final String? author;
  final double? rating;
  final String? badge;
  final bool isSaved;
  final ValueChanged<bool>? onSavedChanged;

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
    this.isSaved = false,
    this.onSavedChanged,
  });

  Widget _buildStars(double r) {
    final int full = r.floor();
    final bool hasHalf = (r - full) >= 0.5;
    final int empty = 5 - full - (hasHalf ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(full, (_) => const Icon(Icons.star, size: 13, color: Colors.amber)),
        if (hasHalf) const Icon(Icons.star_half, size: 13, color: Colors.amber),
        ...List.generate(empty, (_) => const Icon(Icons.star_border, size: 13, color: Colors.amber)),
      ],
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.bg,
                        alignment: Alignment.center,
                        child: Icon(Icons.menu_book_rounded, size: 36, color: AppColors.textSecondary),
                      ),
                    ),
                  ),

                  if (showBadge)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge!,
                          style: AppTextStyles.caption?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => onSavedChanged?.call(!isSaved),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          size: 17,
                          color: isSaved ? Colors.red.shade600 : AppColors.textPrimary.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.3,
              ),
            ),

            if (hasAuthor) ...[
              const SizedBox(height: 4),
              Text(
                author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],

            if (hasRating) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildStars(rating!),
                  const SizedBox(width: 6),
                  Text(
                    rating!.toStringAsFixed(1),
                    style: AppTextStyles.caption?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),

            // FIXED: Price Row - No more overflow
            Row(
              children: [
                // Price takes available space
                Expanded(
                  child: Text(
                    '₹$price',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Discount badge - only if valid
                if (discount != null && discount! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade600, width: 1),
                    ),
                    child: Text(
                      '-${(discount! * 100).round()}%',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}