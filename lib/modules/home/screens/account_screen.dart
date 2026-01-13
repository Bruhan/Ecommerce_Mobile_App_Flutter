import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

import 'my_details_screen.dart';
import 'addresses_screen.dart';
import 'saved_screen.dart';
import 'package:ecommerce_mobile/modules/orders/screens/orders_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  Future<void> _openMyDetails() async {
    final result = await Navigator.push<Map<dynamic, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const MyDetailsScreen()),
    );

    if (result == null) return;

    setState(() {
      _name = result['name'] ?? _name;
      _email = result['email'] ?? _email;
    });
  }

  // 🔹 Normal row
  Widget _row({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.textPrimary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: color),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 🔹 Thin divider
  Widget _divider() {
    return const Divider(height: 1);
  }

  // 🔹 Section separator (thick grey bar)
  Widget _sectionSeparator() {
    return Container(
      height: 10,
      color: const Color(0xFFF1F1F1),
    );
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 32),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Logout?', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Are you sure you want to logout?',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Yes logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(
                      Routes.login,
                      (route) => false,
                    );
                  },
                  child: const Text('Yes, Logout'),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Cancel
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No, Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, Routes.notifications),
          ),
        ],
      ),
      body: ListView(
        children: [
          _row(
            icon: Icons.shopping_bag_outlined,
            label: 'My Orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          _sectionSeparator(),
          _row(
            icon: Icons.person_outline,
            label: 'My Details',
            onTap: _openMyDetails,
          ),
          _divider(),
          _row(
            icon: Icons.location_on_outlined,
            label: 'Address Book',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressesScreen()),
            ),
          ),
          _divider(),
          _row(
            icon: Icons.credit_card_outlined,
            label: 'Payment Methods',
            onTap: () => Navigator.pushNamed(context, Routes.paymentMethods),
          ),
          _divider(),
          _row(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () =>
                Navigator.pushNamed(context, Routes.notificationSettings),
          ),
          _sectionSeparator(),
          _row(
            icon: Icons.help_outline,
            label: 'FAQs',
            onTap: () => Navigator.pushNamed(context, Routes.faqs),
          ),
          _divider(),
          _row(
            icon: Icons.headset_mic_outlined,
            label: 'Help Center',
            onTap: () => Navigator.pushNamed(context, Routes.helpCenter),
          ),
          _sectionSeparator(),
          _row(
            icon: Icons.logout,
            label: 'Logout',
            color: Colors.red,
            onTap: _showLogoutConfirmation,
          ),
        ],
      ),
    );
  }
}
