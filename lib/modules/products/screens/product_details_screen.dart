// lib/modules/products/screens/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/responsive.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProductDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewsKey = GlobalKey();

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Wade Warren',
      'rating': 5,
      'text': 'The item is very good, my son likes it very much and plays every day.',
      'time': '6 days ago'
    },
    {
      'name': 'Guy Hawkins',
      'rating': 4,
      'text': 'The seller is very fast in sending packet, I just bought it and the item arrived in just 1 day!',
      'time': '1 week ago'
    },
    {
      'name': 'Robert Fox',
      'rating': 4,
      'text': 'I just bought it and the stuff is really good! I highly recommend it!',
      'time': '2 weeks ago'
    },
  ];

  Future<void> _scrollToReviews() async {
    final ctx = _reviewsKey.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    } else if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      await _scrollController.animateTo(max, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildStars(double rating, {double iconSize = 16}) {
    final int full = rating.floor();
    return Row(
      children: List.generate(5, (i) {
        final color = i < full ? Colors.amber : Colors.grey.withOpacity(0.4);
        return Icon(Icons.star, color: color, size: iconSize);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final title = data['title'] ?? 'Product';
    final images = List<String>.from(data['imageUrls'] ?? data['images'] ?? ['https://picsum.photos/seed/tee/800/800']);
    final price = (data['price'] ?? 1190).toDouble();
    final description = data['description'] ?? 'No description provided.';
    final rating = (data['rating'] ?? 4.0).toDouble();
    final reviewsCount = (data['reviewsCount'] ?? 45).toInt();

    final double pagePadding = Responsive.scaleWidth(context, AppSpacing.lg);
    final bool isWide = Responsive.isTablet(context);

    // defensive fallback colors (in case theme is missing a specific field)
    final Color mutedColor = AppColors.muted;
    final Color accentColor = AppColors.accent;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
            icon: Icon(Icons.notifications_outlined, size: Responsive.scaleWidth(context, 22)),
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (isWide && constraints.maxWidth >= 800) {
            return Padding(
              padding: EdgeInsets.all(pagePadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          child: Image.network(images.first, height: constraints.maxHeight * 0.75, width: double.infinity, fit: BoxFit.cover),
                        ),
                        SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                        SizedBox(
                          height: Responsive.scaleWidth(context, 80),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) => SizedBox(width: Responsive.scaleWidth(context, AppSpacing.sm)),
                            itemBuilder: (ctx, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(images[i], width: 80, height: 80, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.scaleWidth(context, 28)),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(left: Responsive.scaleWidth(context, AppSpacing.md)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                            Text(title, style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 22))),
                            SizedBox(height: Responsive.scaleWidth(context, 8)),

                            GestureDetector(
                              onTap: _scrollToReviews,
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: Responsive.scaleWidth(context, 18)),
                                  SizedBox(width: Responsive.scaleWidth(context, 6)),
                                  Text('${rating.toStringAsFixed(1)}/5', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  SizedBox(width: Responsive.scaleWidth(context, 8)),
                                  Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                                  const Spacer(),
                                  Text('See reviews', style: AppTextStyles.body.copyWith(color: mutedColor)),
                                  SizedBox(width: Responsive.scaleWidth(context, 6)),
                                  Icon(Icons.arrow_forward_ios, size: Responsive.scaleWidth(context, 14), color: mutedColor),
                                ],
                              ),
                            ),

                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                            Text(description, style: AppTextStyles.body.copyWith(fontSize: Responsive.scaleWidth(context, 15))),
                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),

                            Text('Choose size', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                            Wrap(
                              spacing: Responsive.scaleWidth(context, AppSpacing.sm),
                              children: ['S', 'M', 'L', 'XL']
                                  .map((s) => Container(
                                        padding: EdgeInsets.symmetric(horizontal: Responsive.scaleWidth(context, 16), vertical: Responsive.scaleWidth(context, 12)),
                                        decoration: BoxDecoration(border: Border.all(color: mutedColor), borderRadius: BorderRadius.circular(8)),
                                        child: Text(s),
                                      ))
                                  .toList(),
                            ),

                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.lg)),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Price', style: AppTextStyles.caption),
                                    Text('\$${price.toInt()}', style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 22))),
                                  ]),
                                ),
                                SizedBox(width: Responsive.scaleWidth(context, 12)),
                                SizedBox(width: Responsive.scaleWidth(context, 220), child: AppButton(label: 'Add to Cart', onPressed: () {})),
                              ],
                            ),

                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.xl)),
                            const Divider(),
                            SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),

                            Container(
                              key: _reviewsKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 20))),
                                      const Spacer(),
                                      TextButton(onPressed: () {}, child: const Text('Write a review'))
                                    ],
                                  ),
                                  SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: Responsive.scaleWidth(context, 26))),
                                      SizedBox(width: Responsive.scaleWidth(context, AppSpacing.md)),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        _buildStars(rating, iconSize: Responsive.scaleWidth(context, 18)),
                                        SizedBox(height: Responsive.scaleWidth(context, 6)),
                                        Text('$reviewsCount Ratings', style: AppTextStyles.caption),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                                  _buildRatingBars(accentColor, mutedColor),
                                  SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),

                                  ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _reviews.length,
                                    separatorBuilder: (_, __) => const Divider(),
                                    itemBuilder: (context, i) => _buildReviewTile(_reviews[i]),
                                  ),

                                  SizedBox(height: Responsive.scaleWidth(context, AppSpacing.xl)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // mobile layout
          return SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                ClipRRect(borderRadius: BorderRadius.circular(AppRadii.lg), child: Image.network(images.first, height: Responsive.scaleWidth(context, 260), width: double.infinity, fit: BoxFit.cover)),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                Text(title, style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 20))),
                SizedBox(height: Responsive.scaleWidth(context, 6)),
                GestureDetector(
                  onTap: _scrollToReviews,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: Responsive.scaleWidth(context, 18)),
                      SizedBox(width: Responsive.scaleWidth(context, 6)),
                      Text('${rating.toStringAsFixed(1)}/5', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(width: Responsive.scaleWidth(context, 8)),
                      Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                      const Spacer(),
                      Text('See reviews', style: AppTextStyles.body.copyWith(color: mutedColor)),
                      SizedBox(width: Responsive.scaleWidth(context, 6)),
                      Icon(Icons.arrow_forward_ios, size: Responsive.scaleWidth(context, 14), color: mutedColor),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                Text(description, style: AppTextStyles.body.copyWith(fontSize: Responsive.scaleWidth(context, 15))),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                Text('Choose size', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                Row(
                  children: ['S', 'M', 'L', 'XL'].map((s) {
                    return Padding(
                      padding: EdgeInsets.only(right: Responsive.scaleWidth(context, AppSpacing.sm)),
                      child: Container(padding: EdgeInsets.symmetric(horizontal: Responsive.scaleWidth(context, 16), vertical: Responsive.scaleWidth(context, 12)), decoration: BoxDecoration(border: Border.all(color: mutedColor), borderRadius: BorderRadius.circular(8)), child: Text(s)),
                    );
                  }).toList(),
                ),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.lg)),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Price', style: AppTextStyles.caption), Text('\$${price.toInt()}', style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 22)))])),
                    SizedBox(width: Responsive.scaleWidth(context, 12)),
                    SizedBox(width: Responsive.scaleWidth(context, 180), child: AppButton(label: 'Add to Cart', onPressed: () {})),
                  ],
                ),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.xl)),
                const Divider(),
                SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                Container(
                  key: _reviewsKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: Responsive.scaleWidth(context, 20))), const Spacer(), TextButton(onPressed: () {}, child: const Text('Write a review'))]),
                      SizedBox(height: Responsive.scaleWidth(context, AppSpacing.sm)),
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: Responsive.scaleWidth(context, 26))), SizedBox(width: Responsive.scaleWidth(context, AppSpacing.md)), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildStars(rating, iconSize: Responsive.scaleWidth(context, 18)), SizedBox(height: Responsive.scaleWidth(context, 6)), Text('$reviewsCount Ratings', style: AppTextStyles.caption)])]),
                      SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                      _buildRatingBars(accentColor, mutedColor),
                      SizedBox(height: Responsive.scaleWidth(context, AppSpacing.md)),
                      ListView.separated(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: _reviews.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, i) => _buildReviewTile(_reviews[i])),
                      SizedBox(height: Responsive.scaleWidth(context, AppSpacing.xl)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRatingBars([Color? accent, Color? muted]) {
    final counts = [60, 25, 8, 5, 2];
    final total = counts.fold<int>(0, (a, b) => a + b);
    final accentColor = accent ?? AppColors.accent;
    final fillColor = muted ?? AppColors.muted;

    return Column(
      children: List.generate(5, (idx) {
        final star = 5 - idx;
        final count = counts[idx];
        final ratio = total == 0 ? 0.0 : (count / total);
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Responsive.scaleWidth(context, 6.0)),
          child: Row(
            children: [
              Text('$star', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(width: Responsive.scaleWidth(context, AppSpacing.sm)),
              Expanded(
                child: Stack(
                  children: [
                    Container(height: 10, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(8))),
                    FractionallySizedBox(widthFactor: ratio, child: Container(height: 10, decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(8)))),
                  ],
                ),
              ),
              SizedBox(width: Responsive.scaleWidth(context, AppSpacing.sm)),
              Text('${count}', style: AppTextStyles.caption),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewTile(Map<String, dynamic> r) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Row(children: List.generate(5, (i) => Icon(Icons.star, color: i < (r['rating'] ?? 0) ? Colors.amber : Colors.grey.withOpacity(0.4), size: Responsive.scaleWidth(context, 16)))),
          SizedBox(width: Responsive.scaleWidth(context, AppSpacing.sm)),
          Text('${r['name']}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: Responsive.scaleWidth(context, 8)),
        Text('${r['text']}', style: AppTextStyles.body),
        SizedBox(height: Responsive.scaleWidth(context, 8)),
        Text('${r['time']}', style: AppTextStyles.caption),
      ]),
    );
  }
}
