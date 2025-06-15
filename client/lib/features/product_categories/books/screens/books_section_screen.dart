import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/global_variables.dart';
import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../search/screens/search_screen.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class BooksSectionScreen extends StatelessWidget with CommonWidgets {
  static const String routeName = '/books';

  const BooksSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    final List<String> groceries =
        GlobalVariables.productHierarchy['Books']?.keys.toList() ?? [];

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
                final imagePath = GlobalVariables.booksIcons[category] ?? '';

                return GestureDetector(
                  onTap: () {
                    final productBloc = context.read<ProductBloc>();
                    productBloc.add(FetchProductsByCategory(
                      categories: ['Books', category],
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
                      verticalSpace(height: 16),
                      SizedBox(
                        child: Image.asset(
                          width: MediaQuery.of(context).size.width * 0.45,
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
