// admin_bloc_states.dart
part of 'admin_bloc.dart';

sealed class AdminState {}

class AdminInitial extends AdminState {}

class ProductsLoading extends AdminState {}

// Product States
class ProductOperationLoading extends AdminState {}

class ProductsLoadSuccess extends AdminState {
  final List<Product> products;
  ProductsLoadSuccess(this.products);
}

class ProductAddSuccess extends AdminState {}

class ProductDeleteSuccess extends AdminState {}

class ProductOperationFailure extends AdminState {
  final String error;
  ProductOperationFailure(this.error);
}

// Order States
class OrderOperationLoading extends AdminState {}

class OrdersLoadSuccess extends AdminState {
  final List<Order> orders;
  OrdersLoadSuccess(this.orders);
}

class OrderStatusChangeSuccess extends AdminState {}

class OrderOperationFailure extends AdminState {
  final String error;
  OrderOperationFailure(this.error);
}

// Analytics States
class AnalyticsLoading extends AdminState {}

class AnalyticsLoadSuccess extends AdminState {
  final Map<String, dynamic> analytics;
  AnalyticsLoadSuccess(this.analytics);
}

class AnalyticsOperationFailure extends AdminState {
  final String error;
  AnalyticsOperationFailure(this.error);
}
