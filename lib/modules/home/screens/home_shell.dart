import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../widgets/app_bottom_nav.dart';

import 'discover_tab.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    DiscoverTab(),
    SearchScreen(),
    SavedScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screen = _pages[_index];

    final shouldApplyPadding = screen is DiscoverTab;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: shouldApplyPadding
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: screen,
                  )
                : screen,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
