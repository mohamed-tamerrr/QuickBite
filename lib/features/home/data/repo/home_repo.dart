import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/core/network/api_service.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/home/data/model/product_model.dart';
import 'package:QuickBite/features/home/data/model/topping_model.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  final String _getProductEndPoint = '/products';
  final String _getToppingsEndPoint = '/toppings';
  final String _getSideOptionsEndPoint = '/side-options';
  final String _addToCartEndPoint = '/cart/add';

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

  /// Add To Cart
  Future<void> addToCart(CartRequestModel cartData) async {
    try {
      final res = await _apiService.post(
        _addToCartEndPoint,
        cartData.toJson(),
      );

      if (res is Failure) {
        throw res;
      }

      if (res is Map<String, dynamic> &&
          res['code'] != null &&
          res['code'] != 200) {
        throw Failure(
          errorMassage:
              res['message'] ?? 'Unable to add item to cart',
        );
      }
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }
}
