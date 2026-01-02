import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/product_card.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/widgets/filter_sheet.dart';
import 'package:ecommerce_mobile/modules/home/constants/product-api.constant.dart';
import 'package:ecommerce_mobile/modules/home/types/book_product_response.dart';
import 'package:ecommerce_mobile/network/product_service.dart';
import '../../general/types/api.types.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  final _categories = const [
    'All',
    'Computer Science',
    'Electrical',
    'Engineering',
    'Fiction',
    'Non-Fiction',
    'Academic',
    'Reference',
  ];

  int _selectedCategory = 0;

  bool isLoading = false;
  int totalProducts = 0;

  List<Map<String, dynamic>> productsRaw = [];
  List<Map<String, dynamic>> productsFiltered = [];

  Map<String, dynamic>? lastAppliedFilters;

  // Track saved products by their ID
  final Set<String> _savedProductIds = <String>{};

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({Map<String, dynamic>? filters}) async {
    try {
      setState(() => isLoading = true);

      String endpoint = ProductApiConstant.bookProductsWithFilter
          .replaceFirst(":mode", "CRITERIA")
          .replaceFirst(":page", "1")
          .replaceFirst(":productsCount", "60");

      final res = await ProductService().getAllProducts(endpoint);

      final WebResponse<BookProductResponse> response =
          WebResponse.fromJson(res, (data) => BookProductResponse.fromJson(data));

      if (response.statusCode == 200) {
        productsRaw = response.results.products?.map((item) {
              return {
                'id': item.product?.item ?? '',
                'imageUrl': item.imagePath ?? '',
                'title': item.product?.itemDesc ?? 'No title',
                'price': (item.product?.ecomUnitPrice ?? 0).toInt(),
                'mrp': (item.product?.mrp ?? item.product?.ecomUnitPrice ?? 0).toInt(),
                'description': item.product?.ecomDescription ?? '',
                'category': (item.product?.category ?? '').toString(),
                'author': (item.product?.author ?? '').toString(),
                'rating': 4.4, // You can make this dynamic later
              };
            }).toList() ??
            [];

        totalProducts = response.results.totalProducts ?? productsRaw.length;
      } else {
        productsRaw = [];
        totalProducts = 0;
      }
    } catch (e, st) {
      debugPrint('Discover fetch error: $e\n$st');
      productsRaw = [];
      totalProducts = 0;
    } finally {
      _applyFilters();
      setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    var list = List<Map<String, dynamic>>.from(productsRaw);
    final filters = lastAppliedFilters ?? {};

    if (_selectedCategory != 0) {
      final cat = _categories[_selectedCategory].toLowerCase();
      list = list.where((p) => (p['category'] ?? '').toString().toLowerCase() == cat).toList();
    }

    if (filters['priceRange'] is List) {
      final range = filters['priceRange'];
      list = list.where((p) => (p['price'] as int) >= range[0] && (p['price'] as int) <= range[1]).toList();
    }

    if ((filters['author'] ?? '').toString().isNotEmpty) {
      final q = filters['author'].toString().toLowerCase();
      list = list.where((p) => (p['author'] ?? '').toString().toLowerCase().contains(q)).toList();
    }

    switch (filters['sort']) {
      case 'Price: Low - High':
        list.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High - Low':
        list.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Top Rated':
        list.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
    }

    productsFiltered = list;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 2 : width < 900 ? 3 : 4;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
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
                  onPressed: () async {
                    final res = await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) => const FilterSheet(),
                    );
                    if (res != null) {
                      lastAppliedFilters = res;
                      _applyFilters();
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppTextField(
              hint: 'Search books...',
              prefix: const Icon(Icons.search),
              readOnly: true,
              onTap: () => Navigator.pushNamed(context, Routes.search),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) {
                  final selected = _selectedCategory == i;
                  return ChoiceChip(
                    label: Text(_categories[i]),
                    selected: selected,
                    selectedColor: Colors.black,
                    backgroundColor: const Color(0xFFF5F5F5),
                    labelStyle: selected
                        ? AppTextStyles.body.copyWith(color: Colors.white)
                        : AppTextStyles.body,
                    onSelected: (_) {
                      setState(() => _selectedCategory = i);
                      _applyFilters();
                    },
                  );
                },
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = productsFiltered[index];
                      final String productId = item['id'] ?? item['title'];
                      final int price = item['price'] as int;
                      final int mrp = item['mrp'] as int;
                      final double? discount = mrp > price ? 1 - price / mrp : null;

                      String? badge;
                      if (discount != null && discount >= 0.3) {
                        badge = 'Sale';
                      } else if (index % 6 == 0) {
                        badge = 'Top';
                      }

                      return ProductCard(
                        imageUrl: item['imageUrl'],
                        title: item['title'],
                        price: price,
                        discount: discount,
                        author: item['author'],
                        rating: item['rating'],
                        badge: badge,
                        isSaved: _savedProductIds.contains(productId),
                        onSavedChanged: (bool saved) {
                          setState(() {
                            if (saved) {
                              _savedProductIds.add(productId);
                            } else {
                              _savedProductIds.remove(productId);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(saved ? 'Saved!' : 'Removed from Saved'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.productDetails,
                            arguments: item,
                          );
                        },
                      );
                    },
                    childCount: productsFiltered.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.66,
                  ),
                ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}