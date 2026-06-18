import 'package:QuickBite/core/network/api_service.dart';
import 'package:QuickBite/features/home/data/model/product_model.dart';
import 'package:QuickBite/features/home/data/model/topping_model.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  final String _getProductEndPoint = '/products';
  final String _getToppingsEndPoint = '/toppings';
  final String _getSideOptionsEndPoint = '/side-options';

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

  /// Get Toppings
  Future<List<ToppingModel>>? getToppings() async {
    try {
      final response = await _apiService.get(
        _getToppingsEndPoint,
      );
      return (response['data'] as List)
          .map((e) => ToppingModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  /// get Options
  Future<List<ToppingModel>> getOptions() async {
    try {
      final response = await _apiService.get(
        _getSideOptionsEndPoint,
      );
      return (response['data'] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
