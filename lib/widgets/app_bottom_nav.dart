import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  Widget _cartIconWithBadge({required bool selected}) {
    return AnimatedBuilder(
      animation: CartManager.instance,
      builder: (context, _) {
        final count = CartManager.instance.itemCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
            ),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onChanged,
      backgroundColor: const Color(0xFFF7F7F7),
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Saved',
        ),

        /// ✅ CART WITH BADGE
        NavigationDestination(
          icon: _cartIconWithBadge(selected: currentIndex == 3),
          label: 'Cart',
        ),

        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
