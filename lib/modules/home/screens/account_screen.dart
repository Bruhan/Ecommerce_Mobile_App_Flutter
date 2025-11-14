import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

// screens we navigate to
import 'package:ecommerce_mobile/modules/home/screens/my_details_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/addresses_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/search_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  
  final String _name = 'John Doe';
  final String _email = 'john.doe@example.com';

  @override
  Widget build(BuildContext context) {
    // helper row builder
    Widget _row({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? iconBg,
    }) {
      final bg = iconBg ?? AppColors.bg;
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppTextStyles.body)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile row
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person, size: 40, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: AppTextStyles.h2),
                        const SizedBox(height: 4),
                        Text(_email, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // options container (use AppColors.bg for 'card' fallback)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      // My Orders
                      _row(
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Orders',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open My Orders')));
                        },
                      ),

                      const Divider(),

                      // My Details -> MyDetailsScreen
                      _row(
                        icon: Icons.person_outline,
                        label: 'My Details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyDetailsScreen()),
                          );
                        },
                      ),

                      const Divider(),

                      // Address Book -> AddressesScreen
                      _row(
                        icon: Icons.location_on_outlined,
                        label: 'Address Book',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddressesScreen()),
                          );
                        },
                      ),

                      const Divider(),

                      // Saved items
                      _row(
                        icon: Icons.favorite_border,
                        label: 'Saved Items',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SavedScreen()),
                          );
                        },
                      ),

                      const Divider(),

                      // Help / FAQs
                      _row(
                        icon: Icons.help_outline,
                        label: 'Help & FAQs',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Help & FAQs')));
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Settings / logout area (use h2 as fallback for h3)
              Text('Settings', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.md),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      _row(
                        icon: Icons.settings_outlined,
                        label: 'App Settings',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Settings'))),
                      ),
                      const Divider(),
                      _row(
                        icon: Icons.logout,
                        label: 'Log out',
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
