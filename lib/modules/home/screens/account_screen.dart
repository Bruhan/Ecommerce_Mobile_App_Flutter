// lib/modules/home/screens/account_screen.dart
import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../widgets/app_bottom_nav.dart';

import 'discover_tab.dart';
import 'search_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/account_screen.dart' as _self_import_placeholder; // harmless placeholder - you can remove this line if analyzer complains

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Account'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: notifications route
            },
            icon: const Icon(Icons.notifications_none_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            children: [
              const SizedBox(height: AppSpacing.md),

              // Section 1
              _row(
                context,
                icon: Icons.shopping_bag_outlined,
                label: 'My Orders',
                onTap: () {
                  // TODO: route to orders screen
                },
              ),
              const Divider(height: 1),
              _row(
                context,
                icon: Icons.person_outline,
                label: 'My Details',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDetailsScreen()),
                ),
              ),
              const Divider(height: 1),
              _row(
                context,
                icon: Icons.location_on_outlined,
                label: 'Address Book',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressesScreen()),
                ),
              ),
              const Divider(height: 12),

              // Section 2
              _row(
                context,
                icon: Icons.credit_card_outlined,
                label: 'Payment Methods',
                onTap: () {
                  // TODO: route to payment methods
                },
              ),
              const Divider(height: 1),
              _row(
                context,
                icon: Icons.notifications_none_outlined,
                label: 'Notifications',
                onTap: () {
                  // TODO: route to notifications settings
                },
              ),
              const Divider(height: 12),

              // Section 3
              _row(
                context,
                icon: Icons.question_mark_outlined,
                label: 'FAQs',
                onTap: () {
                  // TODO: route to FAQs
                },
              ),
              const Divider(height: 1),
              _row(
                context,
                icon: Icons.headset_mic_outlined,
                label: 'Help Center',
                onTap: () {
                  // TODO: route to help center
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // Logout
              InkWell(
                onTap: () {
                  // TODO: logout handling
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: AppColors.danger),
                      SizedBox(width: AppSpacing.md),
                      Text('Logout', style: TextStyle(color: AppColors.danger)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // NOTE: bottomNavigationBar REMOVED — HomeShell provides the app-wide nav.
    );
  }
}

/// Helper row widget used on the Account screen.
Widget _row(
  BuildContext context, {
  required IconData icon,
  required String label,
  VoidCallback? onTap,
  Color? iconBg,
}) {
  // Use safe fallback colors which definitely exist in your theme.
  final bg = iconBg ?? AppColors.bg;
  final iconColor = AppColors.textPrimary;
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    ),
  );
}

//
// --- Minimal placeholder screens to avoid undefined-symbol compile errors ---
// Remove these and import your real screens if/when they exist.
//

class MyDetailsScreen extends StatelessWidget {
  const MyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        child: ListView(
          children: [
            Text('Full Name', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(initialValue: '', decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: AppSpacing.md),

            Text('Email Address', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(initialValue: '', decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: AppSpacing.md),

            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: submit
                },
                child: const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {'title': 'Home', 'subtitle': '123, Main Street, City'},
      {'title': 'Office', 'subtitle': '42, Corporate Ave, City'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Address Book'),
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
                        Radio<int>(value: i, groupValue: 0, onChanged: (int? _) {}),
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
                  // TODO: show Add New Address
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
