import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../models/product.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProduct({
    required String searchQuery,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$uri/api/products/search/$searchQuery'),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (body as List).map((e) => Product.fromMap(e)).toList();
    } else {
      final errorMsg = body["msg"] ?? body["error"] ?? response.body;
      throw Exception(errorMsg);
    }
  }
}
