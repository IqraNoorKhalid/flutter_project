// lib/core/utils/product_match.dart
import '../../models/product.dart';

/// Maps a free-text list line to a catalog [Product] without false positives
/// from substring matches (e.g. "Rice" matching multiple items).
Product? matchCatalogProduct(String itemName, List<Product> catalog) {
  final needle = itemName.trim().toLowerCase();
  if (needle.isEmpty) return null;

  for (final p in catalog) {
    if (p.name.trim().toLowerCase() == needle) return p;
  }

  Product? best;
  var bestScore = 0;

  for (final p in catalog) {
    final pn = p.name.trim().toLowerCase();
    if (pn.isEmpty) continue;

    int score = 0;
    if (needle.contains(pn) || pn.contains(needle)) {
      score = pn.length > needle.length ? pn.length : needle.length;
    }

    if (score > bestScore) {
      bestScore = score;
      best = p;
    }
  }

  return best;
}

/// Unique catalog matches for all items on a list (skips items with no match).
List<Product> matchedProductsForListItems(List<String> itemNames, List<Product> catalog) {
  final out = <Product>[];
  final seen = <String>{};
  for (final name in itemNames) {
    final p = matchCatalogProduct(name, catalog);
    if (p != null && seen.add(p.id)) {
      out.add(p);
    }
  }
  return out;
}
