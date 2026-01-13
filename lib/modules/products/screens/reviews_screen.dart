import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

import '../../../globals/text_styles.dart';

class ReviewsScreen extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const ReviewsScreen({
    super.key,
    this.rating = 4.0,
    this.reviewsCount = 45,
  });

  @override
  Widget build(BuildContext context) {
    final breakdown = [24, 15, 4, 2, 0]; 
    final reviewList = [
      {
        'name': "Wade Warren",
        'date': '6 days ago',
        'rating': 5,
        'review':
            "The item is very good, my son likes it very much and plays every day.",
      },
      {
        'name': "Guy Hawkins",
        'date': '1 week ago',
        'rating': 4,
        'review': "The seller is very fast in sending packet, I just bought it and the item arrived in just 1 day!",
      },
      {
        'name': "Robert Fox",
        'date': '2 weeks ago',
        'rating': 4,
        'review': "I just bought it and the stuff is really good! I highly recommend it!",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Reviews"),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Big Rating
                  Column(
                    children: [
                      Text(
                        rating.toStringAsFixed(1),
                        style: AppTextStyles.h1.copyWith(color: Colors.black, fontSize: 46),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$reviewsCount Ratings",
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  // Star breakdown
                  Expanded(
                    child: Column(
                      children: List.generate(5, (i) {
                        final star = 5 - i;
                        final barWidth = (breakdown[i] / (breakdown.reduce((a, b) => a > b ? a : b))).clamp(0.1, 1.0);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text('$star', style: AppTextStyles.caption),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECECEC),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: barWidth,
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.amber[700],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                breakdown[i].toString(),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "${reviewList.length} Reviews",
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              // Reviews List
...reviewList.map((review) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: List.generate(5, (i) {
          // SAFELY convert rating to int or 0
          final rating = (review['rating'] as num?)?.toInt() ?? 0;
          return Icon(
            Icons.star,
            size: 18,
            color: i < rating ? Colors.amber : Colors.grey[300],
          );
        }),
      ),
      const SizedBox(height: 4),
      Text(
        review['review'] as String? ?? '',
        style: AppTextStyles.body,
      ),
      const SizedBox(height: 8),
      Text(
        "${review['name']} • ${review['date']}",
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    ],
  ),
))

            ],
          ),
        ),
      ),
    );
  }
}
