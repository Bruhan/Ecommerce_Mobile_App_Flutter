import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Saved Items",
        style: AppTextStyles.h1,
      ),
    );
  }
}
