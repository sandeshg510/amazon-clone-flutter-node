import 'package:amazon_clone/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product_categories/blocs/product_bloc/product_bloc.dart';
import '../../product_categories/fashion/screens/products_catalog_screen.dart';

class CarouselImages extends StatefulWidget {
  const CarouselImages({super.key});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  void navigateToCategoryPage(
      BuildContext context, String category, String title) {
    final productBloc = context.read<ProductBloc>();
    productBloc.add(FetchProductsByCategory(categories: [category]));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: productBloc,
          child: ProductsCatalogScreen(title: title),
        ),
      ),
    );
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.cyan.shade100,
      height: 200,
      child: Stack(
        children: [
          CarouselSlider(
            items: GlobalVariables.carouselImages.asMap().entries.map((entry) {
              int index = entry.key;
              String imageUrl = entry.value;

              return Builder(
                builder: (BuildContext context) => GestureDetector(
                  onTap: () {
                    switch (index) {
                      case 0:
                        return navigateToCategoryPage(
                            context, 'Electronics', 'Accessories');
                      case 1:
                        return navigateToCategoryPage(context,
                            'Fashion,Men,Bags', 'Bags, Wallets & Luggage');
                      case 2:
                        return navigateToCategoryPage(context, 'Mobiles',
                            'Great discounted benefits on Mobiles');
                      case 3:
                        return navigateToCategoryPage(
                            context, 'Fashion', 'Fashion Essentials');
                      case 4:
                        return navigateToCategoryPage(
                            context, 'Fashion,Men,Bags', 'Super Saver');
                    }
                  },
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitHeight,
                    height: 240,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: 265,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 15,
            left: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  GlobalVariables.carouselImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black),
                    shape: BoxShape.circle,
                    color: currentIndex == entry.key
                        ? Colors.blue.shade700 // Active dot
                        : Colors.white70, // Inactive dot
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
