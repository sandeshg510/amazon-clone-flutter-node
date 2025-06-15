import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/product_categories/appliances/screens/appliances_section_screen.dart';
import 'package:amazon_clone/features/product_categories/books/screens/books_section_screen.dart';
import 'package:amazon_clone/features/product_categories/electronics/screens/electronics_section_screen.dart';
import 'package:amazon_clone/features/product_categories/furniture/screens/furniture_section_screen.dart';
import 'package:amazon_clone/features/product_categories/groceries/screens/groceries_section_screen.dart';
import 'package:amazon_clone/features/product_categories/mobiles/screens/mobiles_section_screen.dart';
import 'package:flutter/material.dart';

import '../../product_categories/fashion/screens/fashion_category.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: GlobalVariables.categoryImages.length,
          itemExtent: 75,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                switch (GlobalVariables.categoryImages[index]['title']) {
                  case 'Fashion':
                    Navigator.pushNamed(context, FashionCategory.routeName);
                  case 'Groceries':
                    Navigator.pushNamed(
                        context, GroceriesSectionScreen.routeName);
                  case 'Mobiles':
                    Navigator.pushNamed(
                        context, MobilesSectionScreen.routeName);
                  case 'Electronics':
                    Navigator.pushNamed(
                        context, ElectronicsSectionScreen.routeName);

                  case 'Appliances':
                    Navigator.pushNamed(
                        context, AppliancesSectionScreen.routeName);
                  case 'Furniture':
                    Navigator.pushNamed(
                        context, FurnitureSectionScreen.routeName);
                  case 'Books':
                    Navigator.pushNamed(context, BooksSectionScreen.routeName);
                }
              },
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          GlobalVariables.categoryImages[index]['image']!,
                          fit: BoxFit.cover,
                          height: 58,
                          width: 50,
                        ),
                      ),
                      Text(
                        GlobalVariables.categoryImages[index]['title']!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            );
          })),
    );
  }
}
