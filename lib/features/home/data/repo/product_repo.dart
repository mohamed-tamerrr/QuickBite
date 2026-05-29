import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/home/data/model/product_model.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  final String _getProductEndPoint = '/products';

  /// Get Products
  Future<List<ProductModel>>? getProduct() async {
    try {
      final response = await _apiService.get(
        _getProductEndPoint,
      );
      return (response['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
