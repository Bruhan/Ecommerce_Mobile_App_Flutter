// lib/modules/home/screens/discover_tab.dart
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
  // Bookstore categories
  final _categories = const [
    'All',
    'Computer Science',
    'Electrical',
    'Engineering',
    'Fiction',
    'Non-Fiction',
    'Academic',
    'Reference'
  ];

  // default to "All"
  int _selected = 0;

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
      setState(() {
        productsDataLoading = true;
      });

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
          // Map the server response to a simple map used by UI.
          // If your API contains author/publisher/category fields, add them here.
          return {
            'item': item.product?.item ?? "",
            'imageUrl': item.imagePath ?? "",
            'title': item.product?.itemDesc ?? "No Name",
            'price': (item.product?.ecomUnitPrice ?? 0).toInt(),
            'mrp': (item.product?.mrp ?? item.product?.ecomUnitPrice ?? 0).toInt(),
            'description': item.product?.ecomDescription ?? "",
            // optional: category/author/publisher if available in API (keeps safe if absent)
            'category': (item.product?.category ?? '').toString(),
            'author': (item.product?.author ?? '').toString(),
            'publisher': '', // product model doesn't expose publisher — keep empty fallback
          };
        }).toList();
        totalProducts = response.results.totalProducts ?? 0;
      } else {
        productsData = <dynamic>[];
        totalProducts = 0;
      }
    } catch (e, st) {
      debugPrint('fetchProductsData error: $e\n$st');
      productsData = <dynamic>[];
      totalProducts = 0;
    } finally {
      if (mounted) {
        setState(() {
          productsDataLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Apply client-side filter if category exists on items
    final visibleProducts = (productsData ?? []).where((p) {
      if (_selected == 0) return true;
      final itemCat = (p['category'] ?? '').toString().toLowerCase();
      return itemCat.isNotEmpty && itemCat == _categories[_selected].toLowerCase();
    }).toList();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl, left: AppSpacing.lg, right: AppSpacing.lg),
            child: Row(
              children: [
                Text('Discover', style: AppTextStyles.h1),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () => Navigator.pushNamed(context, Routes.notifications),
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
            padding: const EdgeInsets.only(top: AppSpacing.md, left: AppSpacing.lg, right: AppSpacing.lg),
            child: AppTextField(
              hint: 'Search for books...',
              prefix: const Icon(Icons.search),
              readOnly: true,
              onTap: () => Navigator.pushNamed(context, Routes.search),
            ),
          ),
        ),

        // Category chips (bookstore)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final selected = _selected == i;
                  return ChoiceChip(
                    label: Text(_categories[i]),
                    selected: selected,
                    backgroundColor: const Color(0xFFF6F6F6),
                    checkmarkColor: Colors.white,
                    selectedColor: Colors.black,
                    labelStyle: selected
                        ? AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600)
                        : AppTextStyles.body,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: selected ? Colors.black : AppColors.fieldBorder),
                    ),
                    onSelected: (v) {
                      setState(() {
                        _selected = i;
                      });
                      // Optionally: call backend with category filter if your API supports it.
                      // For now we do client-side filtering (works if API returns 'category' field)
                    },
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
                      final item = visibleProducts[index];
                      final id = item['item'] ?? "";
                      final imageUrl = item['imageUrl'] ?? "";
                      final title = item['title'] ?? "No Name";
                      final price = (item['price'] ?? 0).toInt();
                      final mrp = (item['mrp'] ?? price).toInt();
                      final description = item['description'] ?? "";
                      final author = (item['author'] ?? '') as String;
                      final publisher = (item['publisher'] ?? '') as String;

                      // Calculate discount percentage if applicable
                      final discount = (mrp > price) ? (1 - price / mrp).toDouble() : null;

                      // choose short badge visually (short labels so they don't overflow)
                      String? badge;
                      if (discount != null && discount >= 0.30) {
                        badge = 'Sale';
                      } else if (index % 7 == 0) {
                        badge = 'Top';
                      } else if (index % 11 == 0) {
                        badge = 'New';
                      }

                      // Wrap ProductCard in padding to prevent edge overflow visual artifacts
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: ProductCard(
                          imageUrl: imageUrl,
                          title: title,
                          price: price,
                          discount: discount,
                          author: author,
                          rating: 4.4, // placeholder rating (replace with real rating if available)
                          badge: badge,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.productDetails,
                              arguments: {
                                'id': id,
                                'title': title,
                                'imageUrls': [imageUrl],
                                'price': price,
                                'mrp': mrp,
                                'discount': discount,
                                'rating': 4.4,
                                'reviewsCount': 128,
                                'description': description ?? "",
                                'author': author ?? "",
                                'publisher': publisher ?? "",
                                'moreByAuthor': [],
                              },
                            );
                          },
                        ),
                      );
                    },
                    childCount: visibleProducts.length,
                  ),
                  // Make tiles a bit taller to avoid content overflow (fixes the yellow/black overflow stripes)
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.lg,
                    crossAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 0.62, // lowered from 0.70 => tiles are taller
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
