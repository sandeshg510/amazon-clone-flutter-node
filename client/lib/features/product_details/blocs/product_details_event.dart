part of 'product_details_bloc.dart';

@immutable
sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends ProductDetailsEvent {
  final Product product;
  final User user;
  final UserBloc userBloc;
  const AddToCartEvent(this.product, this.user, this.userBloc);

  @override
  List<Object> get props => [product, user];
}

class RateProductEvent extends ProductDetailsEvent {
  final Product product;
  final double rating;
  final User user;

  const RateProductEvent(this.product, this.rating, this.user);

  @override
  List<Object> get props => [product, rating, user];
}
