import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/stars.dart';

class SearchedProduct extends StatelessWidget with CommonWidgets {
  const SearchedProduct({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;

    for (var ratingObj in product.ratings!) {
      totalRating += ratingObj.rating;
    }
    double avgRating = 0;

    if (totalRating != 0) {
      avgRating = totalRating / product.ratings!.length;
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.fitHeight,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Stars(rating: avgRating)),
                  Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '\$${product.price.toString()}',
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Eligible for free shipping',
                      )),
                  Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'In stock',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
