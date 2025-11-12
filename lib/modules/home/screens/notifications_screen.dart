import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('Notifications'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
            children: [
              const _SectionHeader('Today'),
              _tile(
                icon: Icons.local_offer_outlined,
                title: '30% Special Discount!',
                subtitle: 'Special promotion only valid today.',
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              const _SectionHeader('Yesterday'),
              _tile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Top Up E-wallet Successfully!',
                subtitle: 'You have top up your e-wallet.',
              ),
              const Divider(),
              _tile(
                icon: Icons.location_pin,
                title: 'New Service Available!',
                subtitle: 'Now you can track order in real-time.',
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              const _SectionHeader('June 7, 2023'),
              _tile(
                icon: Icons.credit_card_outlined,
                title: 'Credit Card Connected!',
                subtitle: 'Credit card has been linked.',
              ),
              const Divider(),
              _tile(
                icon: Icons.person_outline,
                title: 'Account Setup Successfully!',
                subtitle: 'Your account has been created.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: Colors.black87),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
