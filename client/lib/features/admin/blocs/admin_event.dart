// admin_bloc_events.dart
part of 'admin_bloc.dart';

sealed class AdminEvent {}

// Product Events
class AddProductEvent extends AdminEvent {
  final String name;
  final String? brand;
  final String? description;
  final double price;
  final double quantity;
  final String category;
  final String subCategory;
  final String? subClassification;
  final String? colour;
  final String? about;
  final String? inTheBox;
  final List<File> images;
  final List<String> sizes;

  AddProductEvent({
    required this.name,
    this.brand,
    this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.subCategory,
    this.subClassification,
    this.colour,
    this.about,
    this.inTheBox,
    required this.images,
    required this.sizes,
  });
}

class FetchAllProductsEvent extends AdminEvent {}

class DeleteProductEvent extends AdminEvent {
  final String productId;

  DeleteProductEvent(this.productId);
}

// Order Events
class FetchAllOrdersEvent extends AdminEvent {}

class ChangeOrderStatusEvent extends AdminEvent {
  final String orderId;
  final int status;

  ChangeOrderStatusEvent(this.orderId, this.status);
}

// Analytics Event
class GetEarningsEvent extends AdminEvent {}
