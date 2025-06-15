import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class ProductCarousel extends StatefulWidget {
  const ProductCarousel({super.key, required this.product});

  final Product product;

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.product.images.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  i,
                  fit: widget.product.category == 'Fashion'
                      ? BoxFit.cover
                      : BoxFit.fitWidth,
                  height: 460,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            height: 460,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.product.images.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.black // Active dot
                    : Colors.grey.shade300, // Inactive dot
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
