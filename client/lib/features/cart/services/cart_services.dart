import 'dart:convert';

import 'package:amazon_clone/constants/bloc/user_bloc/user_bloc.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final user = context.currentUser;

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User newUser = user.copyWith(cart: jsonDecode(res.body)['cart']);
          context.read<UserBloc>().add(SetUserFromModel(newUser));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
