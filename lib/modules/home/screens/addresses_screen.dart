// lib/modules/home/screens/addresses_screen.dart
import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // sample list of addresses
    final addresses = [
      {'title': 'Home', 'subtitle': 'J8FR+PM Massa, Metropolitan City...'},
      {'title': 'Office', 'subtitle': '999 Granville St, Vancouver...'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Address'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) {
                  final a = addresses[i];
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.fieldBorder)),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a['title']!, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: AppSpacing.sm),
                              Text(a['subtitle']!, style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Radio<int>(value: i, groupValue: 0, onChanged: (_) {}),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: show "Add New Address" modal
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Address'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: apply selection
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
