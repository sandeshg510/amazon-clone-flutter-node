import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/product_categories/fashion/widgets/fashion_home_body.dart';
import 'package:flutter/material.dart';

import '../../../../constants/global_variables.dart';
import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../search/screens/search_screen.dart';

class FashionCategory extends StatefulWidget {
  static const String routeName = '/fashion';

  const FashionCategory({super.key});

  @override
  State<FashionCategory> createState() => _FashionCategoryState();
}

class _FashionCategoryState extends State<FashionCategory> with CommonWidgets {
  final Map<String, List<String>> fashionSubcategories =
      GlobalVariables.productHierarchy['Fashion']!;

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: const FashionHomeBody(),
    );
  }
}
