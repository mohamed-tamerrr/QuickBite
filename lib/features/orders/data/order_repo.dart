import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/core/network/api_service.dart';
import 'package:QuickBite/features/orders/data/order_model.dart';

class OrderRepo {
  ApiService _apiService = ApiService();
  final String _orderEndpoint = '/orders';

  /// Save Order
  Future<void> saveOrder(OrderRequest order) async {
    try {
      final res = await _apiService.post(
        _orderEndpoint,
        order.toJson(),
      );
      if (res is Failure) {
        throw res;
      }

      if (res is Map<String, dynamic> &&
          res['code'] != null &&
          res['code'] != 200) {
        throw Failure(
          errorMassage: res['message'] ?? 'Unable to save order',
        );
      }
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  /// Get Orders
  Future<OrdersResponse> getOrders() async {
    try {
      final res = await _apiService.get(_orderEndpoint);

      if (res is Failure) {
        throw res;
      }

      if (res is Map<String, dynamic> &&
          res['code'] != null &&
          res['code'] != 200) {
        throw Failure(
          errorMassage:
              res['message'] ?? 'Unable to fetch orders',
        );
      }

      return OrdersResponse.fromJson(res);
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }
}
