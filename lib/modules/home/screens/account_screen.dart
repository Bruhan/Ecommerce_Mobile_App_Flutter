import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Account", style: AppTextStyles.h1),
    );
  }
}
