import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
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
    return CustomScrollView(
      slivers: [
        // Header Row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            child: Row(
              children: [
                Text('Discover', style: AppTextStyles.h1),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.notifications),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => _showFilters(context),
                ),
              ],
            ),
          ),
        ),

        // ✅ Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: AppTextField(
              hint: 'Search for clothes...',
              prefix: const Icon(Icons.search),
              readOnly: true,
              onTap: () => Navigator.pushNamed(context, Routes.search),
            ),
          ),
        ),

        // Category Chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final selected = _selected == i;
                  return ChoiceChip(
                    label: Text(_categories[i]),
                    selected: selected,
                    backgroundColor: const Color(0xFFF6F6F6),
                    selectedColor: Colors.black,
                    labelStyle: selected
                        ? AppTextStyles.body.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600)
                        : AppTextStyles.body,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: selected ? Colors.black : AppColors.fieldBorder,
                      ),
                    ),
                    onSelected: (_) => setState(() => _selected = i),
                  );
                },
              ),
            ),
          ),
        ),

        // Products Grid
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ProductCard(
              imageUrl: _demoImages[index % _demoImages.length],
              title: _demoTitles[index % _demoTitles.length],
              price: index.isEven ? 1190 : 1290,
              discount: index % 3 == 0 ? 0.52 : null,
              onTap: () {},
            ),
            childCount: 8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.72,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
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

// final _demoImages = [
//   'https://images.unsplash.com/photo-1520975922284-9f7f0b1b0648?q=80&w=800&auto=format&fit=crop',
//   'https://images.unsplash.com/photo-1548883354-792e7c6d2b36?q=80&w=800&auto=format&fit=crop',
//   'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?q=80&w=800&auto=format&fit=crop',
//   'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?q=80&w=800&auto=format&fit=crop',
// ];

final _demoImages = [
  'https://picsum.photos/seed/tee1/800/800',
  'https://picsum.photos/seed/tee2/800/800',
  'https://picsum.photos/seed/tee3/800/800',
  'https://picsum.photos/seed/tee4/800/800',
];
