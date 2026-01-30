// lib/services/saved_manager.dart
import 'package:flutter/foundation.dart';

class SavedManager {
  SavedManager._internal();

  static final SavedManager instance = SavedManager._internal();

  /// Internal notifier
  final ValueNotifier<List<Map<String, dynamic>>> _notifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  /// Public read-only notifier
  ValueNotifier<List<Map<String, dynamic>>> get notifier => _notifier;

  /// Immutable list of saved items
  List<Map<String, dynamic>> get items => List.unmodifiable(_notifier.value);

  /// Check if item is saved using stable id
  bool isSaved(String id) {
    return _notifier.value.any(
      (item) => item['id']?.toString() == id,
    );
  }

  /// Add item to saved list
  /// ❗ item MUST contain a valid `id`
  void add(Map<String, dynamic> item) {
    final id = item['id']?.toString();

    if (id == null || id.isEmpty) {
      debugPrint(
        'SavedManager.add ❌ Item missing valid `id`. Item not saved.',
      );
      return;
    }

    if (isSaved(id)) return;

    final List<Map<String, dynamic>> updated =
        List<Map<String, dynamic>>.from(_notifier.value);

    updated.add(Map<String, dynamic>.from(item));

    _notifier.value = updated;
  }

  /// Remove item by id
  void removeById(String id) {
    final List<Map<String, dynamic>> updated = _notifier.value
        .where(
          (item) => item['id']?.toString() != id,
        )
        .toList();

    _notifier.value = updated;
  }

  /// Toggle saved state
  /// ❗ item MUST contain a valid `id`
  void toggle(Map<String, dynamic> item) {
    final id = item['id']?.toString();

    if (id == null || id.isEmpty) {
      debugPrint(
        'SavedManager.toggle ❌ Item missing valid `id`.',
      );
      return;
    }

    if (isSaved(id)) {
      removeById(id);
    } else {
      add(item);
    }
  }

  /// Clear all saved items (debug / logout use)
  void clear() {
    _notifier.value = [];
  }
}
