import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/bloc/user_bloc/user_bloc.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final user = context.currentUser;
    // User user = userProvider.user.copyWith(address: address);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User newUser = context.currentUser.copyWith(
            address: jsonDecode(res.body)['address'],
          );

          context.read<UserBloc>().add(SetUserFromModel(newUser));
        },
      );
    } catch (e) {
      print('Response body: ${e.toString()}');

      showSnackBar(context, e.toString());
    }
  }

  // Order products

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final user = context.currentUser;
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/order'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token
          },
          body: jsonEncode({
            'cart': user.cart,
            'address': address,
            'totalPrice': totalSum,
          }));

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed!');
          User newUser = user.copyWith(
            cart: [],
          );
          context.read<UserBloc>().add(SetUserFromModel(newUser));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void buyNow({
    required BuildContext context,
    required Product product,
    required int quantity,
    required String address,
  }) async {
    final user = context.currentUser;
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'cart': [
            {
              'product': product.toMap(),
              'quantity': quantity,
            }
          ],
          'address': address,
          'totalPrice': product.price * quantity,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// void placeOrder({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final user = context.currentUser;
  //   try {
  //     http.Response response = await http.post(Uri.parse('$uri/api/order'),
  //         headers: <String, String>{
  //           'Content-type': 'application/json; charset=UTF-8',
  //           'x-auth-token': user.token
  //         },
  //         body: jsonEncode({
  //           'cart': user.cart,
  //           'address': address,
  //           'totalPrice': totalSum,
  //         }));
  //
  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User newUser = user.copyWith(
  //           cart: [],
  //         );
  //         context.read<UserBloc>().add(SetUserFromModel(newUser));
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  // void placeOrderFromCart({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final user = context.currentUser;
  //   try {
  //     http.Response response = await http.post(Uri.parse('$uri/api/order'),
  //         headers: <String, String>{
  //           'Content-type': 'application/json; charset=UTF-8',
  //           'x-auth-token': user.token
  //         },
  //         body: jsonEncode({
  //           'cart': user.cart,
  //           'address': address,
  //           'totalPrice': totalSum,
  //         }));
  //
  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User newUser = user.copyWith(
  //           cart: [],
  //         );
  //         context.read<UserBloc>().add(SetUserFromModel(newUser));
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

// void placeOrder({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final user = context.currentUser;
  //   try {
  //     // Create simplified cart data using map access
  //     final simplifiedCart = user.cart.map((item) {
  //       return {
  //         'productId': item['product']['_id'], // Access via map keys
  //         'quantity': item['quantity'],
  //       };
  //     }).toList();
  //
  //     http.Response response = await http.post(
  //       Uri.parse('$uri/api/order'),
  //       headers: <String, String>{
  //         'Content-type': 'application/json; charset=UTF-8',
  //         'x-auth-token': user.token
  //       },
  //       body: jsonEncode({
  //         'cart': simplifiedCart,
  //         'address': address,
  //         'totalPrice': totalSum,
  //       }),
  //     );
  //
  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User newUser = user.copyWith(cart: []);
  //         context.read<UserBloc>().add(SetUserFromModel(newUser));
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, 'Order failed: ${e.toString()}');
  //   }
  // }
  //
  // void placeOrderFromCart({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final user = context.currentUser;
  //   try {
  //     http.Response response = await http.post(Uri.parse('$uri/api/order'),
  //         headers: <String, String>{
  //           'Content-type': 'application/json; charset=UTF-8',
  //           'x-auth-token': user.token
  //         },
  //         body: jsonEncode({
  //           'cart': user.cart,
  //           'address': address,
  //           'totalPrice': totalSum,
  //         }));
  //
  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User newUser = user.copyWith(
  //           cart: [],
  //         );
  //         context.read<UserBloc>().add(SetUserFromModel(newUser));
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }
}
