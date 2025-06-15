import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../models/sales.dart';

class AdminServices {
  // Product Services
  Future<void> sellProducts({
    required String token,
    required String name,
    required List<File> images,
    required double price,
    required double quantity,
    required String category,
    required String subCategory,
    required List<String> sizes,
    String? brand,
    String? description,
    String? subClassification,
    String? colour,
    String? about,
    String? inTheBox,
  }) async {
    try {
      final imageUrls = await _uploadProductImages(images, name);

      // Create product object
      final product = Product(
        name: name,
        description: description ?? '',
        quantity: quantity,
        price: price,
        images: imageUrls,
        category: category,
        subCategory: subCategory,
        subClassification: subClassification ?? '',
        sizes: sizes,
        brand: brand ?? '',
        colour: colour ?? '',
        about: about ?? '',
        inTheBox: inTheBox ?? '',
      );

      // Make API call
      final response = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: _buildHeaders(token),
        body: product.toJson(),
      );

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to add product: ${_parseError(response.body)}');
      }
    } catch (e) {
      throw HttpException('Product creation failed: ${e.toString()}');
    }
  }

  Future<List<Product>> fetchAllProducts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((p) => Product.fromMap(p))
            .toList();
      }
      throw HttpException('Failed to fetch products: ${response.statusCode}');
    } catch (e) {
      throw HttpException('Products fetch failed: ${e.toString()}');
    }
  }

  Future<void> deleteProduct({
    required String productId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: _buildHeaders(token),
        body: jsonEncode({'id': productId}),
      );

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to delete product: ${_parseError(response.body)}');
      }
    } catch (e) {
      throw HttpException('Product deletion failed: ${e.toString()}');
    }
  }

  // Order Services
  Future<List<Order>> fetchAllOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((o) => Order.fromMap(o))
            .toList();
      }

      throw HttpException('Failed to fetch orders: ${response.statusCode}');
    } catch (e) {
      throw HttpException('Orders fetch failed: ${e.toString()}');
    }
  }

  Future<void> changeOrderStatus({
    required String orderId,
    required int status, // Integer status from frontend (0,1,2)
    required String token,
  }) async {
    try {
      // Convert integer status to backend string representation
      String statusString;
      switch (status) {
        case 0:
          statusString = 'pending';
          break;
        case 1:
          statusString = 'shipped'; // Matches your backend enum
          break;
        case 2:
          statusString = 'delivered';
          break;
        default:
          statusString = 'pending';
      }
      print('Attempting to change status for orderId: $orderId');

      final response = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: _buildHeaders(token),
        body: jsonEncode({
          'id': orderId.toString(),
          'status': statusString // Send the string value
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to change order status: ${_parseError(response.body)}');
      }
    } catch (e) {
      throw HttpException('Order status change failed: ${e.toString()}');
    }
  }
  // Future<void> changeOrderStatus({
  //   required String orderId,
  //   required int status,
  //   required String token,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$uri/admin/change-order-status'),
  //       headers: _buildHeaders(token),
  //       body: jsonEncode({'id': orderId, 'status': status}),
  //     );
  //
  //     if (response.statusCode != 200) {
  //       throw HttpException(
  //           'Failed to change order status: ${_parseError(response.body)}');
  //     }
  //     print(json.encode(response.body));
  //     print(json.decode(response.body));
  //   } catch (e) {
  //     throw HttpException('Order status change failed: ${e.toString()}');
  //   }
  // }

  // Analytics Services
  Future<Map<String, dynamic>> getEarnings(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'sales': [
            Sales('groceries', data['groceriesEarnings']),
            Sales('Mobiles', data['mobileEarnings']),
            Sales('Electronics', data['electronicsEarnings']),
            Sales('Appliances', data['applianceEarnings']),
            Sales('Books', data['booksEarnings']),
            Sales('Furniture', data['furnitureEarnings']),
            Sales('Fashion', data['fashionEarnings']),
          ],
          'totalEarnings': data['totalEarnings'],
        };
      }
      throw HttpException('Failed to fetch analytics: ${response.statusCode}');
    } catch (e) {
      throw HttpException('Analytics fetch failed: ${e.toString()}');
    }
  }

  // Helper Methods

  Future<List<String>> _uploadProductImages(
    List<File> images,
    String productName,
  ) async {
    const apiKey = GlobalVariables.apiKey; // Get from ImgBB
    final List<String> imageUrls = [];

    try {
      for (final image in images) {
        // Convert image to base64
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        // Prepare request
        final uri = Uri.parse('https://api.imgbb.com/1/upload');
        final response = await http.post(
          uri,
          body: {
            'key': apiKey,
            'image': base64Image,
            'name': productName,
          },
        );

        // Handle response
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          imageUrls.add(jsonData['data']['url']);
        } else {
          throw Exception('Failed to upload image: ${response.body}');
        }
      }

      if (imageUrls.isEmpty) {
        throw Exception('All image uploads failed');
      }

      return imageUrls;
    } catch (e) {
      throw Exception('Image upload error: $e');
    }
  }

  // Future<List<String>> _uploadProductImages(
  //     List<File> images, String productName) async {
  //   final List<String> imageUrls = [];
  //
  //   try {
  //     final _cloudinary = CloudinaryPublic('ddnw9fzwu', 'products');
  //
  //     for (final image in images) {
  //       final response = await _cloudinary.uploadFile(
  //         CloudinaryFile.fromFile(image.path, folder: productName),
  //       );
  //       imageUrls.add(response.secureUrl);
  //     }
  //     return imageUrls;
  //   } catch (e) {
  //     // imageUrls.add('');
  //     debugPrint('Image upload failed: ${e.toString()}');
  //     return imageUrls.where((url) => url.isNotEmpty).toList();
  //   }
  // }

  Map<String, String> _buildHeaders(String token) => {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      };

  String _parseError(String responseBody) {
    try {
      return jsonDecode(responseBody)['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Unknown error';
    }
  }
}

