part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

final class ProductDetailsInitial extends ProductDetailsState {}

final class AddingToCart extends ProductDetailsState {}

final class AddToCartSuccess extends ProductDetailsState {
  final User updatedUser;

  const AddToCartSuccess(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}

final class AddToCartFailure extends ProductDetailsState {
  final String error;

  const AddToCartFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class RatingProduct extends ProductDetailsState {}

final class RateProductSuccess extends ProductDetailsState {
  final Product updatedProduct;

  const RateProductSuccess(this.updatedProduct);

  @override
  List<Object> get props => [updatedProduct];
}

final class RateProductFailure extends ProductDetailsState {
  final String error;

  const RateProductFailure(this.error);

  @override
  List<Object> get props => [error];
}
