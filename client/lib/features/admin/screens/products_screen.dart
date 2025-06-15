import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/add_products_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/product.dart';
import '../blocs/admin_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static const String routeName = '/admin-products';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late AdminBloc adminBloc = context.read<AdminBloc>();

  @override
  void initState() {
    Future.microtask(() => adminBloc.add(FetchAllProductsEvent()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is ProductAddSuccess || state is ProductDeleteSuccess) {
          context.read<AdminBloc>().add(FetchAllProductsEvent());
        }
        if (state is ProductOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: GlobalVariables.selectedNavBarColor,
            onPressed: _navigateToAddProducts,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.add, size: 32),
          ),
        );
      },
    );
  }

  Widget _buildBody(AdminState state) {
    if (state is ProductOperationLoading || state is ProductsLoading) {
      return _buildShimmerLoader();
    }
    if (state is ProductsLoadSuccess) {
      return _buildProductsGrid(state.products);
    }
    if (state is ProductOperationFailure) {
      return Center(child: Text('Error: ${state.error}'));
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProductsGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade100, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Hero(
                    tag: product.id!,
                    child: SingleProduct(image: product.images.first),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _buildDeleteButton(product.id!),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(String productId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _deleteProduct(context, productId),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _navigateToAddProducts() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlocProvider.value(
          value: adminBloc,
          child: const AddProductsScreen(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _deleteProduct(BuildContext context, String productId) {
    context.read<AdminBloc>().add(DeleteProductEvent(productId));
  }
}

class SingleProduct extends StatelessWidget {
  const SingleProduct({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const ShimmerLoader(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}

// import 'package:amazon_clone/constants/global_variables.dart';
// import 'package:amazon_clone/features/admin/screens/add_products_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../models/product.dart';
// import '../blocs/admin_bloc.dart';
//
// class ProductsScreen extends StatefulWidget {
//   const ProductsScreen({super.key});
//   static const String routeName = '/admin-products';
//
//   @override
//   State<ProductsScreen> createState() => _ProductsScreenState();
// }
//
// class _ProductsScreenState extends State<ProductsScreen> {
//   late AdminBloc adminBloc = context.read<AdminBloc>();
//
//   @override
//   void initState() {
//     Future.microtask(() => adminBloc.add(FetchAllProductsEvent()));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AdminBloc, AdminState>(
//       listener: (context, state) {
//         if (state is ProductAddSuccess || state is ProductDeleteSuccess) {
//           context.read<AdminBloc>().add(FetchAllProductsEvent());
//         }
//         if (state is ProductOperationFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: _buildBody(state),
//           floatingActionButton: FloatingActionButton(
//             backgroundColor: GlobalVariables.selectedNavBarColor,
//             onPressed: _navigateToAddProducts,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.add, size: 32),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBody(AdminState state) {
//     if (state is ProductOperationLoading || state is ProductsLoading) {
//       return _buildShimmerLoader();
//     }
//     if (state is ProductsLoadSuccess) {
//       return _buildProductsGrid(state.products);
//     }
//     if (state is ProductOperationFailure) {
//       return Center(child: Text('Error: ${state.error}'));
//     }
//     return const Center(child: CircularProgressIndicator());
//   }
//
//   Widget _buildProductsGrid(List<Product> products) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: GridView.builder(
//         physics: const BouncingScrollPhysics(),
//         itemCount: products.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.75,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//         ),
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return _buildProductCard(product);
//         },
//       ),
//     );
//   }
//
//   Widget _buildProductCard(Product product) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.grey.shade100, Colors.white],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: Hero(
//                     tag: product.id!,
//                     child: SingleProduct(image: product.images.first),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Text(
//                     product.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 8,
//             right: 8,
//             child: _buildDeleteButton(product.id!),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDeleteButton(String productId) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () => _deleteProduct(context, productId),
//         child: Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Colors.red.withOpacity(0.9),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child:
//               const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmerLoader() {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 6,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.75,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//       ),
//       itemBuilder: (context, index) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             color: Colors.white,
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.grey.shade200,
//                           Colors.grey.shade100,
//                           Colors.grey.shade200,
//                         ],
//                         stops: const [0.1, 0.5, 0.9],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _navigateToAddProducts() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             BlocProvider.value(
//           value: adminBloc,
//           child: const AddProductsScreen(),
//         ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//       ),
//     );
//   }
//
//   void _deleteProduct(BuildContext context, String productId) {
//     context.read<AdminBloc>().add(DeleteProductEvent(productId));
//   }
// }
//
// // Updated SingleProduct widget
// class SingleProduct extends StatelessWidget {
//   const SingleProduct({super.key, required this.image});
//
//   final String image;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: FadeInImage.assetNetwork(
//                 placeholder: 'assets/placeholder.png',
//                 image: image,
//                 fit: BoxFit.cover,
//                 imageErrorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.error),
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.1),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:amazon_clone/constants/global_variables.dart';
// // import 'package:amazon_clone/features/account/widgets/single_product.dart';
// // import 'package:amazon_clone/features/admin/screens/add_products_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// //
// // import '../../../core/common/widgets/basics.dart';
// // import '../../../models/product.dart';
// // import '../blocs/admin_bloc.dart';
// //
// // class ProductsScreen extends StatefulWidget {
// //   const ProductsScreen({super.key});
// //   static const String routeName = '/admin-products';
// //
// //   @override
// //   State<ProductsScreen> createState() => _ProductsScreenState();
// // }
// //
// // class _ProductsScreenState extends State<ProductsScreen> with CommonWidgets {
// //   late AdminBloc adminBloc = context.read<AdminBloc>();
// //   @override
// //   void initState() {
// //     Future.microtask(() => adminBloc.add(FetchAllProductsEvent()));
// //
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     void navigateToAddProducts() {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => BlocProvider.value(
// //             value: adminBloc,
// //             child: const AddProductsScreen(),
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return BlocConsumer<AdminBloc, AdminState>(
// //       listener: (context, state) {
// //         if (state is ProductAddSuccess || state is ProductDeleteSuccess) {
// //           context.read<AdminBloc>().add(FetchAllProductsEvent());
// //         }
// //         if (state is ProductOperationFailure) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(state.error)),
// //           );
// //         }
// //       },
// //       builder: (context, state) {
// //         return Scaffold(
// //           body: _buildBody(state),
// //           floatingActionButton: FloatingActionButton(
// //             backgroundColor: GlobalVariables.selectedNavBarColor,
// //             onPressed: navigateToAddProducts,
// //             tooltip: 'Add a Product',
// //             child: const Icon(Icons.add),
// //           ),
// //           floatingActionButtonLocation:
// //               FloatingActionButtonLocation.centerFloat,
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildBody(AdminState state) {
// //     if (state is ProductOperationLoading) {
// //       return const Center(child: CircularProgressIndicator());
// //     }
// //
// //     if (state is ProductsLoadSuccess) {
// //       return _buildProductsGrid(state.products);
// //     }
// //
// //     if (state is ProductsLoading) {
// //       // Add this state check
// //       return const Center(child: CircularProgressIndicator());
// //     }
// //
// //     if (state is ProductOperationFailure) {
// //       return Center(child: Text('Error: ${state.error}'));
// //     }
// //
// //     return const Center(child: CircularProgressIndicator());
// //   }
// //
// //   Widget _buildProductsGrid(List<Product> products) {
// //     return GridView.builder(
// //       padding: const EdgeInsets.all(10),
// //       itemCount: products.length,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2,
// //         childAspectRatio: 0.85,
// //         mainAxisSpacing: 10,
// //         crossAxisSpacing: 10,
// //       ),
// //       itemBuilder: (context, index) {
// //         final product = products[index];
// //         return Card(
// //           elevation: 2,
// //           child: Column(
// //             children: [
// //               Expanded(
// //                 child: product.images.isNotEmpty
// //                     ? SingleProduct(image: product.images.first)
// //                     : const Placeholder(),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Expanded(
// //                       child: Text(
// //                         product.name,
// //                         overflow: TextOverflow.ellipsis,
// //                         maxLines: 2,
// //                         style: const TextStyle(fontSize: 12),
// //                       ),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.delete_outline, size: 20),
// //                       onPressed: () => _deleteProduct(context, product.id!),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   void _deleteProduct(BuildContext context, String productId) {
// //     context.read<AdminBloc>().add(DeleteProductEvent(productId));
// //   }
// // }
