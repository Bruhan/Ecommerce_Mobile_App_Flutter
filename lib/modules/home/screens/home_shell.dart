import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../widgets/app_bottom_nav.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';
import 'discover_tab.dart';
import 'search_screen.dart';
import 'package:ecommerce_mobile/modules/home/screens/saved_screen.dart';
import 'package:ecommerce_mobile/modules/cart/screens/cart_screen.dart';
import 'account_screen.dart';
import 'package:ecommerce_mobile/routes/route_generator.dart';
import 'package:ecommerce_mobile/services/cart_manager.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(5, (_) => GlobalKey<NavigatorState>());

  final List<Widget> _pages = const [
    DiscoverTab(),
    SearchScreen(),
    SavedScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  Widget _buildTabNavigator(int tabIndex) {
    final Widget initialPage = _pages[tabIndex];

    return Navigator(
      key: _navigatorKeys[tabIndex],
      onGenerateInitialRoutes: (navigator, initialRouteName) {
        return [
          MaterialPageRoute(
            builder: (context) {
              final shouldApplyPadding = initialPage is DiscoverTab;
              Widget page = initialPage;

              if (shouldApplyPadding) {
                page = Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: page,
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: page,
                ),
              );
            },
          )
        ];
      },
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  Future<bool> _onWillPop() async {
    final currentNav = _navigatorKeys[_index].currentState;
    if (currentNav == null) return true;

    if (currentNav.canPop()) {
      currentNav.pop();
      return false;
    }

    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }

    return true;
  }

  void _selectTab(int i) {
    if (i == _index) {
      _navigatorKeys[i].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() => _index = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: List.generate(_pages.length, (i) => _buildTabNavigator(i)),
        ),

        /// 🔑 KEY FIX:
        /// Rebuild bottom navigation whenever cart changes
        bottomNavigationBar: AnimatedBuilder(
          animation: CartManager.instance,
          builder: (context, _) {
            return AppBottomNav(
              currentIndex: _index,
              onChanged: (i) => _selectTab(i),
            );
          },
        ),
      ),
    );
  }
}
