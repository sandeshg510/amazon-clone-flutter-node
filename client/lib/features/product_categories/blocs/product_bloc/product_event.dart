part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsByCategory extends ProductEvent {
  final List<String> categories;

  const FetchProductsByCategory({required this.categories});

  @override
  List<Object> get props => [categories];
}
