import 'package:ecommerce_mobile/modules/home/constants/product-api.constant.dart';
import 'package:ecommerce_mobile/modules/home/types/book_product_response.dart';
import 'package:ecommerce_mobile/network/product_service.dart';
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

  int _selected = 0;

  // Raw products from API (unfiltered)
  List<Map<String, dynamic>> productsRaw = [];
  // Products after applying client-side filters
  List<Map<String, dynamic>> productsFiltered = [];

  int totalProducts = 0;
  bool productsDataLoading = false;

  /// lastAppliedFilters keeps the currently applied filters so UI can show state
  Map<String, dynamic>? lastAppliedFilters;

  @override
  void initState() {
    super.initState();
    fetchProductsData();
  }

  /// Fetch products from API and apply any client-side filters (if set)
  Future<void> fetchProductsData({Map<String, dynamic>? filters}) async {
    try {
      setState(() {
        productsDataLoading = true;
      });

      // Base endpoint with placeholders replaced (same as original)
      String endpoint = ProductApiConstant.bookProductsWithFilter
          .replaceFirst(":mode", "CRITERIA")
          .replaceFirst(":page", "1")
          .replaceFirst(":productsCount", "60");

      if (filters != null && filters.isNotEmpty) {
        lastAppliedFilters = Map<String, dynamic>.from(filters);
      } else {
        lastAppliedFilters = null;
      }

      /// ✅ REPLACED DIRECT API CALL WITH ProductService()
      final res = await ProductService().getAllProducts(endpoint);

      WebResponse<BookProductResponse> response = WebResponse.fromJson(
        res,
        (data) {
          return BookProductResponse.fromJson(data);
        },
      );

      if (response.statusCode == 200) {
        final mapped = response.results.products?.map((item) {
              return {
                'item': item.product?.item ?? "",
                'imageUrl': item.imagePath ?? "",
                'title': item.product?.itemDesc ?? "No Name",
                'price': (item.product?.ecomUnitPrice ?? 0).toInt(),
                'mrp': (item.product?.mrp ?? item.product?.ecomUnitPrice ?? 0).toInt(),
                'description': item.product?.ecomDescription ?? "",
                'category': (item.product?.category ?? '').toString(),
                'author': (item.product?.author ?? '').toString(),
                'publisher': '',

                // FALLBACKS
                'format': '', 
                'language': 'English',
                'rating': 4.4,
              };
            }).toList() ??
            <Map<String, dynamic>>[];

        productsRaw = List<Map<String, dynamic>>.from(mapped);
        totalProducts = response.results.totalProducts ?? productsRaw.length;
      } else {
        productsRaw = <Map<String, dynamic>>[];
        totalProducts = 0;
      }
    } catch (e, st) {
      debugPrint('fetchProductsData error: $e\n$st');
      productsRaw = <Map<String, dynamic>>[];
      totalProducts = 0;
    } finally {
      _applyFiltersClient();
      if (mounted) {
        setState(() {
          productsDataLoading = false;
        });
      }
    }
  }

  /// Client-side filtering logic
  void _applyFiltersClient() {
    final filters = lastAppliedFilters ?? {};
    var out = List<Map<String, dynamic>>.from(productsRaw);

    // PRICE
    if (filters['priceRange'] is List && (filters['priceRange'] as List).length >= 2) {
      final pr = filters['priceRange'] as List;
      final min = (pr[0] as num).toDouble();
      final max = (pr[1] as num).toDouble();

      out = out.where((p) {
        final price = (p['price'] ?? p['mrp'] ?? 0);
        final priceDouble = (price is num) ? price.toDouble() : double.tryParse(price.toString()) ?? 0.0;
        return priceDouble >= min && priceDouble <= max;
      }).toList();
    }

    // FORMATS
    if (filters['formats'] is List && (filters['formats'] as List).isNotEmpty) {
      final selectedFormats = List<String>.from(filters['formats'])
          .map((s) => s.toString().toLowerCase())
          .toList();

      out = out.where((p) {
        final format = (p['format'] ?? '').toString().toLowerCase();
        return selectedFormats.contains(format) || selectedFormats.isEmpty;
      }).toList();
    }

    // GENRES
    if (filters['genres'] is List && (filters['genres'] as List).isNotEmpty) {
      final selGenres = List<String>.from(filters['genres'])
          .map((s) => s.toString().toLowerCase())
          .toList();

      out = out.where((p) {
        final g = (p['category'] ?? '').toString().toLowerCase();
        final title = (p['title'] ?? '').toString().toLowerCase();
        return selGenres.any((sg) => g.contains(sg) || title.contains(sg));
      }).toList();
    }

    // AUTHOR
    final authorQuery = (filters['author'] ?? '').toString().trim();
    if (authorQuery.isNotEmpty) {
      out = out.where((p) {
        final author = (p['author'] ?? '').toString().toLowerCase();
        return author.contains(authorQuery.toLowerCase());
      }).toList();
    }

    // LANGUAGES
    if (filters['languages'] is List && (filters['languages'] as List).isNotEmpty) {
      final langs = List<String>.from(filters['languages'])
          .map((s) => s.toString().toLowerCase())
          .toList();

      out = out.where((p) {
        final lang = (p['language'] ?? 'english').toString().toLowerCase();
        return langs.contains(lang);
      }).toList();
    }

    // RATING
    if (filters['rating'] is String && filters['rating'] != 'Any') {
      final r = filters['rating'] as String;
      final match = RegExp(r'(\d+)').firstMatch(r);
      if (match != null) {
        final minRating = int.tryParse(match.group(1) ?? '') ?? 0;

        out = out.where((p) {
          final rating = (p['rating'] ?? 0);
          final ratingDouble =
              (rating is num) ? rating.toDouble() : double.tryParse(rating.toString()) ?? 0.0;
          return ratingDouble >= minRating;
        }).toList();
      }
    }

    // SORT
    final sort = (filters['sort'] as String?) ?? 'Relevance';
    if (sort == 'Price: Low - High') {
      out.sort((a, b) => (a['price'] as num).compareTo(b['price']));
    } else if (sort == 'Price: High - Low') {
      out.sort((a, b) => (b['price'] as num).compareTo(a['price']));
    } else if (sort == 'Top Rated') {
      out.sort((a, b) => (b['rating'] as num).compareTo(a['rating']));
    }

    // CATEGORY FILTER
    final visibleAfterCategory = out.where((p) {
      if (_selected == 0) return true;
      final itemCat = (p['category'] ?? '').toString().toLowerCase();
      return itemCat == _categories[_selected].toLowerCase();
    }).toList();

    productsFiltered = visibleAfterCategory;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = productsFiltered;

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

        // Search bar → navigate to Search screen
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

        // Category Chips
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
                      _applyFiltersClient();
                    },
                  );
                },
              ),
            ),
          ),
        ),

        // Products Grid
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
              : (visibleProducts.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(30), child: Text('No books found'))),
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

                          final discount = (mrp > price) ? (1 - price / mrp).toDouble() : null;

                          String? badge;
                          if (discount != null && discount >= 0.30) {
                            badge = 'Sale';
                          } else if (index % 7 == 0) {
                            badge = 'Top';
                          } else if (index % 11 == 0) {
                            badge = 'New';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: ProductCard(
                              imageUrl: imageUrl,
                              title: title,
                              price: price,
                              discount: discount,
                              author: author,
                              rating: (item['rating'] ?? 4.4) as double,
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
                                    'rating': (item['rating'] ?? 4.4),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.lg,
                        crossAxisSpacing: AppSpacing.lg,
                        childAspectRatio: 0.62,
                      ),
                    )),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }

  /// Show the filter sheet
  void _showFilters(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FilterSheet(),
    );

    if (result != null) {
      lastAppliedFilters = Map<String, dynamic>.from(result);
      _applyFiltersClient();
    }
  }
}
