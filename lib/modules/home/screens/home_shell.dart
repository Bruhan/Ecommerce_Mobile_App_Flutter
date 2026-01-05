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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

 
  final List<Widget> _pages = [
    DiscoverTab(),
    SearchScreen(),
    const SavedScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  
  Widget _buildTabNavigator(int tabIndex) {
    final Widget initialPage = _pages[tabIndex];

    return Navigator(
      key: _navigatorKeys[tabIndex],
      
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRouteName) {
        return [
          MaterialPageRoute(
            builder: (context) {
              // Preserve the same constrained/padding behavior you had previously.
              final shouldApplyPadding = initialPage is DiscoverTab;
              Widget page = initialPage;

              if (shouldApplyPadding) {
                page = Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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

      // Use your global RouteGenerator for any named routes pushed inside the tab.
      // That allows existing Navigator.pushNamed(...) calls to work as before,
      // but pushed onto the tab's own stack.
      onGenerateRoute: (RouteSettings settings) {
        // NOTE: RouteGenerator.generateRoute is the function used in main.dart.
        // It returns Route<dynamic>? and matches Navigator.onGenerateRoute signature.
        return RouteGenerator.generateRoute(settings);
      },
    );
  }
  //for future or other scenarios
  // Back button handling:
  // - If current tab navigator can pop => pop it
  // - Else if not on first tab => switch to first tab
  // - Else allow system to pop (exit app)
  Future<bool> _onWillPop() async {
    final currentNav = _navigatorKeys[_index].currentState;
    if (currentNav == null) return true;

    if (currentNav.canPop()) {
      currentNav.pop();
      return false; // we handled back
    }

    if (_index != 0) {
      setState(() => _index = 0);
      return false; // switched tab instead of exiting
    }

    return true; // allow app to exit
  }

  // When selecting a tab:
  // - If it's the same tab, pop to first route inside that tab.
  // - If it's a different tab, switch to it.
  void _selectTab(int i) {
    if (i == _index) {
      _navigatorKeys[i].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _index = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // IndexedStack keeps each tab's navigator (and its state) alive.
        body: IndexedStack(
          index: _index,
          children: List.generate(_pages.length, (i) => _buildTabNavigator(i)),
        ),

        // Reuse your AppBottomNav — it now controls the outer shell's selected tab.
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onChanged: (i) => _selectTab(i),
        ),
      ),
    );
  }
}
