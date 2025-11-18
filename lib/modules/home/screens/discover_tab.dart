import 'package:ecommerce_mobile/modules/home/constants/product-api.constant.dart';
import 'package:ecommerce_mobile/modules/home/types/book_product_response.dart';
import 'package:ecommerce_mobile/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/product_card.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/widgets/filter_sheet.dart';

import '../../general/types/api.types.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  final _categories = const ['All', 'Tshirts', 'Jeans', 'Shoes'];
  int _selected = 1;

  List<dynamic>? productsData;
  int totalProducts = 0;
  bool productsDataLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchProductsData();
  }

  Future<void> fetchProductsData() async {
    try {
      productsDataLoading = true;
      final res = await _apiService.get(ProductApiConstant
          .bookProductsWithFilter
          .replaceFirst(":mode", "CRITERIA")
          .replaceFirst(":page", "1")
          .replaceFirst(":productsCount", "10"));
      WebResponse<BookProductResponse> response = WebResponse.fromJson(
        res,
        (data) {
          return BookProductResponse.fromJson(data);
        },
      );

      if (response.statusCode == 200) {
        productsData = response.results.products?.map((item) {
          return {
            'imageUrl': item.imagePath ?? "",
            'title': item.product?.itemDesc ?? "No Name",
            'price': item.product?.ecomUnitPrice ?? 0,
            'mrp': item.product?.mrp ?? item.product?.ecomUnitPrice ?? 0,
            'description': item.product?.ecomDescription ?? "",
          };
        }).toList();
        totalProducts = response.results.totalProducts!;

        setState(() {
          productsDataLoading = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.xl, left: AppSpacing.lg, right: AppSpacing.lg),
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

        // Search bar (read-only -> navigates to Search screen)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.md, left: AppSpacing.lg, right: AppSpacing.lg),
            child: AppTextField(
              hint: 'Search for products...',
              prefix: const Icon(Icons.search),
              readOnly: true,
              onTap: () => Navigator.pushNamed(context, Routes.search),
            ),
          ),
        ),

        // Category chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
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
                    checkmarkColor: Colors.white,
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

        // Products grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: productsDataLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = productsData![index];
                      print(item);
                      final imageUrl = item['imageUrl'] ?? "";
                      final title = item['title'] ?? "No Name";
                      final price = item['price'] ?? 0;
                      final mrp = item['mrp'] ?? price;
                      final description = item['description'] ?? "";
                      // Calculate discount percentage if applicable
                      final discount = mrp > price ? (1 - price / mrp).toDouble() : null;

                      return ProductCard(
                        imageUrl: imageUrl,
                        title: title,
                        price: price,
                        discount: discount,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.productDetails,
                            arguments: {
                              'title': title,
                              'imageUrls': [imageUrl],
                              'price': price,
                              'discount': discount,
                              'rating': 4.6,
                              'reviewsCount': 128,
                              'description': description ?? "",
                            },
                          );
                        },
                      );
                    },
                    childCount: productsData?.length ?? 0,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.lg,
                    crossAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 0.72,
                  ),
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

final _demoImages = [
  'https://picsum.photos/seed/tee1/800/800',
  'https://picsum.photos/seed/tee2/800/800',
  'https://picsum.photos/seed/tee3/800/800',
  'https://picsum.photos/seed/tee4/800/800',
];
