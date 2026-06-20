part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {}

final class HomeFailure extends HomeState {
  String errorMsg;
  HomeFailure(this.errorMsg);
}

final class AddCartLoading extends HomeState {}

final class AddCartSuccess extends HomeState {}

final class AddCartFailure extends HomeState {
  String errorMsg;
  AddCartFailure(this.errorMsg);
}
