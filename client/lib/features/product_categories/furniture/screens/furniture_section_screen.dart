import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/global_variables.dart';
import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../search/screens/search_screen.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class FurnitureSectionScreen extends StatelessWidget with CommonWidgets {
  static const String routeName = '/furniture';

  const FurnitureSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    final List<String> groceries =
        GlobalVariables.productHierarchy['Furniture']?.keys.toList() ?? [];

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: groceries.map((category) {
                final imagePath =
                    GlobalVariables.furnitureIcons[category] ?? '';

                return GestureDetector(
                  onTap: () {
                    final productBloc = context.read<ProductBloc>();
                    productBloc.add(FetchProductsByCategory(
                      categories: ['Furniture', category],
                    ));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: productBloc,
                          child: const ProductsCatalogScreen(
                            title: '',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
