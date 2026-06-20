import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/home/data/model/product_model.dart';
import 'package:QuickBite/features/home/data/model/topping_model.dart';
import 'package:QuickBite/features/home/data/repo/home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final HomeRepo _homeRepo = HomeRepo();
  List<ProductModel>? products = [];
  List<ProductModel>? allProducts = [];

  List<ToppingModel>? options = [];
  List<ToppingModel>? toppings = [];

  Set<int> selectedToppings = {};
  Set<int> selectedOptions = {};

  List categories = ['All', 'Combos', 'Sliders', 'Classtic'];
  int selectedIndex = 0;

  /// Get Products
  Future<void> getProducts() async {
    emit(HomeLoading());
    try {
      products = await _homeRepo.getProduct();

      emit(HomeSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(HomeFailure(error));
    }
  }

  /// Get Toppings
  Future<void> getToppings() async {
    emit(HomeLoading());
    try {
      toppings = await _homeRepo.getToppings();

      emit(HomeSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(HomeFailure(error));
    }
  }

  /// Get Options
  Future<void> getOptions() async {
    emit(HomeLoading());
    try {
      options = await _homeRepo.getOptions();

      emit(HomeSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(HomeFailure(error));
    }
  }

  /// Add To Cart
  Future<void> addToCart(CartRequestModel cartModel) async {
    emit(AddCartLoading());
    try {
      await _homeRepo.addToCart(cartModel);
      emit(AddCartSuccess());
    } catch (e) {
      String errorMsg = 'Failed To Add Product';
      if (e is AddCartFailure) {
        errorMsg = e.errorMsg;
      }
      emit(AddCartFailure(errorMsg));
    }
  }
}
