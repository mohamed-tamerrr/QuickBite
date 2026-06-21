part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class GetCartLoading extends CartState {}

final class GetCartSuccess extends CartState {}

final class GetCartFailure extends CartState {
  String errorMsg;
  GetCartFailure(this.errorMsg);
}

final class RemoveCartLoading extends CartState {}

final class RemoveCartSuccess extends CartState {}

final class RemoveCartFailure extends CartState {
  String errorMsg;
  RemoveCartFailure(this.errorMsg);
}

final class CartQuantityChanged extends CartState {}
