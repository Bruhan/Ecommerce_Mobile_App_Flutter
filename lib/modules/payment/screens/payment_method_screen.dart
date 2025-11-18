// lib/modules/payment/screens/payment_method_screen.dart
import 'package:flutter/material.dart';

// relative imports (safer inside the same repo)
import '../../../globals/theme.dart';
import '../../../models/card_model.dart';
import '../../../services/payment_manager.dart';
import 'new_card_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  static const routeName = '/payment-method';
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final pm = PaymentManager.instance;
  CardModel? selectedCard;

  @override
  void initState() {
    super.initState();
    selectedCard = pm.selectedCard.value ?? _firstDefaultFromCards();
  }

  CardModel? _firstDefaultFromCards() {
    final list = pm.cards.value;
    if (list.isEmpty) return null;
    return list.firstWhere((c) => c.isDefault, orElse: () => list.first);
  }

  void _handleSelect(CardModel card) {
    // update manager and local state
    pm.selectCard(card.id);
    pm.setDefault(card.id);
    setState(() => selectedCard = pm.selectedCard.value ?? _firstDefaultFromCards());
  }

  Widget _buildCardTile(CardModel card) {
    final isSelected = selectedCard?.id == card.id;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(card.brand, style: AppTextStyles.body),
          const SizedBox(width: 16),
          Expanded(child: Text('**** **** **** ${card.last4}', style: AppTextStyles.caption)),
          if (card.isDefault)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bg ?? Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Default', style: AppTextStyles.caption),
            ),
          GestureDetector(
            onTap: () => _handleSelect(card),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: isSelected ? (AppColors.primary ?? Colors.black) : Colors.transparent,
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<CardModel>>(
          valueListenable: pm.cards,
          builder: (context, cards, _) {
            final hasCards = cards.isNotEmpty;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saved Cards', style: AppTextStyles.body),
                const SizedBox(height: 12),

                if (!hasCards)
                  const Expanded(child: Center(child: Text('No saved cards yet.')))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: cards.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, idx) => _buildCardTile(cards[idx]),
                    ),
                  ),

                const SizedBox(height: 12),

                // Add new card
                GestureDetector(
                  onTap: () async {
                    final added = await Navigator.push<bool?>(
                      context,
                      MaterialPageRoute(builder: (_) => NewCardScreen()),
                    );

                    if (added == true) {
                      // refresh selection from manager
                      setState(() => selectedCard = pm.selectedCard.value ?? _firstDefaultFromCards());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card added')));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text('Add New Card', style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Return the selected card (or null) to the caller
                      Navigator.pop(context, selectedCard);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('Apply', style: AppTextStyles.caption),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
