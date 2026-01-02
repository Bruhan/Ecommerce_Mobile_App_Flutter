// lib/modules/home/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("Search", style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            children: [
              // simple search field
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search products, categories...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // placeholder content
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent searches', style: AppTextStyles.body),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Center(
                  child: Text('No recent searches', style: AppTextStyles.caption),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
