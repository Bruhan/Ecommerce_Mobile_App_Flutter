// lib/modules/checkout/screens/apply_coupon_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../globals/text_styles.dart';
import '../../../globals/theme.dart';

class ApplyCouponScreen extends StatefulWidget {
  const ApplyCouponScreen({Key? key}) : super(key: key);

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _isApplying = false;

  // Only uppercase letters and numbers
  final _allow = FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _ctrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a coupon code')));
      return;
    }

    setState(() => _isApplying = true);

    // Simulate lookup / validation (replace with real API call)
    await Future.delayed(const Duration(milliseconds: 700));

    // Demo rules:
    // - If code length >= 4, apply fixed discount 50
    // - If code == 'FLAT100' apply 100
    double discount = 0;
    if (code == 'FLAT100') discount = 100;
    else if (code.length >= 4) discount = 50;
    else discount = 0;

    setState(() => _isApplying = false);

    if (discount > 0) {
      // Pop returning coupon info to caller
      Navigator.of(context).pop({'code': code, 'discount': discount});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon or no discount')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If your AppTextStyles.h3 doesn't exist, use h2 as fallback.
    final titleStyle = AppTextStyles.h2;

    return Scaffold(
      appBar: AppBar(title: const Text('Apply Coupon')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter coupon code', style: titleStyle.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _ctrl,
              inputFormatters: [_allow, LengthLimitingTextInputFormatter(20)],
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(hintText: 'E.g. FLAT100', border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.md))),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isApplying ? null : _apply,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md))),
                child: _isApplying ? const CircularProgressIndicator(color: Colors.white) : Text('Apply', style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Available offers', style: titleStyle.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            // Dummy coupon hints
            Card(
              child: ListTile(
                title: const Text('FLAT100'),
                subtitle: const Text('₹100 off on orders above ₹1000'),
                trailing: TextButton(
                  onPressed: () {
                    _ctrl.text = 'FLAT100';
                  },
                  child: const Text('Use'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('SAVE50'),
                subtitle: const Text('₹50 off with minimum purchase'),
                trailing: TextButton(
                  onPressed: () {
                    _ctrl.text = 'SAVE50';
                  },
                  child: const Text('Use'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
