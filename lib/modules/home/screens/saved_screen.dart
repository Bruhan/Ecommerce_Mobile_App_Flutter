import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/services/saved_manager.dart';

import '../../../globals/text_styles.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Saved Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: SavedManager.instance.notifier,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return Center(
                child: Text('No saved items yet.', style: AppTextStyles.body),
              );
            }

            return GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final image = (item['imageUrl'] ?? item['image'] ?? (item['imageUrls'] is List ? (item['imageUrls'] as List).first : null)) ??
                    'https://picsum.photos/seed/tee/400/400';
                final title = item['title'] ?? item['name'] ?? 'Product';
                final price = item['price'] ?? '';

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.productDetails, arguments: item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(image, height: 120, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => SavedManager.instance.toggle(item),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('\$${price.toString()}', style: AppTextStyles.caption),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
