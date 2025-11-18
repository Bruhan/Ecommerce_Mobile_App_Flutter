import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Filters', style: AppTextStyles.h2),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Sort By', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [_chip('Relevance', true), _chip('Price: Low - High'), _chip('Price: High - Low')],
            ),

            const SizedBox(height: AppSpacing.lg),
            Text('Price', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Slider(value: 19, min: 0, max: 100, onChanged: (_) {}),

            const SizedBox(height: AppSpacing.lg),
            Text('Size', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: AppSpacing.sm, children: ['S','M','L','XL'].map((s)=>_chip(s)).toList()),

            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, [bool selected = false]) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: Colors.black,
      labelStyle: selected
          ? const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
          : const TextStyle(),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? Colors.black : AppColors.fieldBorder),
      ),
      onSelected: (_) {},
    );
  }
}
