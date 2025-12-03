import 'package:ecommerce_mobile/network/api_service.dart';

class ProductService {
  final ApiService _api = ApiService();

  /// Fetch all products (with optional dynamic endpoint)
  Future<dynamic> getAllProducts(String endpoint) async {
    return await _api.get(endpoint);
  }

  /// Fetch single product by ID (optional)
  Future<dynamic> getProductById(String id) async {
    return await _api.get("/products/$id");
  }
}
