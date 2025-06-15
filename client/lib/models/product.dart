import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  final String name;
  final String brand;
  final String description;
  final double quantity;
  final double price;
  final List<String> images;
  late final List<Ratings>? ratings;
  final String category;
  final String subCategory;
  final String? subClassification;
  final String? colour;
  final String? about;
  final String? id;
  final List<String>? sizes;
  final String? inTheBox;

  Product({
    this.colour,
    this.about,
    this.sizes,
    this.inTheBox,
    this.subClassification,
    required this.name,
    required this.brand,
    required this.description,
    required this.quantity,
    required this.price,
    required this.images,
    required this.category,
    required this.subCategory,
    this.id,
    this.ratings,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'quantity': quantity,
      'price': price,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'subClassification': subClassification,
      'colour': colour,
      'about': about,
      'inTheBox': inTheBox,
      'ratings': ratings?.map((x) => x.toMap()).toList(),
      'sizes': sizes ?? [] // Ensure sizes is never null
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      price: (map['price'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      subClassification: map['subClassification'] ?? '',
      brand: map['brand'] ?? '',
      colour: map['colour'] ?? '',
      about: map['about'] ?? '',
      inTheBox: map['inTheBox'] ?? '',
      sizes: map['sizes'] == null
          ? []
          : (map['sizes'] is List
              ? List<String>.from(map['sizes'])
              : [map['sizes'].toString()]),
      ratings: map['ratings'] != null
          ? List<Ratings>.from(
              map['ratings'].map((x) => Ratings.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  Product copyWith({
    List<Ratings>? ratings,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      quantity: quantity,
      images: images,
      ratings: ratings ?? this.ratings,
      brand: brand,
      price: price,
      category: category,
      subCategory: subCategory,
      subClassification: subClassification,
      colour: colour,
      about: about,
      inTheBox: inTheBox,
      sizes: sizes,
    );
  }
}
