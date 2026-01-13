import 'package:flutter/material.dart';
import '../globals/text_styles.dart';
import '../globals/theme.dart';

class AppAuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppAuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h1),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: AppTextStyles.subtitle),
      ],
    );
  }
}
