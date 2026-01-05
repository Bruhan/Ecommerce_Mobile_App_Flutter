// lib/modules/products/screens/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/services/saved_manager.dart';

import '../../../globals/text_styles.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProductDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewsKey = GlobalKey();

  // book-specific: formats instead of clothing sizes
  String _selectedFormat = 'Paperback';
  int _quantity = 1;

  late final String? _productId;
  late final ValueNotifier<bool> _isSavedNotifier;

  // NEW: track whether this product was added to cart during this screen session
  bool _addedToCart = false;

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Wade Warren',
      'rating': 5,
      'text': 'The book is excellent — well explained and a great reference.',
      'time': '6 days ago'
    },
    {
      'name': 'Guy Hawkins',
      'rating': 4,
      'text': 'Fast shipping and the book was in good condition.',
      'time': '1 week ago'
    },
    {
      'name': 'Robert Fox',
      'rating': 4,
      'text': 'Useful examples and clear diagrams — recommended.',
      'time': '2 weeks ago'
    },
  ];

  @override
  void initState() {
    super.initState();
    _productId = _deriveId(widget.data);
    _isSavedNotifier = ValueNotifier<bool>(_productId != null && SavedManager.instance.isSaved(_productId!));
    SavedManager.instance.notifier.addListener(_savedListener);

    // Optionally you could check cart manager here to mark already-in-cart,
    // but to keep this change safe and compile-proof we only mark added when user adds.
    _addedToCart = false;
  }

  void _savedListener() {
    if (_productId == null) return;
    _isSavedNotifier.value = SavedManager.instance.isSaved(_productId!);
  }

  @override
  void dispose() {
    SavedManager.instance.notifier.removeListener(_savedListener);
    _isSavedNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _deriveId(Map<String, dynamic> data) {
    if (data.containsKey('id') && data['id'] != null) return data['id'].toString();
    if (data.containsKey('title') && data['title'] != null) return data['title'].toString();
    return null;
  }

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

  Widget _buildStars(double rating, {double iconSize = 16}) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        final color = i < full ? Colors.amber : Colors.grey.withOpacity(0.4);
        IconData icon;
        if (i < full) {
          icon = Icons.star;
        } else if (i == full && half) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: color, size: iconSize);
      }),
    );
  }

  void _addToCart({
    required String id,
    required String title,
    required String image,
    required int price,
    required String format,
    required int quantity,
  }) {
    // Capture messenger early (safe to reuse even if widget is popped later)
    final messenger = ScaffoldMessenger.of(context);

    final item = CartItem(
      id: id,
      title: title,
      imageUrl: image,
      price: price,
      size: format, // reuse size field for format
      quantity: quantity,
    );

    // addItem returns void in your CartManager implementation
    try {
      CartManager.instance.addItem(item);
    } catch (e, st) {
      debugPrint('CartManager.addItem error: $e\n$st');
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to add to cart')),
      );
      return;
    }

    // Mark as added locally so button becomes "Go to Cart"
    if (mounted) {
      setState(() {
        _addedToCart = true;
      });
    }

    // Show snackbar safely using captured messenger.
    messenger.showSnackBar(
      SnackBar(
        content: Text('Added "$title" to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            if (mounted) {
              Navigator.pushNamed(context, Routes.cart);
            }
          },
        ),
      ),
    );
  }

  // Helper: more-by-author carousel
  Widget _moreByAuthorSection(List<Map<String, dynamic>> items, String author) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text('More Books By $author', style: AppTextStyles.h2.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (ctx, i) {
              final it = items[i];
              final String title = (it['title'] ?? it['name'] ?? '').toString();
              final String img = (it['imageUrl'] ?? it['image'] ?? '').toString();
              final int price = (it['price'] ?? it['mrp'] ?? it['amount'] ?? 0).toInt();

              return GestureDetector(
                onTap: () {
                  // push details for that book (reusing same screen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailsScreen(data: it)),
                  );
                },
                child: SizedBox(
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: img.isNotEmpty
                            ? Image.network(img, width: 130, height: 110, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 130, height: 110, color: AppColors.bg))
                            : Container(width: 130, height: 110, color: AppColors.bg),
                      ),
                      const SizedBox(height: 8),
                      Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.body?.copyWith(fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('₹${price.toString()}', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _ratingBars([Color? accent, Color? muted]) {
    final counts = [60, 25, 8, 5, 2];
    final total = counts.fold<int>(0, (a, b) => a + b);
    final accentColor = accent ?? AppColors.bg;
    final fillColor = muted ?? AppColors.textSecondary;

    return Column(
      children: List.generate(5, (idx) {
        final star = 5 - idx;
        final count = counts[idx];
        final ratio = total == 0 ? 0.0 : (count / total);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Text('$star', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Stack(
                  children: [
                    Container(height: 10, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(8))),
                    FractionallySizedBox(widthFactor: ratio, child: Container(height: 10, decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(8)))),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('$count', style: AppTextStyles.caption),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewTile(Map<String, dynamic> r) {
    final rating = (r['rating'] ?? 0).toInt();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Row(children: List.generate(5, (i) => Icon(Icons.star, color: i < rating ? Colors.amber : Colors.grey.withOpacity(0.4), size: 16))),
          const SizedBox(width: AppSpacing.sm),
          Text('${r['name']}', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Text('${r['text']}', style: AppTextStyles.body),
        const SizedBox(height: 8),
        Text('${r['time']}', style: AppTextStyles.caption),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    final title = (data['title'] ?? data['name'] ?? 'Untitled').toString();
    final images = List<String>.from(data['imageUrls'] ?? data['images'] ?? [data['imageUrl'] ?? data['image'] ?? 'https://picsum.photos/seed/book/800/800']);
    final price = (data['price'] ?? data['mrp'] ?? 199).toInt();
    final description = data['description'] ?? data['summary'] ?? 'No description provided.';
    final rating = (data['rating'] ?? 4.5).toDouble();
    final reviewsCount = (data['reviewsCount'] ?? data['reviews']?.length ?? 45).toInt();

    // book-specific fields
    final author = (data['author'] ?? data['writtenBy'] ?? data['writer'] ?? 'Unknown Author').toString();
    final publisher = (data['publisher'] ?? '').toString();
    final edition = (data['edition'] ?? '').toString();
    final promoTag = (data['promoTag'] ?? data['badge'] ?? '').toString();
    final deliveryInfo = (data['deliveryInfo'] ?? 'Get your order in 2-3 days across Tamil Nadu, and 5-7 days for other states.').toString();
    final moreByAuthorRaw = data['moreByAuthor'] ?? data['authorBooks'] ?? [];
    final List<Map<String, dynamic>> moreByAuthor = (moreByAuthorRaw is List) ? List<Map<String, dynamic>>.from(moreByAuthorRaw.map((e) => e is Map ? Map<String, dynamic>.from(e) : {'title': e.toString()})) : [];

    // page padding and "is wide" detection (tablet/desktop)
    final double pagePadding = AppSpacing.lg;
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    // defensive fallback colors (ensure AppColors has these fields in your theme)
    final Color mutedColor = AppColors.textSecondary ?? Colors.grey;
    final Color accentColor = AppColors.bg ?? Colors.grey.shade100;

    // format/edition options for books
    final formats = ['Paperback', 'Hardcover', 'eBook'];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Details', style: AppTextStyles.h2),
        actions: [
          // KEEP only the single heart in the details row (remove top overlay heart)
          IconButton(
            onPressed: () => SavedManager.instance.toggle(data),
            icon: ValueListenableBuilder<bool>(
              valueListenable: _isSavedNotifier,
              builder: (_, saved, __) => Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.red : Colors.black),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
            icon: const Icon(Icons.notifications_outlined, size: 22),
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (isWide && constraints.maxWidth >= 800) {
            // two-column layout for wide screens (bookstore style)
            return Padding(
              padding: EdgeInsets.all(pagePadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // left: big cover + thumbnails
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Make the image flexible to avoid fixed height overflow
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                            child: Image.network(
                              images.first,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                            itemBuilder: (ctx, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(images[i], width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: AppColors.bg)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 28),

                  // right column: details (scrollable)
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Expanded(child: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 22), maxLines: 3, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                // keep only this heart (already in AppBar as well) — this one stays
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isSavedNotifier,
                                  builder: (_, saved, __) => IconButton(
                                    onPressed: () => SavedManager.instance.toggle(data),
                                    icon: Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.red : mutedColor),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('by $author', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (publisher.isNotEmpty) Flexible(child: Text(publisher, style: AppTextStyles.caption)),
                                if (edition.isNotEmpty) const SizedBox(width: 12),
                                if (edition.isNotEmpty) Flexible(child: Text(edition, style: AppTextStyles.caption?.copyWith(color: mutedColor))),
                              ],
                            ),
                            const SizedBox(height: 12),

                            GestureDetector(
                              onTap: _scrollToReviews,
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 6),
                                  Text('${rating.toStringAsFixed(1)}/5', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                                  const Spacer(),
                                  Text('See reviews', style: AppTextStyles.body?.copyWith(color: mutedColor)),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: mutedColor),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),
                            Text(description, style: AppTextStyles.body?.copyWith(fontSize: 15)),
                            const SizedBox(height: AppSpacing.md),

                            // Format / Edition selector (bookstore)
                            Text('Format / Edition', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: formats
                                  .map((f) => GestureDetector(
                                        onTap: () => setState(() => _selectedFormat = f),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          margin: const EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                            color: _selectedFormat == f ? AppColors.primary : Colors.white,
                                            border: Border.all(color: mutedColor),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(f, style: AppTextStyles.body?.copyWith(color: _selectedFormat == f ? Colors.white : AppColors.textPrimary)),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Price', style: AppTextStyles.caption),
                                    Text('\₹${price.toInt()}', style: AppTextStyles.h2?.copyWith(fontSize: 22)),
                                  ]),
                                ),
                                const SizedBox(width: 12),

                                // Quantity controls + Add to Cart (bounded)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => setState(() {
                                            if (_quantity > 1) _quantity--;
                                          }),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.fieldBorder), borderRadius: BorderRadius.circular(6)),
                                            child: const Icon(Icons.remove, size: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('$_quantity', style: AppTextStyles.body),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () => setState(() => _quantity++),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.fieldBorder), borderRadius: BorderRadius.circular(6)),
                                            child: const Icon(Icons.add, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 220),
                                      child: AppButton(
                                        label: _addedToCart ? 'Go to Cart' : 'Add to Cart',
                                        onPressed: () {
                                          if (_addedToCart) {
                                            Navigator.pushNamed(context, Routes.cart);
                                            return;
                                          }
                                          final id = (data['id'] ?? title).toString();
                                          _addToCart(
                                            id: id,
                                            title: title,
                                            image: images.first,
                                            price: price,
                                            format: _selectedFormat,
                                            quantity: _quantity,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.xl),
                            if (promoTag.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                                child: Text(promoTag, style: AppTextStyles.caption?.copyWith(fontWeight: FontWeight.w700)),
                              ),
                            const SizedBox(height: 12),
                            Text(deliveryInfo, style: AppTextStyles.caption),
                            const SizedBox(height: AppSpacing.lg),

                            // More by author
                            _moreByAuthorSection(moreByAuthor, author),

                            const SizedBox(height: AppSpacing.xl),
                            const Divider(),
                            const SizedBox(height: AppSpacing.sm),

                            // Reviews
                            Container(
                              key: _reviewsKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: 20))),
                                      const Spacer(),
                                      TextButton(onPressed: () {}, child: const Text('Write a review'))
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: 26)),
                                      const SizedBox(width: AppSpacing.md),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildStars(rating, iconSize: 18),
                                          const SizedBox(height: 6),
                                          Text('$reviewsCount Ratings', style: AppTextStyles.caption),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  _ratingBars(accentColor, mutedColor),
                                  const SizedBox(height: AppSpacing.md),
                                  ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _reviews.length,
                                    separatorBuilder: (_, __) => const Divider(),
                                    itemBuilder: (context, i) => _buildReviewTile(_reviews[i]),
                                  ),
                                  const SizedBox(height: AppSpacing.xl),
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
                const SizedBox(height: AppSpacing.md),
                // NOTE: removed the top-right overlay heart; image is just the image now
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  child: Image.network(images.first, height: 260, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 260, color: AppColors.surface)),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 20), maxLines: 3, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    // Keep only single heart here
                    ValueListenableBuilder<bool>(
                      valueListenable: _isSavedNotifier,
                      builder: (_, saved, __) => IconButton(
                        onPressed: () => SavedManager.instance.toggle(data),
                        icon: Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.red : mutedColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text('by $author', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _scrollToReviews,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text('${rating.toStringAsFixed(1)}/5', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                      const Spacer(),
                      Text('See reviews', style: AppTextStyles.body?.copyWith(color: mutedColor)),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios, size: 14, color: mutedColor),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(description, style: AppTextStyles.body?.copyWith(fontSize: 15)),
                const SizedBox(height: AppSpacing.md),

                // Format selector
                Text('Format / Edition', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: formats.map((f) {
                    final selected = f == _selectedFormat;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFormat = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(border: Border.all(color: mutedColor), borderRadius: BorderRadius.circular(8), color: selected ? AppColors.primary : Colors.white),
                          child: Text(f, style: AppTextStyles.body?.copyWith(color: selected ? Colors.white : AppColors.textPrimary)),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Price', style: AppTextStyles.caption), Text('\₹${price.toInt()}', style: AppTextStyles.h2?.copyWith(fontSize: 22))])),

                    const SizedBox(width: 12),
                    // quantity + add button
                    Row(
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            if (_quantity > 1) _quantity--;
                          }),
                          child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(border: Border.all(color: AppColors.fieldBorder), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.remove, size: 18)),
                        ),
                        const SizedBox(width: 8),
                        Text('$_quantity', style: AppTextStyles.body),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => setState(() => _quantity++),
                          child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(border: Border.all(color: AppColors.fieldBorder), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.add, size: 18)),
                        ),
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: AppButton(
                            label: _addedToCart ? 'Go to Cart' : 'Add to Cart',
                            onPressed: () {
                              if (_addedToCart) {
                                Navigator.pushNamed(context, Routes.cart);
                                return;
                              }
                              final id = (data['id'] ?? title).toString();
                              _addToCart(
                                id: id,
                                title: title,
                                image: images.first,
                                price: price,
                                format: _selectedFormat,
                                quantity: _quantity,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // More by author (mobile)
                _moreByAuthorSection(moreByAuthor, author),

                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  key: _reviewsKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Expanded(child: Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: 20))), const Spacer(), TextButton(onPressed: () {}, child: const Text('Write a review'))]),
                      const SizedBox(height: AppSpacing.sm),
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: 26)), const SizedBox(width: AppSpacing.md), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildStars(rating, iconSize: 18), const SizedBox(height: 6), Text('$reviewsCount Ratings', style: AppTextStyles.caption)])]),
                      const SizedBox(height: AppSpacing.md),
                      _ratingBars(accentColor, mutedColor),
                      const SizedBox(height: AppSpacing.md),
                      ListView.separated(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: _reviews.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, i) => _buildReviewTile(_reviews[i])),
                      const SizedBox(height: AppSpacing.xl),
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
}
