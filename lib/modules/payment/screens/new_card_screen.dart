// lib/modules/payment/screens/new_card_screen.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class NewCardScreen extends StatefulWidget {
  const NewCardScreen({super.key});

  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberCtrl = TextEditingController();
  final TextEditingController _expiryCtrl = TextEditingController();
  final TextEditingController _cvcCtrl = TextEditingController();
  bool _isDefault = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cardNumberCtrl.addListener(_onCardNumberChanged);
    _expiryCtrl.addListener(_onExpiryChanged);
  }

  @override
  void dispose() {
    _cardNumberCtrl.removeListener(_onCardNumberChanged);
    _expiryCtrl.removeListener(_onExpiryChanged);
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  // ---- Helpers ----

  // Remove non-digits
  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  // Guess brand by starting digit(s)
  String _guessBrandFromNumber(String v) {
    final s = _digitsOnly(v);
    if (s.isEmpty) return 'CARD';
    if (s.startsWith('4')) return 'VISA';
    if (s.startsWith('5')) return 'MC';
    if (s.startsWith('34') || s.startsWith('37')) return 'AMEX';
    return 'CARD';
  }

  // Return max digits for brand (without spaces)
  int _maxDigitsForBrand(String brand) {
    if (brand == 'AMEX') return 15;
    return 16; // Visa / MasterCard / default
  }

  // Format card number in groups and enforce length
  void _onCardNumberChanged() {
    final raw = _cardNumberCtrl.text;
    final digits = _digitsOnly(raw);
    final brand = _guessBrandFromNumber(digits);

    final maxDigits = _maxDigitsForBrand(brand);

    // trim to maxDigits
    final limited = digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;

    String formatted;
    if (brand == 'AMEX') {
      // Amex grouping: 4 - 6 - 5
      final part1 = limited.length >= 4 ? limited.substring(0, 4) : limited;
      final rest1 = limited.length > 4 ? limited.substring(4) : '';
      final part2 = rest1.length > 6 ? rest1.substring(0, 6) : rest1;
      final rest2 = rest1.length > 6 ? rest1.substring(6) : '';
      formatted = [part1, if (part2.isNotEmpty) part2, if (rest2.isNotEmpty) rest2].join(' ');
    } else {
      // standard 4-4-4-4 grouping
      final parts = <String>[];
      for (var i = 0; i < limited.length; i += 4) {
        final end = (i + 4 > limited.length) ? limited.length : i + 4;
        parts.add(limited.substring(i, end));
      }
      formatted = parts.join(' ');
    }

    // Avoid infinite loop: only update if changed
    if (formatted != raw) {
      _cardNumberCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );

      // update CVC max length if needed
      final cvcMax = (brand == 'AMEX') ? 4 : 3;
      // if current cvc longer than new max, truncate
      if (_cvcCtrl.text.length > cvcMax) {
        _cvcCtrl.text = _cvcCtrl.text.substring(0, cvcMax);
      }
      setState(() {}); // to refresh any brand-dependent UI
    }
  }

  // Expiry formatting: auto-insert slash after two digits and limit to 5 chars (MM/YY)
  void _onExpiryChanged() {
    final raw = _expiryCtrl.text;
    final digits = _digitsOnly(raw);

    String formatted = digits;
    if (digits.length >= 3) {
      formatted = digits.substring(0, 2) + '/' + digits.substring(2, digits.length > 4 ? 4 : digits.length);
    } else if (digits.length >= 1 && digits.length <= 2) {
      formatted = digits;
    }

    if (formatted.length > 5) formatted = formatted.substring(0, 5);

    if (formatted != raw) {
      _expiryCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _extractLast4(String v) {
    final cleaned = _digitsOnly(v);
    if (cleaned.length >= 4) return cleaned.substring(cleaned.length - 4);
    return cleaned;
  }

  // ---- Validation ----

  String? _validateCardNumber(String? v) {
    if (v == null) return 'Required';
    final cleaned = _digitsOnly(v);
    final brand = _guessBrandFromNumber(cleaned);
    final max = _maxDigitsForBrand(brand);
    if (cleaned.length < (brand == 'AMEX' ? 15 : 13)) {
      return 'Enter a valid card number';
    }
    if (cleaned.length > max) return 'Invalid card number';
    // Optionally: Luhn check could be added here
    return null;
  }

  String? _validateExpiry(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final match = RegExp(r'^\s*(0[1-9]|1[0-2])\/?([0-9]{2})\s*$').firstMatch(v);
    if (match == null) return 'Use MM/YY';

    final month = int.tryParse(match.group(1) ?? '') ?? 0;
    final yearTwo = int.tryParse(match.group(2) ?? '') ?? 0;
    if (month < 1 || month > 12) return 'Invalid month';

    // Check expiry not in past
    final now = DateTime.now();
    final currentTwoDigit = now.year % 100;
    final currentMonth = now.month;

    if (yearTwo < currentTwoDigit) return 'Card expired';
    if (yearTwo == currentTwoDigit && month < currentMonth) return 'Card expired';
    return null;
  }

  String? _validateCvc(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final cleaned = _digitsOnly(v);
    final brand = _guessBrandFromNumber(_cardNumberCtrl.text);
    final needed = (brand == 'AMEX') ? 4 : 3;
    if (cleaned.length < needed) return 'Invalid CVC';
    if (cleaned.length > needed) return 'Invalid CVC';
    return null;
  }

  Future<void> _onAddCardPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // simulate processing
    await Future.delayed(const Duration(milliseconds: 600));

    final cardNum = _cardNumberCtrl.text.trim();
    final expiry = _expiryCtrl.text.trim();
    final last4 = _extractLast4(cardNum);
    final brand = _guessBrandFromNumber(cardNum);

    final newCard = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'brand': brand,
      'last4': last4,
      'expiry': expiry,
      'default': _isDefault,
    };

    if (mounted) {
      Navigator.pop(context, {'newCard': newCard});
    }

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final brand = _guessBrandFromNumber(_cardNumberCtrl.text);
    final cvcMax = (brand == 'AMEX') ? 4 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Add Debit or Credit Card', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.md),

              // Card number
              TextFormField(
                controller: _cardNumberCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Card number',
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(brand, style: AppTextStyles.caption),
                  ),
                ),
                validator: _validateCardNumber,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                  LengthLimitingTextInputFormatter(23), // safe limit including spaces
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // expiry and cvc row
              Row(children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _expiryCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      filled: true,
                      fillColor: AppColors.bg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: _validateExpiry,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _cvcCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'CVC',
                      filled: true,
                      fillColor: AppColors.bg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: _validateCvc,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(cvcMax),
                    ],
                    obscureText: true,
                  ),
                ),
              ]),

              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Checkbox(value: _isDefault, onChanged: (v) => setState(() => _isDefault = v ?? false)),
                  const SizedBox(width: 4),
                  Expanded(child: Text('Make this as a default card', style: AppTextStyles.body)),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Add card button large, pill-like
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _onAddCardPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isProcessing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Add Card'),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
            ]),
          ),
        ),
      ),
    );
  }
}
