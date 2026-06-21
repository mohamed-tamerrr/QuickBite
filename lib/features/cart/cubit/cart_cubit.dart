import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/cart/data/cart_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartRepo _cartRepo = CartRepo();
  GetCartResponse? cartResponse;

  late List<int> quantities = [];
  int? deletingItemId;

  /// Get Cart Items
  Future<void> getCartItems() async {
    emit(GetCartLoading());
    try {
      final response = await _cartRepo.getCartItems();

      cartResponse = response;

      quantities = response.cartData.items
          .map((e) => e.quantity)
          .toList();

      emit(GetCartSuccess());
    } catch (e) {
      String errorMsg = 'Failed To Get Cart';
      if (e is Failure) {
        errorMsg = e.errorMassage;
      }
      emit(GetCartFailure(errorMsg));
    }
  }

  /// Delete Cart Item
  Future<void> removeCartItem(int id) async {
    emit(RemoveCartLoading());
    try {
      deletingItemId = id;
      await _cartRepo.removeCartItem(id);
      deletingItemId = null;
      await getCartItems();
      emit(RemoveCartSuccess());
    } catch (e) {
      String errorMsg = 'Failed To Get Cart';
      if (e is Failure) {
        errorMsg = e.errorMassage;
      }
      emit(RemoveCartFailure(errorMsg));
    }
  }

  /// On Add
  void onAdd(int index) {
    quantities[index]++;

    emit(CartQuantityChanged());
  }

  /// On Minus
  void onMinus(int index) {
    if (quantities[index] > 1) {
      quantities[index]--;
    }
    emit(CartQuantityChanged());
  }
}
// todo : cartResponse!.cartData.items[index].quantity++;