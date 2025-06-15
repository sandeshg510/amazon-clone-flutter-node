// product_details_bloc.dart
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../constants/bloc/user_bloc/user_bloc.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<AddToCartEvent>(_handleAddToCart);
    on<RateProductEvent>(_handleRateProduct);
  }

  Future<void> _handleAddToCart(
    AddToCartEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(AddingToCart());
    try {
      final response = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': event.user.token,
        },
        body: jsonEncode({'id': event.product.id}),
      );

      _handleResponse(
        response: response,
        onSuccess: () {
          final newCart = jsonDecode(response.body)['cart'];

          event.userBloc.add(UpdateUserCart(newCart));

          emit(AddToCartSuccess(
            event.user.copyWith(cart: newCart),
          ));
        },
        emit: emit,
        errorState: (error) => AddToCartFailure(error),
      );
    } catch (e) {
      emit(AddToCartFailure(e.toString()));
    }
  }

  Future<void> _handleRateProduct(
    RateProductEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(RatingProduct());

    try {
      final response = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': event.user.token,
        },
        body: jsonEncode({
          'id': event.product.id,
          'rating': event.rating,
        }),
      );
      print('Response body: ${response.body}');

      _handleResponse(
        response: response,
        onSuccess: () {
          final updatedProduct = Product.fromJson(jsonDecode(response.body));
          emit(RateProductSuccess(updatedProduct));
        },
        emit: emit,
        errorState: (error) => RateProductFailure(error),
      );
    } catch (e) {
      emit(RateProductFailure(e.toString()));
    }
  }
  // Future<void> _handleRateProduct(
  //   RateProductEvent event,
  //   Emitter<ProductDetailsState> emit,
  // ) async {
  //   emit(RatingProduct());
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$uri/api/rate-product'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': event.user.token,
  //       },
  //       body: jsonEncode({
  //         'id': event.product.id,
  //         'rating': event.rating,
  //       }),
  //     );
  //
  //     _handleResponse(
  //       response: response,
  //       onSuccess: () {
  //         final updatedProduct = Product.fromJson(jsonDecode(response.body));
  //         emit(RateProductSuccess(updatedProduct));
  //       },
  //       emit: emit,
  //       errorState: (error) => RateProductFailure(error),
  //     );
  //   } catch (e) {
  //     emit(RateProductFailure(e.toString()));
  //   }
  // }

  void _handleResponse({
    required http.Response response,
    required Function() onSuccess,
    required Emitter<ProductDetailsState> emit,
    required Function(String) errorState,
  }) {
    switch (response.statusCode) {
      case 200:
        onSuccess();
        break;
      case 400:
        emit(errorState(jsonDecode(response.body)["msg"]));
        break;
      case 500:
        emit(errorState(jsonDecode(response.body)["error"]));
        break;
      default:
        emit(errorState(response.body));
    }
  }
}
