import 'dart:io';

import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/admin_services.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminServices adminServices;
  final String authToken;

  AdminBloc({required this.adminServices, required this.authToken})
      : super(AdminInitial()) {
    // Product Events
    on<AddProductEvent>(_handleAddProduct);
    on<FetchAllProductsEvent>(_handleFetchProducts);
    on<DeleteProductEvent>(_handleDeleteProduct);

    // Order Events
    on<FetchAllOrdersEvent>(_handleFetchOrders);
    on<ChangeOrderStatusEvent>(_handleChangeOrderStatus);

    // Analytics Event
    on<GetEarningsEvent>(_handleGetEarnings);
  }

  // Product Handlers
  Future<void> _handleAddProduct(
    AddProductEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(ProductOperationLoading());
    try {
      await adminServices.sellProducts(
        token: authToken,
        name: event.name,
        brand: event.brand,
        description: event.description,
        price: event.price,
        quantity: event.quantity,
        category: event.category,
        subCategory: event.subCategory,
        subClassification: event.subClassification,
        colour: event.colour,
        about: event.about,
        images: event.images,
        sizes: event.sizes,
        inTheBox: event.inTheBox,
      );
      emit(ProductAddSuccess());
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  Future<void> _handleFetchProducts(
    FetchAllProductsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await adminServices.fetchAllProducts(authToken);
      emit(ProductsLoadSuccess(products));
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  Future<void> _handleDeleteProduct(
    DeleteProductEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(ProductOperationLoading());
    try {
      await adminServices.deleteProduct(
        productId: event.productId,
        token: authToken,
      );
      emit(ProductDeleteSuccess());
    } catch (e) {
      emit(ProductOperationFailure(e.toString()));
    }
  }

  // Order Handlers
  Future<void> _handleFetchOrders(
    FetchAllOrdersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(OrderOperationLoading());
    try {
      final orders = await adminServices.fetchAllOrders(authToken);
      emit(OrdersLoadSuccess(orders));
    } catch (e) {
      emit(OrderOperationFailure(e.toString()));
    }
  }

  Future<void> _handleChangeOrderStatus(
    ChangeOrderStatusEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(OrderOperationLoading());
    try {
      await adminServices.changeOrderStatus(
        orderId: event.orderId,
        status: event.status,
        token: authToken,
      );
      emit(OrderStatusChangeSuccess());
    } catch (e) {
      emit(OrderOperationFailure(e.toString()));
    }
  }

  // Analytics Handler
  Future<void> _handleGetEarnings(
    GetEarningsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await adminServices.getEarnings(authToken);
      emit(AnalyticsLoadSuccess(analytics));
    } catch (e) {
      emit(AnalyticsOperationFailure(e.toString()));
    }
  }
}
