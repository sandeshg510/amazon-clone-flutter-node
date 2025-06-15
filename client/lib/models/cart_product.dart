import 'package:amazon_clone/models/product.dart';

class CartProduct {
  final Product product;
  final int quantity;

  CartProduct({
    required this.product,
    required this.quantity,
  });

  factory CartProduct.fromMap(Map<String, dynamic> map) {
    return CartProduct(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
    );
  }
}
