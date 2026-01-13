import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

import '../globals/text_styles.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saved Items', style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.md),
          const Text('Your wishlist will appear here.'),
        ],
      ),
    );
  }
}
