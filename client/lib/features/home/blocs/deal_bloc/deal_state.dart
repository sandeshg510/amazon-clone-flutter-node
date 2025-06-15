import 'package:equatable/equatable.dart';

import '../../../../models/product.dart';

class DealState extends Equatable {
  final Product? dealOfTheDay;
  final List<Product> bestDeals;
  final bool isLoading;
  final String? error;

  const DealState({
    this.dealOfTheDay,
    this.bestDeals = const [],
    this.isLoading = false,
    this.error,
  });

  DealState copyWith({
    Product? dealOfTheDay,
    List<Product>? bestDeals,
    bool? isLoading,
    String? error,
  }) {
    return DealState(
      dealOfTheDay: dealOfTheDay ?? this.dealOfTheDay,
      bestDeals: bestDeals ?? this.bestDeals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [dealOfTheDay, bestDeals, isLoading, error];
}

class DealInitial extends DealState {}

class DealLoading extends DealState {}

class DealLoaded extends DealState {
  final Product product;

  DealLoaded(this.product);
}

class BestDealLoaded extends DealState {
  final List<Product> products;

  BestDealLoaded(this.products);
}

class DealError extends DealState {
  final String message;

  DealError(this.message);
}
