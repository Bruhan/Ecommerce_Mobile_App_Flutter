// import 'package:flutter/material.dart';
// import 'package:ecommerce_mobile/globals/theme.dart';
// import 'package:ecommerce_mobile/widgets/app_bottom_nav.dart';
// import 'discover_tab.dart';
// import 'search_screen.dart';
// import 'saved_screen.dart';
// import 'cart_screen.dart';
// import 'account_screen.dart';

// /// Holds the 5 tabs + bottom navigation like your Figma.
// class HomeShell extends StatefulWidget {
//   const HomeShell({super.key});

//   @override
//   State<HomeShell> createState() => _HomeShellState();
// }

// class _HomeShellState extends State<HomeShell> {
//   int _index = 0;

//   final _pages = const [
//     DiscoverTab(),
//     SearchScreen(),
//     SavedScreen(),
//     CartScreen(),
//     AccountScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 420),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
//               child: _pages[_index],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: AppBottomNav(
//         currentIndex: _index,
//         onChanged: (i) => setState(() => _index = i),
//       ),
//     );
//   }
// }
