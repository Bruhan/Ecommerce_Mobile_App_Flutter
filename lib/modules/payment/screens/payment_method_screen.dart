import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import '../../../services/cart_manager.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
 
  final List<_SavedCard> _cards = [
    _SavedCard(id: 'c1', brand: 'VISA', last4: '9931', isDefault: true),
    _SavedCard(id: 'c2', brand: 'MC', last4: '5421'),
    _SavedCard(id: 'c3', brand: 'CARD', last4: '8765'),
  ];

  
  final List<_UpiEntry> _upiEntries = [];

  String? _selectedCardId;
  String? _selectedUpiId;
  final TextEditingController _upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCardId = _cards.isNotEmpty ? _cards.firstWhere((c) => c.isDefault, orElse: () => _cards.first).id : null;
  }

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  void _selectCard(String id) {
    setState(() {
      _selectedCardId = id;
      _selectedUpiId = null;
    });
  }

  void _selectUpi(String id) {
    setState(() {
      _selectedUpiId = id;
      _selectedCardId = null;
    });
  }

  Future<void> _openAddCard() async {
    try {
      final res = await Navigator.pushNamed(context, Routes.newCard);
      if (res is Map && res['newCard'] != null) {
        final m = res['newCard'] as Map;
        setState(() {
          final newCard = _SavedCard(
            id: m['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            brand: m['brand']?.toString() ?? 'CARD',
            last4: m['last4']?.toString() ?? '0000',
          );
          _cards.insert(0, newCard);
          _selectedCardId = newCard.id;
          _selectedUpiId = null;
        });
      }
    } catch (e, st) {
      debugPrint('openAddCard error: $e\n$st');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open Add Card screen')));
    }
  }

  Future<void> _openMoreUpi() async {
    try {
      final res = await Navigator.pushNamed(context, Routes.upi);
      if (res is Map && res['selectedUpi'] != null) {
        setState(() {
          _selectedUpiId = res['selectedUpi'].toString();
          _selectedCardId = null;
        });
      }
    } catch (e, st) {
      debugPrint('openMoreUpi error: $e\n$st');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open UPI options')));
    }
  }

  Future<void> _showAddUpiDialog() async {
    _upiController.text = '';
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add UPI ID'),
          content: TextField(
            controller: _upiController,
            decoration: const InputDecoration(hintText: 'eg. name@bank'),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final txt = _upiController.text.trim();
                if (txt.isEmpty || !txt.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid UPI ID')));
                  return;
                }
                Navigator.pop(ctx, txt);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (res != null && res.isNotEmpty) {
      setState(() {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        _upiEntries.insert(0, _UpiEntry(id: id, label: 'UPI', upi: res));
        _selectedUpiId = id;
        _selectedCardId = null;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI added')));
    }
  }

  Future<void> _applySelection() async {
    try {
      double amount = 0;
      try {
        amount = CartManager.instance.totalPrice;
      } catch (_) {
        amount = 0;
      }

      final applied = _selectedUpiId != null ? {'method': 'UPI', 'upiId': _selectedUpiId} : {'method': 'CARD', 'cardId': _selectedCardId};

      if (mounted) Navigator.of(context).pop({'applied': applied, 'amount': amount});
    } catch (e, st) {
      debugPrint('applySelection error: $e\n$st');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Apply failed: ${e.toString()}')));
    }
  }

  // --- Brand logo helper ---
  Widget _brandLogo(String brand) {
    // map brand to asset file names
    final key = brand.toLowerCase();
    String asset;
    if (key.contains('visa')) {
      asset = 'assets/images/visa.png';
    } else if (key.contains('mc') || key.contains('master') || key.contains('mastercard')) {
      asset = 'assets/images/mastercard.png';
    } else if (key.contains('amex') || key.contains('american')) {
      asset = 'assets/images/amex.png';
    } else {
      // not a known brand -> no asset
      asset = '';
    }

    if (asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: 56,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // fallback to plain brand text if image missing or fails
          return Container(
            width: 56,
            height: 40,
            alignment: Alignment.center,
            child: Text(brand, style: AppTextStyles.caption),
          );
        },
      );
    } else {
      return Container(
        width: 56,
        height: 40,
        alignment: Alignment.center,
        child: Text(brand, style: AppTextStyles.caption),
      );
    }
  }

  Widget _cardTile(_SavedCard c) {
    final selected = _selectedCardId == c.id;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // show brand logo or fallback
          _brandLogo(c.brand),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text('**** **** **** ${c.last4}', style: AppTextStyles.body)),
          GestureDetector(
            onTap: () => _selectCard(c.id),
            child: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? AppColors.primary : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _upiTile(_UpiEntry e) {
    final selected = _selectedUpiId == e.id;
    return InkWell(
      onTap: () => _selectUpi(e.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
          border: Border.all(color: selected ? (AppColors.primary ?? Colors.black) : Colors.grey.shade100, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text(e.label, style: AppTextStyles.caption),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(e.label, style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.xs),
            Text(e.upi, style: AppTextStyles.caption),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? AppColors.primary : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    try {
      total = CartManager.instance.totalPrice;
    } catch (_) {
      total = 0;
    }

    // fallback for missing h3 token
    final TextStyle _h3Fallback = AppTextStyles.body?.copyWith(fontSize: 16, fontWeight: FontWeight.w700) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Saved cards
            Text('Saved Cards', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (final c in _cards) _cardTile(c),

                  // Updated "Add New Card" appearance: pill, dark background like the mock
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton.icon(
                      onPressed: _openAddCard,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Card'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        textStyle: AppTextStyles.body,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // UPI header + More
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.smartphone)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text('UPI', style: AppTextStyles.body?.copyWith(fontWeight: FontWeight.w700))),
                    TextButton(onPressed: _openMoreUpi, child: Text('More', style: AppTextStyles.body?.copyWith(color: AppColors.primary))),
                  ]),

                  const SizedBox(height: AppSpacing.md),

                  // UPI tiles area
                  if (_upiEntries.isEmpty) ...[
                    // empty state: show a big add tile and a helpful message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('No saved UPI IDs', style: _h3Fallback),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Add your UPI ID to pay quickly using UPI apps.', style: AppTextStyles.caption),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: 220,
                          child: ElevatedButton.icon(
                            onPressed: _showAddUpiDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add UPI ID'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              textStyle: AppTextStyles.body,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ] else ...[
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(width: 2),
                          for (final u in _upiEntries) _upiTile(u),
                          // add tile at end
                          InkWell(
                            onTap: _showAddUpiDialog,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: AppSpacing.md),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.add, size: 28),
                                const SizedBox(height: AppSpacing.sm),
                                Text('Add UPI ID', style: AppTextStyles.body),
                              ]),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),
                ]),
              ),
            ),
          ]),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
          color: Colors.transparent,
          child: Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _applySelection,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Apply', style: AppTextStyles.body?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Demo models — replace with your app models/managers
class _SavedCard {
  final String id;
  final String brand;
  final String last4;
  final bool isDefault;
  _SavedCard({required this.id, required this.brand, required this.last4, this.isDefault = false});
}

class _UpiEntry {
  final String id;
  final String label;
  final String upi;
  _UpiEntry({required this.id, required this.label, required this.upi});
}
