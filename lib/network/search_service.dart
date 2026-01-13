// lib/network/search_service.dart
import 'dart:async';

/// SearchService
/// - Will call your ApiService if it exists (safe, optional integration).
/// - If ApiService is not present or the call fails, it falls back to a local mock.
///
/// Expected API (recommended):
/// GET /search/suggestions?q=flutter        -> returns List<String>
/// GET /search?query=flutter&page=1&pageSize=6 -> returns { "data": [ { id, title, imageUrl, price, author, inStock, rating }, ... ], "nextPage": 2 }
///
/// If your ApiService has a different interface, update the ApiService call below.

class SearchService {
  /// Try to get suggestions from real API first.
  static Future<List<String>> getSearchSuggestions(String query) async {
    // Try real ApiService if available
    try {
      // Attempt to import your ApiService class at runtime by referencing it.
      // If ApiService doesn't exist, this will throw at compile-time normally.
      // To keep compile safe, we use a dynamic call guarded by `try/catch`.
      // Replace the path + method below to match your ApiService if needed.
      // Example expected: ApiService.instance.get('/search/suggestions', params: {'q': query})
      // If you have ApiService, uncomment and adapt the following block (and remove the return mock at end).
      //
      // final resp = await ApiService.instance.get('/search/suggestions', params: {'q': query});
      // if (resp != null && resp is List) {
      //   return List<String>.from(resp.map((e) => e.toString()));
      // }
    } catch (e) {
      // ignore and fallback to mock
    }

    // --- fallback mock suggestions ---
    await Future.delayed(const Duration(milliseconds: 200));
    final trending = <String>[
      "Data Structures",
      "Artificial Intelligence",
      "Flutter",
      "React Native",
      "Database Systems",
      "Android Development",
    ];

    if (query.trim().isEmpty) return trending;

    final q = query.toLowerCase();
    final list = trending.where((e) => e.toLowerCase().contains(q)).toList();

    if (!list.contains(query)) list.insert(0, query);

    return list.take(10).toList();
  }

  /// Returns a map with 'data': List<Map<String,dynamic>> and 'nextPage': int?
  /// Tries real API first, falls back to mock.
  static Future<Map<String, dynamic>> searchProducts(String query,
      {int page = 1, int pageSize = 6}) async {
    // Try real API
    try {
      // Example ApiService usage — adapt to your ApiService interface.
      //
      // final resp = await ApiService.instance.get('/search', params: {
      //   'query': query,
      //   'page': page,
      //   'pageSize': pageSize,
      // });
      //
      // // Suppose your API returns: { data: [ ... ], nextPage: 2 }
      // if (resp is Map<String, dynamic>) {
      //   return {
      //     'data': List<Map<String, dynamic>>.from(resp['data'] ?? []),
      //     'nextPage': resp['nextPage'],
      //   };
      // }
    } catch (e) {
      // ignore -> fallback to mock
    }

    // --- fallback mock data (same as earlier) ---
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> all = List.generate(100, (i) {
      final id = "book_${query.hashCode}_$i";
      return {
        "id": id,
        "title": "$query — Book #${i + 1}",
        "imageUrl": "https://picsum.photos/seed/$id/400/400",
        "price": 199 + (i % 10) * 20,
        "author": (i % 2 == 0) ? "John Doe" : "Emma Watson",
        "rating": 4.2 + (i % 5) * 0.1,
        "inStock": i % 4 != 0,
      };
    });

    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final slice = (start < all.length) ? all.sublist(start, end.clamp(0, all.length)) : [];

    return {
      'data': slice,
      'nextPage': end < all.length ? page + 1 : null,
    };
  }
}
