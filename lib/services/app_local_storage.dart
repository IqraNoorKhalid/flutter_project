// lib/services/app_local_storage.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/shopping_list.dart';

/// Persists shopping lists and tracked product IDs on device.
class AppLocalStorage {
  AppLocalStorage._();

  static const _listsKey = 'smart_cart_shopping_lists_v1';
  static const _trackedIdsKey = 'smart_cart_tracked_product_ids_v1';

  static Future<List<ShoppingList>?> loadShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_listsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => ShoppingList.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveShoppingLists(List<ShoppingList> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(lists.map((l) => l.toJson()).toList());
    await prefs.setString(_listsKey, encoded);
  }

  static Future<Set<String>> loadTrackedProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_trackedIdsKey);
    if (list == null) return {};
    return list.toSet();
  }

  static Future<void> saveTrackedProductIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_trackedIdsKey, ids.toList());
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listsKey);
    await prefs.remove(_trackedIdsKey);
  }
}
