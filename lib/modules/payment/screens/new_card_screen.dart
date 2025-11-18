import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../globals/theme.dart';
import '../../../../models/card_model.dart';
import '../../../../services/payment_manager.dart';

class NewCardScreen extends StatefulWidget {
  static const routeName = '/payment-new-card';

  const NewCardScreen({super.key});

  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();

  bool _makeDefault = false;
  final pm = PaymentManager.instance;

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  void _addCard() {
    if (!_formKey.currentState!.validate()) return;

    final digits = _numberCtrl.text.replaceAll(' ', '');
    final last4 = digits.substring(digits.length - 4);
    final brand = digits.startsWith('4')
        ? 'VISA'
        : digits.startsWith('5')
            ? 'MC'
            : 'Card';

    final card = CardModel(
      id: const Uuid().v4(),
      brand: brand,
      last4: last4,
      expiry: _expiryCtrl.text,
      isDefault: _makeDefault,
    );

    pm.addCard(card, makeDefault: _makeDefault);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 4)),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.check, size: 48, color: Colors.green),
              ),
              const SizedBox(height: 16),
              Text('Congratulations!', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text('Your new card has been added.', style: AppTextStyles.subtitle),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(card);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Thanks', style: AppTextStyles.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('New Card', style: AppTextStyles.h2), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Debit or Credit Card', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your card number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter card number';
                  if (v.replaceAll(' ', '').length < 12) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _expiryCtrl,
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter expiry';
                      if (!RegExp(r'^[0-1][0-9]\\/\\d{2}$').hasMatch(v)) {
                        return 'Invalid format';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvcCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'CVC',
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter CVC';
                        if (v.length < 3) return 'Invalid CVC';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Checkbox(
                      value: _makeDefault,
                      onChanged: (v) => setState(() => _makeDefault = v ?? false)),
                  Text('Make this a default card', style: AppTextStyles.body),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Add Card', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
