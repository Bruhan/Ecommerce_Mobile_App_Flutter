import 'package:flutter/foundation.dart';
import '../models/card_model.dart';

class PaymentManager {
  PaymentManager._internal() {
    final seeded = <CardModel>[
      CardModel(id: 'c1', brand: 'VISA', last4: '2512', expiry: '07/23', isDefault: true),
      CardModel(id: 'c2', brand: 'MC', last4: '5421', expiry: '02/26'),
      CardModel(id: 'c3', brand: 'VISA', last4: '9987', expiry: '11/25'),
    ];

    _cards.value = seeded;

    // Safe selection: if a default exists pick it; otherwise choose first if any; otherwise null.
    CardModel? selected;
    if (seeded.isNotEmpty) {
      try {
        selected = seeded.firstWhere((c) => c.isDefault);
      } catch (_) {
        selected = seeded[0];
      }
    } else {
      selected = null;
    }
    _selectedCard.value = selected;
  }

  static final PaymentManager _instance = PaymentManager._internal();
  static PaymentManager get instance => _instance;

  final ValueNotifier<List<CardModel>> _cards = ValueNotifier<List<CardModel>>([]);
  ValueNotifier<List<CardModel>> get cards => _cards;

  final ValueNotifier<CardModel?> _selectedCard = ValueNotifier<CardModel?>(null);
  ValueNotifier<CardModel?> get selectedCard => _selectedCard;

  /// Return the default card if available, otherwise the first card, otherwise null.
  CardModel? getDefaultCard() {
    final list = _cards.value;
    if (list.isEmpty) return null;
    try {
      return list.firstWhere((c) => c.isDefault);
    } catch (_) {
      return list[0];
    }
  }

  /// Select a card by id. If id not found, selection is unchanged.
  void selectCard(String id) {
    final found = _cards.value.where((c) => c.id == id);
    if (found.isNotEmpty) {
      _selectedCard.value = found.first;
    }
  }

  /// Add a card. If [makeDefault] true, clear existing defaults and set this as selected.
  void addCard(CardModel c, {bool makeDefault = false}) {
    final list = List<CardModel>.from(_cards.value);

    if (makeDefault) {
      final cleared = list.map((e) => e.copyWith(isDefault: false)).toList();
      list
        ..clear()
        ..addAll(cleared);
    }

    list.add(c);
    _cards.value = list;

    if (makeDefault) {
      _selectedCard.value = c;
    } else if (_selectedCard.value == null) {
      // If there was no selection, set the newly added card.
      _selectedCard.value = c;
    }
  }

  /// Remove a card by id. If it was the selected one, pick a fallback or null.
  void removeCard(String id) {
    final list = List<CardModel>.from(_cards.value)..removeWhere((c) => c.id == id);
    _cards.value = list;

    if (_selectedCard.value?.id == id) {
      _selectedCard.value = list.isNotEmpty ? list[0] : null;
    }
  }

  /// Set a card as default. Updates the list and the selectedCard safely.
  void setDefault(String id) {
    final list = _cards.value;
    if (list.isEmpty) {
      _selectedCard.value = null;
      _cards.value = list;
      return;
    }

    final updated = list.map((c) => c.copyWith(isDefault: c.id == id)).toList();
    _cards.value = updated;

    // pick default if exists, otherwise first element
    CardModel selected;
    try {
      selected = updated.firstWhere((c) => c.isDefault);
    } catch (_) {
      selected = updated[0];
    }
    _selectedCard.value = selected;
  }
}
