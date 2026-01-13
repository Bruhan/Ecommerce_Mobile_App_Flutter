// lib/services/saved_manager.dart
import 'package:flutter/foundation.dart';
class SavedManager {
  SavedManager._internal();

  static final SavedManager instance = SavedManager._internal();


  final ValueNotifier<List<Map<String, dynamic>>> notifier = ValueNotifier<List<Map<String, dynamic>>>([]);

  List<Map<String, dynamic>> get items => List.unmodifiable(notifier.value);

  bool isSaved(String id) {
    return notifier.value.any((m) => m['id']?.toString() == id);
  }

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


  void removeById(String id) {
    final newList = notifier.value.where((m) => m['id']?.toString() != id).toList();
    notifier.value = newList;
  }

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
