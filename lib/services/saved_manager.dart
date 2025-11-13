// lib/services/saved_manager.dart
import 'package:flutter/foundation.dart';

/// Simple singleton manager for "saved" items.
/// Uses a ValueNotifier so UI can listen and rebuild automatically.
/// Items are stored as Map<String, dynamic> (to match your current code).
class SavedManager {
  SavedManager._internal();

  static final SavedManager instance = SavedManager._internal();

  // Exposed notifier that widgets will listen to.
  final ValueNotifier<List<Map<String, dynamic>>> notifier = ValueNotifier<List<Map<String, dynamic>>>([]);

  /// Returns a copy of current items
  List<Map<String, dynamic>> get items => List.unmodifiable(notifier.value);

  /// Check if an item (by id) is currently saved
  bool isSaved(String id) {
    return notifier.value.any((m) => m['id']?.toString() == id);
  }

  /// Add item (if not already present)
  void add(Map<String, dynamic> item) {
    final id = item['id']?.toString() ?? item['title']?.toString();
    if (id == null) return;
    if (isSaved(id)) return;
    final newList = List<Map<String, dynamic>>.from(notifier.value);
    final toAdd = Map<String, dynamic>.from(item);
    toAdd['id'] = id;
    newList.add(toAdd);
    notifier.value = newList;
  }

  /// Remove item by id
  void removeById(String id) {
    final newList = notifier.value.where((m) => m['id']?.toString() != id).toList();
    notifier.value = newList;
  }

  /// Toggle: add if not saved, remove if saved
  void toggle(Map<String, dynamic> item) {
    final id = item['id']?.toString() ?? item['title']?.toString();
    if (id == null) return;
    if (isSaved(id)) {
      removeById(id);
    } else {
      add(item);
    }
  }

  /// Clear all saved (useful for debug)
  void clear() {
    notifier.value = [];
  }
}
