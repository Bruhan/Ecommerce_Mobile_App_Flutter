import 'package:ecommerce_mobile/modules/home/screens/search_field.dart'
    show SearchField;
import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text("Search", style: AppTextStyles.h1),
        const SizedBox(height: AppSpacing.xl),
        const SearchField(hint: "Search for clothes..."),
      ],
    );
  }
}
