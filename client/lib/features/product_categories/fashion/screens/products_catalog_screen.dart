import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../../core/common/widgets/stars.dart';
import '../../../product_details/screens/product_details_screen.dart';
import '../../../search/screens/search_screen.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class ProductsCatalogScreen extends StatefulWidget {
  final String title;
  static const String routeName = '/products-catalog';
  const ProductsCatalogScreen({super.key, required this.title});

  @override
  State<ProductsCatalogScreen> createState() => _ProductsCatalogScreenState();
}

class _ProductsCatalogScreenState extends State<ProductsCatalogScreen>
    with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final mainCategory = routeArgs?['mainCategory'] as String? ?? '';
    final subCategory = routeArgs?['subCategory'] as String? ?? '';
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
        body: _CatalogBody(
          title: widget.title,
          mainCategory: mainCategory,
          subCategory: subCategory,
        ));
  }
}

class _CatalogBody extends StatelessWidget with CommonWidgets {
  final String? title;
  final String mainCategory;
  final String subCategory;
  const _CatalogBody({
    super.key,
    required this.mainCategory,
    required this.subCategory,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        } else if (state is ProductLoaded) {
          final productList = state.products;
          print(productList);
          // Handle empty product list
          if (productList.isEmpty) {
            return const Center(
              child: Text("No products found in this category."),
            );
          }
          return _buildProductsGrid(productList, context);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildProductsGrid(List<Product> productList, BuildContext context) {
    final firstProduct = productList.first;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(height: 36),
          title != null && title!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    // Handle empty/null subClassification
                    firstProduct.subClassification?.isNotEmpty ?? false
                        ? '${firstProduct.subCategory}\'s ${firstProduct.subClassification}'
                        : firstProduct.subCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
          verticalSpace(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              children: productList.map((product) {
                try {
                  print(productList);
                  // Calculate average rating safely
                  double totalRating = 0;
                  double avgRating = 0;
                  if (product.ratings != null && product.ratings!.isNotEmpty) {
                    for (var ratingObj in product.ratings!) {
                      totalRating += ratingObj.rating;
                    }
                    avgRating = totalRating / product.ratings!.length;
                  }

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ProductDetailsScreen.routeName,
                      arguments: product,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.6,
                          color: const Color(0xffe3e3e3),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.5 - 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                product.images[0],
                                height: 260,
                                width:
                                    MediaQuery.of(context).size.width * 0.5 - 2,
                                fit: BoxFit.fitWidth,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 260,
                                      width: MediaQuery.of(context).size.width *
                                              0.5 -
                                          2,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              if (product.ratings != null &&
                                  product.ratings!.isNotEmpty)
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.orange,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    height: 30,
                                    width: 65,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          avgRating.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.orange.shade600,
                                          ),
                                        ),
                                        Text(
                                          product.ratings!.length.toString(),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.brand,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                verticalSpace(height: 5),
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalSpace(height: 10),
                                Row(
                                  children: [
                                    Stars(rating: avgRating),
                                    horizontalSpace(width: 5),
                                    Text(
                                      product.ratings?.length.toString() ?? "0",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '₹${product.price}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '₹${product.price + 500}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpace(height: 2),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffb02703),
                                  ),
                                  child: const Text(
                                    'Limited time deal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                verticalSpace(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } catch (e) {
                  // Handle rendering errors for individual products
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5 - 2,
                    padding: const EdgeInsets.all(8),
                    child: const Text("Error loading product"),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
