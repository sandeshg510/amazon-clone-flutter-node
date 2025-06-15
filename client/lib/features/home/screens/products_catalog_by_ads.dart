// products_catalog_by_ads.dart
import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../../core/common/widgets/stars.dart';
import '../../product_categories/blocs/product_bloc/product_bloc.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../../search/screens/search_screen.dart';

class ProductsCatalogByAds extends StatefulWidget {
  static const String routeName = '/products-catalog-by-ads';
  const ProductsCatalogByAds({super.key});

  @override
  State<ProductsCatalogByAds> createState() => _ProductsCatalogByAdsState();
}

class _ProductsCatalogByAdsState extends State<ProductsCatalogByAds>
    with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen),
      ),
      body: _CatalogBody(
        mainCategory: routeArgs['mainCategory'] ?? '',
        subCategory: routeArgs['subCategory'] ?? '',
        subClassification: routeArgs['subClassification'] ?? '',
      ),
    );
  }
}

class _CatalogBody extends StatefulWidget {
  final String mainCategory;
  final String subCategory;
  final String subClassification;

  const _CatalogBody({
    super.key,
    required this.mainCategory,
    required this.subCategory,
    required this.subClassification,
  });

  @override
  State<_CatalogBody> createState() => __CatalogBodyState();
}

class __CatalogBodyState extends State<_CatalogBody> with CommonWidgets {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final categories = [
      if (widget.mainCategory.isNotEmpty) widget.mainCategory,
      if (widget.subCategory.isNotEmpty) widget.subCategory,
      if (widget.subClassification.isNotEmpty) widget.subClassification,
    ];

    context.read<ProductBloc>().add(
          FetchProductsByCategory(categories: categories),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildShimmerLoader();
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        } else if (state is ProductLoaded) {
          return _buildProductGrid(state.products, context);
        } else {
          return const Center(child: Text("No products found"));
        }
      },
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> productList, BuildContext context) {
    final firstProduct = productList.first;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(height: 24),
          firstProduct.subClassification == 'Watches'
              ? Image.asset(ImagePaths.instance.ragaAdPath)
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
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
                                      '\$${product.price}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '\$${product.price + 500}',
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

//   Widget _buildProductGrid(List<Product> products) {
//     if (products.isEmpty) {
//       return const Center(child: Text("No products found in this category"));
//     }
//
//     // Determine title based on available categories
//     String title;
//     if (widget.subClassification.isNotEmpty) {
//       title = "${widget.subCategory}'s ${widget.subClassification}";
//     } else if (widget.subCategory.isNotEmpty) {
//       title = widget.subCategory;
//     } else {
//       title = widget.mainCategory;
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           verticalSpace(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           verticalSpace(height: 16),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.7,
//               mainAxisSpacing: 8,
//               crossAxisSpacing: 8,
//             ),
//             itemCount: products.length,
//             itemBuilder: (context, index) => _ProductItem(
//               product: products[index],
//               onTap: () => Navigator.pushNamed(
//                 context,
//                 ProductDetailsScreen.routeName,
//                 arguments: products[index],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProductItem extends StatelessWidget {
//   final Product product;
//   final VoidCallback onTap;
//
//   const _ProductItem({
//     required this.product,
//     required this.onTap,
//   });
//
//   double get _avgRating {
//     if (product.ratings == null || product.ratings!.isEmpty) return 0;
//     final total = product.ratings!.fold(0.0, (sum, r) => sum + r.rating);
//     return total / product.ratings!.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product image
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(8)),
//                   child: Image.network(
//                     product.images.first,
//                     height: 160,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       color: Colors.grey.shade200,
//                       height: 160,
//                       child: const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 if (product.ratings != null && product.ratings!.isNotEmpty)
//                   Positioned(
//                     bottom: 8,
//                     left: 8,
//                     child: _buildRatingBadge(),
//                   ),
//               ],
//             ),
//
//             // Product details
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.brand,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Stars(rating: _avgRating),
//                       const SizedBox(width: 4),
//                       Text(
//                         '(${product.ratings?.length ?? 0})',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '\$${product.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (product.price > 500)
//                     Text(
//                       '\$${(product.price + 500).toStringAsFixed(2)}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffb02703),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       'Limited time deal',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRatingBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: Colors.orange),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             _avgRating.toStringAsFixed(1),
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 2),
//           const Icon(Icons.star, size: 14, color: Colors.orange),
//         ],
//       ),
//     );
//   }
// }
}
