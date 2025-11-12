import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/responsive.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/product_card.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/widgets/filter_sheet.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  final _categories = const ['All', 'Tshirts', 'Jeans', 'Shoes'];
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    // Responsive helpers
    final double horizontalPadding = Responsive.scaleWidth(context, AppSpacing.lg);
    final double topPadding = Responsive.scaleWidth(context, AppSpacing.xl);
    final int gridCount = Responsive.responsiveGridCount(context);

    return CustomScrollView(
      slivers: [
        // Header
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Row(
                children: [
                  Text('Discover', style: AppTextStyles.h1.copyWith(fontSize: Responsive.scaleWidth(context, 28))),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications_none_rounded, size: Responsive.scaleWidth(context, 22)),
                    onPressed: () => Navigator.pushNamed(context, Routes.notifications),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune_rounded, size: Responsive.scaleWidth(context, 22)),
                    onPressed: () => _showFilters(context),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Search bar (read-only -> navigates to Search screen)
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: Responsive.scaleWidth(context, AppSpacing.md)),
              child: AppTextField(
                hint: 'Search for clothes...',
                prefix: const Icon(Icons.search),
                // some AppTextField implementations accept readOnly/onTap
                // if yours doesn't, replace with a GestureDetector wrapper.
                readOnly: true,
                onTap: () => Navigator.pushNamed(context, Routes.search),
              ),
            ),
          ),
        ),

        // Category chips
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Responsive.scaleWidth(context, AppSpacing.lg)),
              child: SizedBox(
                height: Responsive.scaleWidth(context, 40),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: Responsive.scaleWidth(context, AppSpacing.sm)),
                  itemBuilder: (_, i) {
                    final selected = _selected == i;
                    return ChoiceChip(
                      label: Text(_categories[i], style: selected ? AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: Responsive.scaleWidth(context, 14)) : AppTextStyles.body.copyWith(fontSize: Responsive.scaleWidth(context, 14))),
                      selected: selected,
                      backgroundColor: AppColors.accent,
                      selectedColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: selected ? AppColors.primary : AppColors.fieldBorder,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: Responsive.scaleWidth(context, 14), vertical: Responsive.scaleWidth(context, 8)),
                      onSelected: (_) => setState(() => _selected = i),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Products grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final title = _demoTitles[index % _demoTitles.length];
                final images = _demoImages; // 4 demo images
                final price = index.isEven ? 1190 : 1290;
                final discount = index % 3 == 0 ? 0.52 : null;

                return ProductCard(
                  imageUrl: images[index % images.length],
                  title: title,
                  price: price,
                  discount: discount,
                  onTap: () {
                    // Navigate to Product Details with arguments
                    Navigator.pushNamed(
                      context,
                      Routes.productDetails,
                      arguments: {
                        'title': title,
                        'imageUrls': images,
                        'price': price,
                        'discount': discount,
                        'rating': 4.6,
                        'reviewsCount': 128,
                        'description': 'Premium cotton tee with breathable fabric and a regular fit.',
                      },
                    );
                  },
                );
              },
              childCount: 8,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              mainAxisSpacing: Responsive.scaleWidth(context, AppSpacing.lg),
              crossAxisSpacing: Responsive.scaleWidth(context, AppSpacing.lg),
              // childAspectRatio tuned to be adaptive: taller cards on wide screens
              childAspectRatio: Responsive.isTablet(context) ? 0.85 : 0.72,
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: Responsive.scaleWidth(context, AppSpacing.xxl))),
      ],
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FilterSheet(),
    );
  }
}

final _demoTitles = [
  'Regular Fit Slogan',
  'Regular Fit Polo',
  'Regular Fit Black',
  'Regular Fit V-Neck',
];

final _demoImages = [
  'https://picsum.photos/seed/tee1/800/800',
  'https://picsum.photos/seed/tee2/800/800',
  'https://picsum.photos/seed/tee3/800/800',
  'https://picsum.photos/seed/tee4/800/800',
];
