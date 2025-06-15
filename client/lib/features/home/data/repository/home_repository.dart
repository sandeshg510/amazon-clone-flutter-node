import 'dart:convert';

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../../../models/product.dart';

class HomeRepository {
  final String token;
  HomeRepository({required this.token});
  Future<List<Product>> fetchCategoryProducts(
      String category, String token) async {
    // Get token from global provider or pass it via constructor instead
    // Avoid using context here if possible in BLoC, refactor to pass token directly

    final url = Uri.parse('$uri/api/products?category=$category');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token // pass token explicitly
    });

    final List<Product> productList = [];
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      for (var item in body) {
        productList.add(Product.fromMap(item));
      }
    } else {
      throw Exception(
          'Failed to load products: ${response.statusCode} ${response.reasonPhrase}');
    }
    return productList;
  }

  Future<Product> getDealOfTheDay() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/deal-of-the-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.body);
      } else {
        throw Exception('Failed to load deal of the day');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getBestDeals() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/best-deal-for-you'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      // if (response.statusCode == 200) {
      //   final List<dynamic> jsonData = json.decode(response.body);
      //   return jsonData.map((item) => Product.fromMap(item)).toList();
      // }
      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          return body
              .map((item) => Product.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format: expected a list');
        }
      } else {
        throw Exception('Failed to load deal of the day');
      }
    } catch (e) {
      rethrow;
    }
  }
}
