import 'package:ecommerce_mobile/network/api_service.dart';
import 'package:ecommerce_mobile/globals/globals.dart';

class ProductFilterService {
  final ApiService _apiService = ApiService();

  // Fetches the academic categories for the filter sheet
  Future<List<String>> fetchAcademics() async {
    try {
      // Endpoint based on your Swagger documentation requirements
      final response = await _apiService.get('/academic/all?plantId=${Globals.plant}');
      
      if (response is List) {
        // Map the response to a list of strings
        return response.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching academics: $e");
      return [];
    }
  }
}