import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';
import 'package:ecommerce_mobile/globals/colors.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

class PersistentBottomNav extends StatefulWidget {
  final int initialIndex;
  final ValueListenable<int>? cartCountNotifier;

  const PersistentBottomNav({
    Key? key,
    this.initialIndex = 0,
    this.cartCountNotifier,
  }) : super(key: key);

  @override
  State<PersistentBottomNav> createState() => _PersistentBottomNavState();
}

class _PersistentBottomNavState extends State<PersistentBottomNav> {
  late int _selectedIndex;

  final List<_NavItem> _items = [
    _NavItem(label: 'Home', icon: Icons.home_rounded, routeName: Routes.home),
    _NavItem(label: 'You', icon: Icons.person_rounded, routeName: Routes.account),
    _NavItem(label: 'Wallet', icon: Icons.account_balance_wallet_rounded, routeName: Routes.wallet),
    _NavItem(label: 'Cart', icon: Icons.shopping_cart_rounded, routeName: Routes.cart),
    _NavItem(label: 'Menu', icon: Icons.menu_rounded, routeName: Routes.menu),
    _NavItem(label: 'Rufus', icon: Icons.support_agent_rounded, routeName: Routes.profile),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);

    final route = _items[index].routeName;

    if (route != null) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Amazon-style small drag handle
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -3),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final selected = i == _selectedIndex;
                final item = _items[i];
                final color = selected ? AppColors.primary : AppColors.greyDark;

                return Expanded(
                  child: InkWell(
                    onTap: () => _onTap(i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Icon(item.icon, size: 26, color: color),

                            // CART BADGE
                            if (item.label == 'Cart' && widget.cartCountNotifier != null)
                              ValueListenableBuilder<int>(
                                valueListenable: widget.cartCountNotifier!,
                                builder: (context, count, _) {
                                  if (count <= 0) return const SizedBox();
                                  final badgeText = count > 99 ? '99+' : count.toString();
                                  return Positioned(
                                    right: -6,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        badgeText,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.label,
                          style: AppTextStyles.caption.copyWith(color: color),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String? routeName;

  const _NavItem({
    required this.label,
    required this.icon,
    this.routeName,
  });
}
