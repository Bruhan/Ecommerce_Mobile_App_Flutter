import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../globals/text_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool general = true;
  bool sound = true;
  bool vibrate = false;
  bool offers = true;
  bool promo = false;
  bool payments = false;
  bool cashback = true;
  bool updates = false;
  bool services = true;
  bool tips = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          _item('General Notifications', general,
              (v) => setState(() => general = v)),
          _item('Sound', sound, (v) => setState(() => sound = v)),
          _item('Vibrate', vibrate, (v) => setState(() => vibrate = v)),
          _item('Special Offers', offers, (v) => setState(() => offers = v)),
          _item('Promo & Discounts', promo, (v) => setState(() => promo = v)),
          _item('Payments', payments, (v) => setState(() => payments = v)),
          _item('Cashback', cashback, (v) => setState(() => cashback = v)),
          _item('App Updates', updates, (v) => setState(() => updates = v)),
          _item('New Service Available', services,
              (v) => setState(() => services = v)),
          _item('New Tips Available', tips, (v) => setState(() => tips = v)),
        ],
      ),
    );
  }

  Widget _item(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body,
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.buttonGreen,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
