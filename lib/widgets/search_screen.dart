import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/widgets/search_field.dart';

import '../globals/text_styles.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search', style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.md),
          const SearchField(hint: 'Search for clothes...'),
        ],
      ),
    );
  }
}
