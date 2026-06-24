part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersSuccess extends OrdersState {}

final class OrdersCheckoutLoading extends OrdersState {}

final class OrdersCheckoutSuccess extends OrdersState {}

final class OrdersFailure extends OrdersState {
  final String errMsg;
  OrdersFailure(this.errMsg);
}
