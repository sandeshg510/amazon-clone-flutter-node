import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../../../models/product.dart';

class ProductRepository {
  ProductRepository();

  Future<List<Product>> fetchProductsByCategory({
    required List<String> categories,
  }) async {
    try {
      final encodedCategories =
          categories.map((c) => Uri.encodeComponent(c)).toList();
      final response = await http.get(
        Uri.parse(
            '$uri/api/products?categories=${encodedCategories.join(',')}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_AUTH_TOKEN', // Add your auth token logic
        },
      );

      if (response.statusCode == 200) {
        return _parseProducts(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

  Future<List<Product>> fetchProductsByCategoryMap({
    required Map<String, String> categoryMap,
  }) async {
    try {
      final categories = categoryMap.values.toList();
      return await fetchProductsByCategory(categories: categories);
    } catch (e) {
      throw Exception('Failed to fetch products by map: $e');
    }
  }

  List<Product> _parseProducts(String responseBody) {
    try {
      final parsed = jsonDecode(responseBody) as List<dynamic>;
      return parsed
          .map<Product>((json) => Product.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse products: ${e.toString()}');
    }
  }

  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return Exception('Invalid request');
      case 401:
        return Exception('Unauthorized - Please login');
      case 404:
        return Exception('Products not found');
      case 500:
        return Exception('Server error');
      default:
        return Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Exception _handleNetworkError(dynamic error) {
    if (error is SocketException) {
      return Exception('No internet connection');
    } else if (error is TimeoutException) {
      return Exception('Connection timeout');
    }
    return Exception('Network error: ${error.toString()}');
  }
}