// Old AdminServices
//
//
// class AdminServices {
//   // +*** Add Products
//   void sellProducts({
//     required BuildContext context,
//     required String name,
//     required String? brand,
//     required String? description,
//     required double price,
//     required double quantity,
//     required String category,
//     required String subCategory,
//     required String? subClassification,
//     required String? colour,
//     required String? about,
//     required List<File> images,
//     required List<String> sizes,
//   }) async {
//     final user = context.currentUser;
//     try {
//       final cloudinary = CloudinaryPublic('ddnw9fzwu', 'products');
//       List<String> imageUrls = [];
//
//       for (var image in images) {
//         CloudinaryResponse response = await cloudinary
//             .uploadFile(CloudinaryFile.fromFile(image.path, folder: name));
//         imageUrls.add(response.secureUrl);
//       }
//
//       Product product = Product(
//         name: name,
//         description: description ?? '',
//         quantity: quantity,
//         price: price,
//         images: imageUrls,
//         category: category,
//         subCategory: subCategory,
//         subClassification: subClassification ?? '',
//         sizes: sizes,
//         brand: brand ?? '',
//         colour: colour ?? '',
//         about: about ?? '',
//       );
//
//       http.Response response = await http.post(
//         Uri.parse('$uri/admin/add-product'),
//         headers: {
//           'Content-type': 'application/json; charset=UTF-8',
//           'x-auth-token': user.token,
//         },
//         body: product.toJson(),
//       );
//
//       httpErrorHandle(
//         response: response,
//         context: context,
//         onSuccess: () {
//           showSnackBar(context, 'Product added successfully!');
//           Navigator.pop(context, true);
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       print(e.toString());
//     }
//   }
//
// // +*** Get all the Products
//
//   Future<List<Product>> fetchAllProducts(BuildContext context) async {
//     final user = context.currentUser;
//     List<Product> productList = [];
//
//     try {
//       Response response = await http.get(Uri.parse('$uri/admin/get-products'),
//           headers: <String, String>{
//             'Content-type': 'application/json; charset=UTF-8',
//             'x-auth-token': user.token
//           });
//
//       httpErrorHandle(
//           response: response,
//           context: context,
//           onSuccess: () {
//             for (var product in jsonDecode(response.body)) {
//               // productList.add(Product.fromJson(jsonEncode(product)));
//               productList.add(Product.fromMap(product));
//             }
//           });
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       print(e.toString());
//     }
//     return productList;
//   }
//
//   // +*** Delete Products
//   void deleteProduct(
//       {required BuildContext context,
//       required Product product,
//       required Function? onSuccess}) async {
//     final user = context.currentUser;
//
//     try {
//       Response response = await http.post(
//           Uri.parse('$uri/admin/delete-product'),
//           headers: <String, String>{
//             'Content-type': 'application/json; charset=UTF-8',
//             'x-auth-token': user.token
//           },
//           body: jsonEncode({
//             'id': product.id,
//           }));
//
//       httpErrorHandle(
//           response: response,
//           context: context,
//           onSuccess: () {
//             onSuccess!();
//           });
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       print(e.toString());
//     }
//   }
//
//   Future<List<Order>> fetchAllOrders(BuildContext context) async {
//     final user = context.currentUser;
//     List<Order> orderList = [];
//
//     try {
//       Response response = await http.get(Uri.parse('$uri/admin/get-orders'),
//           headers: <String, String>{
//             'Content-type': 'application/json; charset=UTF-8',
//             'x-auth-token': user.token
//           });
//
//       httpErrorHandle(
//           response: response,
//           context: context,
//           onSuccess: () {
//             for (var order in jsonDecode(response.body)) {
//               // productList.add(Product.fromJson(jsonEncode(product)));
//               orderList.add(Order.fromMap(order));
//             }
//           });
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       print(e.toString());
//     }
//     return orderList;
//   }
//
//   void changeOrderStatus(
//       {required BuildContext context,
//       required int status,
//       required Order order,
//       required VoidCallback onSuccess}) async {
//     final user = context.currentUser;
//     print(status);
//
//     try {
//       Response response = await http.post(
//           Uri.parse('$uri/admin/change-order-status'),
//           headers: <String, String>{
//             'Content-type': 'application/json; charset=UTF-8',
//             'x-auth-token': user.token
//           },
//           body: jsonEncode({
//             'id': order.id,
//             'status': status,
//           }));
//
//       httpErrorHandle(
//           response: response, context: context, onSuccess: onSuccess);
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }
//
