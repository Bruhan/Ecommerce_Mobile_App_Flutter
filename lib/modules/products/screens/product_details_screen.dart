import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/models/cart_item.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/services/saved_manager.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProductDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewsKey = GlobalKey();

  String _selectedSize = 'L';
  int _quantity = 1;

  late final String? _productId;
  late final ValueNotifier<bool> _isSavedNotifier;

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

  @override
  void initState() {
    super.initState();
    _productId = _deriveId(widget.data);
    _isSavedNotifier = ValueNotifier<bool>(_productId != null && SavedManager.instance.isSaved(_productId!));
    SavedManager.instance.notifier.addListener(_savedListener);
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
    return Row(
      children: List.generate(5, (i) {
        final color = i < full ? Colors.amber : Colors.grey.withOpacity(0.4);
        return Icon(Icons.star, color: color, size: iconSize);
      }),
    );
  }

  void _addToCart({
    required String id,
    required String title,
    required String image,
    required int price,
    required String size,
    required int quantity,
  }) {
    final item = CartItem(
      id: id,
      title: title,
      imageUrl: image,
      price: price,
      size: size,
      quantity: quantity,
    );

    CartManager.instance.addItem(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$title" to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, Routes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final title = data['title'] ?? 'Product';
    final images = List<String>.from(
        data['imageUrls'] ?? data['images'] ?? [data['imageUrl'] ?? 'https://picsum.photos/seed/tee/800/800']);
    final price = (data['price'] ?? 1190).toInt();
    final description = data['description'] ?? 'No description provided.';
    final rating = (data['rating'] ?? 4.0).toDouble();
    final reviewsCount = (data['reviewsCount'] ?? 45).toInt();

    // page padding and "is wide" detection (tablet/desktop)
    final double pagePadding = AppSpacing.lg;
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    // defensive fallback colors (ensure AppColors has these fields in your theme)
    final Color mutedColor = AppColors.textSecondary;
    final Color accentColor = AppColors.bg;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
            icon: const Icon(Icons.notifications_outlined, size: 22),
          )
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (isWide && constraints.maxWidth >= 800) {
            // two-column layout for wide screens
            return Padding(
              padding: EdgeInsets.all(pagePadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadii.lg),
                              child: Image.network(
                                images.first,
                                height: constraints.maxHeight * 0.75,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // heart overlay top-right
                            Positioned(
                              right: 12,
                              top: 12,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _isSavedNotifier,
                                builder: (_, saved, __) => GestureDetector(
                                  onTap: () => SavedManager.instance.toggle(data),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(saved ? Icons.favorite : Icons.favorite_border,
                                        color: saved ? Colors.red : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              child: Image.network(images[i], width: 80, height: 80, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
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
                                Expanded(child: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 22))),
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isSavedNotifier,
                                  builder: (_, saved, __) => IconButton(
                                    onPressed: () => SavedManager.instance.toggle(data),
                                    icon: Icon(saved ? Icons.favorite : Icons.favorite_border,
                                        color: saved ? Colors.red : mutedColor),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),

                            GestureDetector(
                              onTap: _scrollToReviews,
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 6),
                                  Text('${rating.toStringAsFixed(1)}/5',
                                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                                  const Spacer(),
                                  Text('See reviews', style: AppTextStyles.body.copyWith(color: mutedColor)),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: mutedColor),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),
                            Text(description, style: AppTextStyles.body.copyWith(fontSize: 15)),
                            const SizedBox(height: AppSpacing.md),

                            Text('Choose size', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: ['S', 'M', 'L', 'XL']
                                  .map((s) => GestureDetector(
                                        onTap: () => setState(() => _selectedSize = s),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          margin: const EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                            color: _selectedSize == s ? Colors.black : Colors.white,
                                            border: Border.all(color: mutedColor),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(s,
                                              style: AppTextStyles.body
                                                  .copyWith(color: _selectedSize == s ? Colors.white : AppColors.textPrimary)),
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
                                    Text('\$${price.toInt()}', style: AppTextStyles.h2.copyWith(fontSize: 22)),
                                  ]),
                                ),
                                const SizedBox(width: 12),

                                // Quantity controls + Add to Cart
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
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.fieldBorder),
                                                borderRadius: BorderRadius.circular(6)),
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
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.fieldBorder),
                                                borderRadius: BorderRadius.circular(6)),
                                            child: const Icon(Icons.add, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 220,
                                      child: AppButton(
                                        label: 'Add to Cart',
                                        onPressed: () {
                                          final id = (data['id'] ?? title).toString();
                                          _addToCart(
                                            id: id,
                                            title: title,
                                            image: images.first,
                                            price: price,
                                            size: _selectedSize,
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
                            const Divider(),
                            const SizedBox(height: AppSpacing.sm),

                            Container(
                              key: _reviewsKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: 20)),
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
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        _buildStars(rating, iconSize: 18),
                                        const SizedBox(height: 6),
                                        Text('$reviewsCount Ratings', style: AppTextStyles.caption),
                                      ]),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildRatingBars(accentColor, mutedColor),
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
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      child:
                          Image.network(images.first, height: 260, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isSavedNotifier,
                        builder: (_, saved, __) => GestureDetector(
                          onTap: () => SavedManager.instance.toggle(data),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                            padding: const EdgeInsets.all(8),
                            child:
                                Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.red : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.h2.copyWith(fontSize: 20))),
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
                GestureDetector(
                  onTap: _scrollToReviews,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text('${rating.toStringAsFixed(1)}/5', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('($reviewsCount reviews)', style: AppTextStyles.caption),
                      const Spacer(),
                      Text('See reviews', style: AppTextStyles.body.copyWith(color: mutedColor)),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios, size: 14, color: mutedColor),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(description, style: AppTextStyles.body.copyWith(fontSize: 15)),
                const SizedBox(height: AppSpacing.md),
                Text('Choose size', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: ['S', 'M', 'L', 'XL'].map((s) {
                    final selected = s == _selectedSize;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSize = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              border: Border.all(color: mutedColor),
                              borderRadius: BorderRadius.circular(8),
                              color: selected ? Colors.black : Colors.white),
                          child: Text(s, style: AppTextStyles.body.copyWith(color: selected ? Colors.white : AppColors.textPrimary)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Price', style: AppTextStyles.caption), Text('\$${price.toInt()}', style: AppTextStyles.h2.copyWith(fontSize: 22))])),
                    const SizedBox(width: 12),
                    // quantity + add button
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
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: AppButton(
                            label: 'Add to Cart',
                            onPressed: () {
                              final id = (data['id'] ?? title).toString();
                              _addToCart(
                                id: id,
                                title: title,
                                image: images.first,
                                price: price,
                                size: _selectedSize,
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
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  key: _reviewsKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text('Reviews', style: AppTextStyles.h2.copyWith(fontSize: 20)), const Spacer(), TextButton(onPressed: () {}, child: const Text('Write a review'))]),
                      const SizedBox(height: AppSpacing.sm),
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: 26)), const SizedBox(width: AppSpacing.md), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildStars(rating, iconSize: 18), const SizedBox(height: 6), Text('$reviewsCount Ratings', style: AppTextStyles.caption)])]),
                      const SizedBox(height: AppSpacing.md),
                      _buildRatingBars(accentColor, mutedColor),
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

  Widget _buildRatingBars([Color? accent, Color? muted]) {
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
              Text('$star', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
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
          Row(children: List.generate(5, (i) => Icon(Icons.star, color: i < (r['rating'] ?? 0) ? Colors.amber : Colors.grey.withOpacity(0.4), size: 16))),
          const SizedBox(width: AppSpacing.sm),
          Text('${r['name']}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
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
}
