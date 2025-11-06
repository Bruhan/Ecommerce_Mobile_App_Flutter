import 'package:ecommerce_mobile/globals/theme.dart' show AppColors, AppRadii;
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const SearchField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
