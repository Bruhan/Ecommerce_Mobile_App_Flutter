import 'package:flutter/material.dart';
import '../globals/theme.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price; // cents-like unit (1190 => 1,190 shown)
  final double? discount; // 0.52 => -52%
  final VoidCallback? onTap;
  final bool liked;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.discount,
    this.onTap,
    this.liked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1, // square
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // Avoid red X on web:
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return _ImageSkeleton();
                    },
                    errorBuilder: (ctx, error, stack) {
                      return _ImageError();
                    },
                  ),
                ),
                // Heart badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.08),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          // Price row
          Row(
            children: [
              Text('\$ ${_format(price)}', style: AppTextStyles.body),
              const SizedBox(width: 8),
              if (discount != null)
                Text(
                  '-${(discount! * 100).round()}%',
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.danger),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _format(int n) {
    // 1190 => 1,190
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class _ImageSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: const Icon(Icons.image, size: 28, color: Colors.black26),
    );
  }
}

class _ImageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F8),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.broken_image_outlined, size: 28, color: Colors.black26),
          SizedBox(height: 6),
          Text('Image unavailable', style: TextStyle(color: Colors.black38)),
        ],
      ),
    );
  }
}
