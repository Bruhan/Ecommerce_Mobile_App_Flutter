import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchField({super.key, required this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: const Icon(Icons.mic_none_rounded),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 12),
          ),
        ),
      ),
    );
  }
}
