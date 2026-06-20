import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/home/data/model/product_model.dart';
import 'package:QuickBite/features/home/data/repo/product_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final ProductRepo _productRepo = ProductRepo();
  List<ProductModel>? products = [];
  List<ProductModel>? allProducts = [];

  List categories = ['All', 'Combos', 'Sliders', 'Classtic'];
  int selectedIndex = 0;

  Future<void> getProducts() async {
    emit(HomeLoading());
    try {
      products = await _productRepo.getProduct();

      emit(HomeSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(HomeFailure(error));
    }
  }
}
