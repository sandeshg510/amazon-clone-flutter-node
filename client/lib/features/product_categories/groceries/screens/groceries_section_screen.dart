import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/global_variables.dart';
import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../search/screens/search_screen.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class GroceriesSectionScreen extends StatelessWidget with CommonWidgets {
  static const String routeName = '/groceries';

  const GroceriesSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    final Map<String, String> groceriesImages = {
      'Fruits and Vegetables':
          'https://fmtmagazine.in/wp-content/uploads/2022/03/c1-Changing-Trends-In-Fruits-Vegetables-Shopping-In-India.jpg',
      'Cooking pastes and Sauces':
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
      'Coffee & Tea & Juices':
          'https://images.pexels.com/photos/374885/pexels-photo-374885.jpeg',
      'Dry Fruits and Nuts':
          'https://media.istockphoto.com/id/1141734177/photo/assortment-of-different-types-of-nuts-in-bowls.jpg?s=1024x1024&w=is&k=20&c=FIF21jakN5MJduy0XYycO07XeXyJmiGALWqbNuOcM5E=',
      'Snacks':
          'https://eu-images.contentstack.com/v3/assets/blt58a1f8f560a1ab0e/bltd3ca50e790a5bd18/66994248291efda79b0375f0/Snacks-side_view.jpg',
      'Cooking Spices':
          'https://images.pexels.com/photos/678414/pexels-photo-678414.jpeg',
      'Cooking Oils':
          'https://media.istockphoto.com/id/1390150939/photo/woman-choosing-sunflower-oil-in-the-supermarket-close-up-of-hand-holding-bottle-of-oil-at.jpg?s=612x612&w=0&k=20&c=prIQXdN4WM0L5eCg0FjTILF7ZE6_qUH3w8oE7-vK2RA=',
      'Chocolate and Sweets':
          'https://thumbs.dreamstime.com/b/box-various-chocolate-pralines-colored-sweets-59886590.jpg',
      'Spreads':
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
      'Breakfast Foods':
          'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg',
      'Rice & Atta & Dal':
          'https://www.jiomart.com/images/product/original/492338750/atta-dal-rice-combo-chakki-atta-5-kg-toor-dal-2-kg-surti-kolam-rice-2-kg-product-images-o492338750-p590318703-0-202407051514.jpg?im=Resize=(420,420)',
    };

    final List<String> groceries =
        GlobalVariables.productHierarchy['Groceries']?.keys.toList() ?? [];

    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth < 360
        ? 90.0
        : screenWidth < 400
            ? 100.0
            : 120.0;
    final fontSize = screenWidth < 360
        ? 12.0
        : screenWidth < 400
            ? 13.0
            : 14.0;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(height: 16),
            const Text(
              'Top categories to shop from',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            verticalSpace(height: 16),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(vertical: 12),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 3.5,
                children: groceries.map((subCategory) {
                  final imageUrl = groceriesImages[subCategory] ?? '';

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final productBloc = context.read<ProductBloc>();
                      productBloc.add(FetchProductsByCategory(
                        categories: ['Groceries', subCategory],
                      ));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: productBloc,
                            child: const ProductsCatalogScreen(title: ''),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: imageHeight,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.red)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  subCategory,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
