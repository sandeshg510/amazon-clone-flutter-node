import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/home/widgets/sponsored_widget.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/screens/products_catalog_by_ads.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class FashionHomeBody extends StatefulWidget {
  const FashionHomeBody({super.key});

  @override
  State<FashionHomeBody> createState() => _FashionHomeBodyState();
}

class _FashionHomeBodyState extends State<FashionHomeBody> with CommonWidgets {
  int _selectedCategoryIndex = -1;
  int _selectedSubcategoryIndex = -1;

  // Only categories with subcategories
  final List<String> _mainCategories = ['Men', 'Women', 'Kids'];

  final Map<String, List<String>> _fashionSubcategories =
      GlobalVariables.productHierarchy['Fashion']!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          verticalSpace(height: 20),
          _buildCategoryNavigation(),
          _buildSubcategoryGrid(),
          verticalSpace(height: 12),
          SponsoredWidget(
            image: ImagePaths.instance.fashionAdPath,
            onTap: () => Navigator.pushNamed(
              context,
              ProductsCatalogByAds.routeName,
              arguments: {
                'mainCategory': 'Fashion',
                'subCategory': 'Men',
                'subClassification': 'Bags',
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryGrid() {
    if (_selectedCategoryIndex == -1) return const SizedBox.shrink();

    final currentCategory = _mainCategories[_selectedCategoryIndex];
    final subcategories = _fashionSubcategories[currentCategory] ?? [];

    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalMargin = 32; // 16 left + 16 right
    const spacing = 12 * 3; // 3 gaps between 4 items
    final availableWidth = screenWidth - horizontalMargin - spacing;
    final itemWidth = availableWidth / 4;

    // Scale down icon and font based on screen width
    final iconSize = itemWidth.clamp(48.0, 60.0);
    final fontSize = (itemWidth / 5.5).clamp(9.0, 11.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 0.7),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: itemWidth / (itemWidth + 24),
          children: List.generate(subcategories.length, (index) {
            final subcategory = subcategories[index];
            final key = '$currentCategory-$subcategory';
            final imageUrl = GlobalVariables.fashionCategoryImages[key] ??
                'https://via.placeholder.com/150';
            final isSelected = _selectedSubcategoryIndex == index;

            return GestureDetector(
              onTap: () {
                final productBloc = context.read<ProductBloc>();
                productBloc.add(FetchProductsByCategory(
                  categories: ['Fashion', currentCategory, subcategory],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? iconSize * 0.85 : iconSize,
                    height: isSelected ? iconSize * 0.85 : iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.grey : Colors.grey.shade300,
                        width: 0.7,
                      ),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subcategory,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryNavigation() {
    final categoryNames = _mainCategories;

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categoryNames.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, index) {
          final name = categoryNames[index];
          final imageUrl = GlobalVariables.mainCategoryImages[name]!;
          final isSelected = _selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
                _selectedSubcategoryIndex = -1;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 90 : 70,
                  height: isSelected ? 90 : 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.grey : Colors.grey.shade200,
                      width: 0.5,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w100,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
