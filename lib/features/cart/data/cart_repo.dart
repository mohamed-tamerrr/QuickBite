import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/cart/data/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();

  final String _addToCartEndPoint = '/cart/add';
  final String _getCartEndPoint = '/cart';
  final String _deleteCartEndPoint = '/cart/remove/';

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

  /// Get To Cart
  Future<GetCartResponse> getCartItems() async {
    try {
      final res = await _apiService.get(_getCartEndPoint);

      if (res is Failure) {
        throw res;
      }

      if (res is Map<String, dynamic> &&
          res['code'] != null &&
          res['code'] != 200) {
        throw Failure(
          errorMassage:
              res['message'] ?? 'Unable to fetch cart items',
        );
      }

      return GetCartResponse.fromJson(res);
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  /// Delete Cart Item
  Future<void> removeCartItem(int id) async {
    try {
      final res = await _apiService.delete(
        '/cart/remove/$id',
        {},
      );

      if (res is Failure) {
        throw res;
      }

      if (res is! Map<String, dynamic>) {
        throw Failure(
          errorMassage:
              'Unexpected response while removing from cart',
        );
      }
      if (res['code'] != null && res['code'] != 200) {
        throw Failure(
          errorMassage:
              res['message'] ??
              'Unable to remove item from cart',
        );
      }
    } catch (e) {
      throw Failure(
        errorMassage: 'Remove Item From Cart : ${e.toString()}',
      );
    }
  }
}
