// lib/modules/home/screens/account_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'my_details_screen.dart';
import 'addresses_screen.dart';
import 'saved_screen.dart';
import 'search_screen.dart';
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/modules/orders/screens/orders_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // mutable so we can update when MyDetails returns
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  String? _readStringFromMap(dynamic map, List<String> possibleKeys) {
    if (map is! Map) return null;
    for (final key in possibleKeys) {
      if (map.containsKey(key) && map[key] != null) return map[key].toString();
    }
    final lowerMapKeys = map.keys.map((k) => k.toString().toLowerCase()).toList();
    for (final pk in possibleKeys) {
      final idx = lowerMapKeys.indexOf(pk.toLowerCase());
      if (idx >= 0) {
        final realKey = map.keys.elementAt(idx);
        final v = map[realKey];
        if (v != null) return v.toString();
      }
    }
    return null;
  }

  Future<void> _openMyDetails() async {
    final result = await Navigator.push<Map<dynamic, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const MyDetailsScreen()),
    );

    // debug print
    // ignore: avoid_print
    print('[AccountScreen] MyDetails returned -> $result');

    if (result == null) return;

    final name = _readStringFromMap(result, ['name', 'fullName', 'full_name', 'fullname']);
    final email = _readStringFromMap(result, ['email', 'emailAddress', 'email_address', 'email']);

    if ((name != null && name.isNotEmpty) || (email != null && email.isNotEmpty)) {
      setState(() {
        if (name != null && name.isNotEmpty) _name = name;
        if (email != null && email.isNotEmpty) _email = email;
      });
    }
  }

  Widget _row({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconBg,
  }) {
    final bg = iconBg ?? AppColors.bg;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile header
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Icon(Icons.person, size: 40, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: AppTextStyles.h2),
                        const SizedBox(height: 6),
                        Text(_email, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Options card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Column(
                    children: [
                      _row(
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrdersScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1),

                      _row(
                        icon: Icons.person_outline,
                        label: 'My Details',
                        onTap: _openMyDetails,
                      ),
                      const Divider(height: 1),

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
                      const Divider(height: 1),

                      // PAYMENT METHODS row (replaces Saved Items)
                      _row(
                        icon: Icons.credit_card_outlined,
                        label: 'Payment Methods',
                        onTap: () {
                          // Preferred: named route if you registered Routes.paymentMethods
                          // Fallback: show a helpful message and open SavedScreen (so user still sees content)
                          try {
                            Navigator.pushNamed(context, Routes.paymentMethods);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Payment Methods not available — opening Saved Items as fallback')),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SavedScreen()),
                            );
                          }
                        },
                      ),
                      const Divider(height: 1),

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

              Text('Settings', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.md),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
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
                      const Divider(height: 1),
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
