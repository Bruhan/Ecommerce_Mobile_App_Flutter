// lib/modules/payment/screens/upi_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

import '../../../globals/text_styles.dart';

class UpiPaymentScreen extends StatefulWidget {
  const UpiPaymentScreen({Key? key}) : super(key: key);

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  final TextEditingController _upiController = TextEditingController();
  final List<String> _savedUpis = ['john.doe@okaxis', 'me@ibl'];
  String? _selectedUpi;

  @override
  void initState() {
    super.initState();
    if (_savedUpis.isNotEmpty) _selectedUpi = _savedUpis.first;
  }

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  void _verifyAndSaveUpi() {
    final text = _upiController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter UPI ID')));
      return;
    }
    if (!text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid UPI ID')));
      return;
    }

    setState(() {
      if (!_savedUpis.contains(text)) _savedUpis.insert(0, text);
      _selectedUpi = text;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI verified and saved')));
    _upiController.clear();
  }

  void _applySelectedUpi() {
    if (_selectedUpi == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select an UPI ID')));
      return;
    }
    Navigator.of(context).pop({'selectedUpi': _selectedUpi});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saved Payment Options', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView(
                  children: [
                    for (final upi in _savedUpis)
                      InkWell(
                        onTap: () => setState(() => _selectedUpi = upi),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle_outlined, size: 28),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(child: Text(upi, style: AppTextStyles.body)),
                              if (_selectedUpi == upi)
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Add new UPI ID', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _upiController,
                            decoration: InputDecoration(
                              hintText: 'Enter your UPI ID (eg. name@bank)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: _verifyAndSaveUpi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: Text('Verify', style: AppTextStyles.body?.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 160),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md + 12),
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _applySelectedUpi,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Use this UPI', style: AppTextStyles.body?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
