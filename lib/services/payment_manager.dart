import 'package:flutter/foundation.dart';
import '../models/card_model.dart';

class PaymentManager {
  PaymentManager._internal() {
    final seeded = [
      CardModel(id: 'c1', brand: 'VISA', last4: '2512', expiry: '07/23', isDefault: true),
      CardModel(id: 'c2', brand: 'MC', last4: '5421', expiry: '02/26'),
      CardModel(id: 'c3', brand: 'VISA', last4: '9987', expiry: '11/25'),
    ];

    _cards.value = seeded;
    _selectedCard.value = seeded.firstWhere((c) => c.isDefault, orElse: () => seeded[0]);
  }

  static final PaymentManager _instance = PaymentManager._internal();
  static PaymentManager get instance => _instance;

  final ValueNotifier<List<CardModel>> _cards = ValueNotifier<List<CardModel>>([]);
  ValueNotifier<List<CardModel>> get cards => _cards;

  final ValueNotifier<CardModel?> _selectedCard = ValueNotifier<CardModel?>(null);
  ValueNotifier<CardModel?> get selectedCard => _selectedCard;

  void selectCard(String id) {
    final found = _cards.value.firstWhere((c) => c.id == id);
    _selectedCard.value = found;
  }

  void addCard(CardModel c, {bool makeDefault = false}) {
    final list = List<CardModel>.from(_cards.value);

    if (makeDefault) {
      list.replaceRange(0, list.length, list.map((e) => e.copyWith(isDefault: false)).toList());
    }

    list.add(c);
    _cards.value = list;

    if (makeDefault) _selectedCard.value = c;
  }

  void removeCard(String id) {
    final list = List<CardModel>.from(_cards.value)..removeWhere((c) => c.id == id);
    _cards.value = list;

    if (_selectedCard.value?.id == id) {
      _selectedCard.value = list.isNotEmpty ? list[0] : null;
    }
  }

  void setDefault(String id) {
    final list = _cards.value.map((c) => c.copyWith(isDefault: c.id == id)).toList();
    _cards.value = list;

    _selectedCard.value =
        list.firstWhere((c) => c.isDefault, orElse: () => list.isNotEmpty ? list[0] : null);
  }
}
