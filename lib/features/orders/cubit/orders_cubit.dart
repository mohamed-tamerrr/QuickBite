import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:QuickBite/features/auth/data/user_model.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/orders/data/order_model.dart';
import 'package:QuickBite/features/orders/data/order_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  final OrderRepo orderRepo = OrderRepo();
  final AuthRepo authRepo = AuthRepo();

  OrdersResponse? orders;

  /// Get Orders
  Future<void> getOrders() async {
    emit(OrdersLoading());
    try {
      orders = await orderRepo.getOrders();
      emit(OrdersSuccess());
    } catch (e) {
      String error = 'Get Orders Failed';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(OrdersFailure(error));
    }
  }

  Future<void> saveOrder(List<CartItemModel> cartItems) async {
    emit(OrdersCheckoutLoading());
    try {
      final orderItems = cartItems.map((item) {
        return OrderItemRequest(
          productId: item.productId,
          quantity: item.quantity,
          spicy: double.tryParse(item.spicyLevel) ?? 0.0,
          toppings: [],
          sideOptions: [],
        );
      }).toList();

      final request = OrderRequest(items: orderItems);
      await orderRepo.saveOrder(request);
      emit(OrdersCheckoutSuccess());
    } catch (e) {
      String error = 'Order placement failed';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(OrdersFailure(error));
    }
  }
}
