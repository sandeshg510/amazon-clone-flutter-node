// import 'package:amazon_clone/constants/global_variables.dart';
// import 'package:amazon_clone/core/common/widgets/basics.dart';
// import 'package:amazon_clone/core/common/widgets/custom_button.dart';
// import 'package:amazon_clone/core/common/widgets/stars.dart';
// import 'package:amazon_clone/features/address/screens/address_screen_two.dart';
// import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
// import 'package:amazon_clone/features/product_details/widgets/product_carousel.dart';
// import 'package:amazon_clone/models/product.dart';
// import 'package:amazon_clone/models/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// import '../../../constants/bloc/user_bloc/user_bloc.dart';
// import '../../../constants/utils.dart';
// import '../../search/screens/search_screen.dart';
// import '../blocs/product_details_bloc.dart';
//
// class ProductDetailsScreen extends StatefulWidget {
//   const ProductDetailsScreen({super.key, required this.product});
//
//   static const String routeName = '/product-details';
//   final Product product;
//
//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }
//
// class _ProductDetailsScreenState extends State<ProductDetailsScreen>
//     with CommonWidgets {
//   double avgRating = 0;
//   double myRating = 0;
//   late User currentUser;
//   int selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     currentUser = context.currentUser;
//     _calculateRatings();
//   }
//
//   void _calculateRatings() {
//     double totalRating = 0;
//     for (var ratingObj in widget.product.ratings!) {
//       totalRating += ratingObj.rating;
//       if (ratingObj.userId == currentUser.id) {
//         myRating = ratingObj.rating;
//       }
//     }
//     if (totalRating != 0) {
//       avgRating = totalRating / widget.product.ratings!.length;
//     }
//   }
//
//   void navigateToSearchScreen(String query) {
//     Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
//   }
//
//   void navigateToAddressScreen() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => AddressScreenTwo(
//                 totalAmount: widget.product.price.toString())));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProductDetailsBloc(),
//       child: BlocListener<ProductDetailsBloc, ProductDetailsState>(
//         listener: (context, state) {
//           if (state is AddToCartSuccess) {
//             context
//                 .read<UserBloc>()
//                 .add(UpdateUserCart(state.updatedUser.cart));
//             showSnackBar(context, 'Added to cart successfully');
//           }
//           if (state is AddToCartFailure) {
//             showSnackBar(context, state.error);
//           }
//           if (state is RateProductSuccess) {
//             final newProduct = widget.product.copyWith(
//               ratings: state.updatedProduct.ratings,
//             );
//             setState(() {
//               widget.product.ratings = newProduct.ratings;
//               _calculateRatings();
//             });
//             showSnackBar(context, 'Rating submitted successfully');
//           }
//           if (state is RateProductFailure) {
//             showSnackBar(context, state.error);
//           }
//         },
//         child: Scaffold(
//           appBar: PreferredSize(
//               preferredSize: const Size.fromHeight(60),
//               child: AppBar(
//                 automaticallyImplyLeading: false,
//                 flexibleSpace: Container(
//                   decoration: const BoxDecoration(
//                       gradient: GlobalVariables.appBarGradient),
//                 ),
//                 title: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Container(
//                               height: 42,
//                               margin: const EdgeInsets.only(left: 15),
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(7),
//                                 child: TextFormField(
//                                   onFieldSubmitted: navigateToSearchScreen,
//                                   decoration: const InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       contentPadding: EdgeInsets.only(top: 10),
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(7))),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black38, width: 1),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(7))),
//                                       hintText: 'Search Amazon.in',
//                                       hintStyle: TextStyle(
//                                           color: Colors.black45,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 17),
//                                       prefixIcon: InkWell(
//                                         child: Padding(
//                                           padding: EdgeInsets.only(left: 6.0),
//                                           child: Icon(
//                                             Icons.search,
//                                             color: Colors.black,
//                                             size: 23,
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                               )),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                                 color: Colors.transparent,
//                                 alignment: Alignment.topLeft,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 child: const Icon(Icons.mic)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 verticalSpace(height: 14),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.product.name,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Stars(rating: avgRating),
//                               horizontalSpace(width: 5),
//                               Text(widget.product.ratings!.length.toString()),
//                             ],
//                           ),
//                           verticalSpace(height: 20),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 ProductCarousel(product: widget.product),
//                 verticalSpace(height: 16),
//                 Container(
//                   color: Colors.grey.shade200,
//                   height: 5,
//                   width: double.infinity,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       verticalSpace(height: 16),
//                       widget.product.colour!.isNotEmpty
//                           ? Row(
//                               children: [
//                                 const Text('Colour: '),
//                                 Text(
//                                   widget.product.colour!,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             )
//                           : horizontalSpace(width: 0),
//                       verticalSpace(height: 8),
//                       widget.product.sizes!.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Size:'),
//                                 verticalSpace(height: 12),
//                                 SizedBox(
//                                   height: 45,
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: widget.product.sizes!.length,
//                                     itemBuilder: (context, index) {
//                                       final isSelected = selectedIndex == index;
//
//                                       return GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedIndex = index;
//                                           });
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           height: 45,
//                                           width: 45,
//                                           decoration: BoxDecoration(
//                                             color: isSelected
//                                                 ? Colors.black
//                                                 : Colors.transparent,
//                                             border: Border.all(
//                                               color: isSelected
//                                                   ? Colors.black
//                                                   : Colors.grey,
//                                               width: isSelected ? 2 : 1,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                           ),
//                                           child: Text(
//                                             widget.product.sizes![index],
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w800,
//                                               color: isSelected
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     separatorBuilder: (_, __) =>
//                                         horizontalSpace(width: 10),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : horizontalSpace(width: 0),
//                       verticalSpace(height: 8),
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffb02703),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'Limited time deal',
//                           style: TextStyle(fontSize: 12, color: Colors.white),
//                         ),
//                       ),
//                       verticalSpace(height: 8),
//                       RichText(
//                         text: TextSpan(
//                           text: "-62% ",
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Color(0xffb02703),
//                           ),
//                           children: [
//                             TextSpan(
//                               text: "${widget.product.price}",
//                               style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             const TextSpan(
//                               text: " ₹",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       verticalSpace(height: 12),
//                       const Text('FREE delivery'),
//                       verticalSpace(height: 8),
//                       Text(
//                         'In Stock',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.green.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 verticalSpace(height: 16),
//                 Container(
//                   color: Colors.grey.shade200,
//                   height: 5,
//                   width: double.infinity,
//                 ),
//                 verticalSpace(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
//                     builder: (context, state) {
//                       return CustomButton(
//                           title: 'Add to Cart',
//                           onTap: () {
//                             final userBloc = context.read<UserBloc>();
//                             if (state is! AddingToCart) {
//                               context.read<ProductDetailsBloc>().add(
//                                     AddToCartEvent(
//                                         widget.product, currentUser, userBloc),
//                                   );
//                             }
//                           },
//                           isLoading: state is AddingToCart,
//                           color: const Color.fromRGBO(254, 216, 19, 1));
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: CustomButton(
//                     onTap: navigateToAddressScreen,
//                     title: 'Buy Now',
//                   ),
//                 ),
//                 verticalSpace(height: 10),
//                 Container(
//                   color: Colors.black12,
//                   height: 5,
//                   width: double.infinity,
//                 ),
//                 widget.product.about!.isNotEmpty &&
//                         widget.product.description.isNotEmpty &&
//                         widget.product.inTheBox!.isNotEmpty
//                     ? Column(
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             child: Text(
//                               'Product details',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           verticalSpace(height: 20),
//                           Container(
//                             color: Colors.black,
//                             height: 0.2,
//                             width: double.infinity,
//                           ),
//                         ],
//                       )
//                     : horizontalSpace(width: 0),
//                 verticalSpace(height: 12),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       widget.product.about!.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'About this item',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 verticalSpace(height: 4),
//                                 Text(widget.product.about!),
//                               ],
//                             )
//                           : horizontalSpace(width: 0),
//                       verticalSpace(height: 20),
//                       widget.product.description.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Description',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 verticalSpace(height: 4),
//                                 Text(widget.product.description),
//                               ],
//                             )
//                           : horizontalSpace(width: 0),
//                       widget.product.inTheBox!.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'What\'s in the box?',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 verticalSpace(height: 4),
//                                 Text(widget.product.inTheBox!),
//                               ],
//                             )
//                           : horizontalSpace(width: 0),
//                       verticalSpace(height: 24),
//                       const Text(
//                         'Rate The Product',
//                         style: TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.w600),
//                       ),
//                       RatingBar.builder(
//                         initialRating: myRating,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemPadding: const EdgeInsets.symmetric(horizontal: 4),
//                         itemBuilder: (context, _) => const Icon(
//                           Icons.star,
//                           color: GlobalVariables.secondaryColor,
//                         ),
//                         onRatingUpdate: (rating) {
//                           context.read<ProductDetailsBloc>().add(
//                                 RateProductEvent(
//                                     widget.product, rating, currentUser),
//                               );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/stars.dart';
import 'package:amazon_clone/features/address/screens/address_screen_two.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:amazon_clone/features/product_details/widgets/product_carousel.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants/bloc/user_bloc/user_bloc.dart';
import '../../../constants/utils.dart';
import '../../../core/common/widgets/common_app_bar.dart';
import '../../search/screens/search_screen.dart';
import '../blocs/product_details_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  static const String routeName = '/product-details';
  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with CommonWidgets {
  double avgRating = 0;
  double myRating = 0;
  late User currentUser;
  int selectedIndex = 0;
  late Product _currentProduct; // Local mutable copy of the product

  @override
  void initState() {
    super.initState();
    currentUser = context.currentUser;
    _currentProduct = widget.product; // Initialize with widget's product
    _calculateRatings();
  }

  void _calculateRatings() {
    double totalRating = 0;
    if (_currentProduct.ratings == null || _currentProduct.ratings!.isEmpty) {
      avgRating = 0;
      myRating = 0;
      return;
    }

    for (var ratingObj in _currentProduct.ratings!) {
      totalRating += ratingObj.rating;
      if (ratingObj.userId == currentUser.id) {
        myRating = ratingObj.rating;
      }
    }
    avgRating = totalRating / _currentProduct.ratings!.length;
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddressScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressScreenTwo(
                  totalAmount: _currentProduct.price.toString(),
                  product: widget.product,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<ProductDetailsBloc, ProductDetailsState>(
              listener: (context, state) {
                if (state is AddToCartSuccess) {
                  context
                      .read<UserBloc>()
                      .add(UpdateUserCart(state.updatedUser.cart));
                  showSnackBar(context, 'Added to cart successfully');
                }
                if (state is AddToCartFailure) {
                  showSnackBar(context, state.error);
                }
                if (state is RateProductSuccess) {
                  print(
                      'Received updated product with ratings: ${state.updatedProduct.ratings?.length}');

                  // Update local product with new ratings
                  setState(() {
                    _currentProduct = state.updatedProduct;
                    _calculateRatings();
                  });

                  showSnackBar(context, 'Rating submitted successfully');
                }
                if (state is RateProductFailure) {
                  // showSnackBar(context, state.error);
                  print(state.error);
                }
              },
              child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child:
                        CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _currentProduct.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Stars(rating: avgRating),
                                    horizontalSpace(width: 5),
                                    Text(_currentProduct.ratings?.length
                                            .toString() ??
                                        "0"),
                                  ],
                                ),
                                verticalSpace(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ProductCarousel(product: _currentProduct),
                      verticalSpace(height: 16),
                      Container(
                        color: Colors.grey.shade200,
                        height: 5,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(height: 16),
                            _currentProduct.colour!.isNotEmpty
                                ? Row(
                                    children: [
                                      const Text('Colour: '),
                                      Text(
                                        _currentProduct.colour!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                : horizontalSpace(width: 0),
                            verticalSpace(height: 8),
                            _currentProduct.sizes!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Size:'),
                                      verticalSpace(height: 12),
                                      SizedBox(
                                        height: 45,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              _currentProduct.sizes!.length,
                                          itemBuilder: (context, index) {
                                            final isSelected =
                                                selectedIndex == index;

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    width: isSelected ? 2 : 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  _currentProduct.sizes![index],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (_, __) =>
                                              horizontalSpace(width: 10),
                                        ),
                                      ),
                                    ],
                                  )
                                : horizontalSpace(width: 0),
                            verticalSpace(height: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xffb02703),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Limited time deal',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                            verticalSpace(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  '-62% ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xffb02703),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 13.0),
                                  child: Text(
                                    ' ₹',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text('${_currentProduct.price}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                            verticalSpace(height: 12),
                            const Text('FREE delivery'),
                            verticalSpace(height: 8),
                            Text(
                              'In Stock',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(height: 16),
                      Container(
                        color: Colors.grey.shade200,
                        height: 5,
                        width: double.infinity,
                      ),
                      verticalSpace(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BlocBuilder<ProductDetailsBloc,
                            ProductDetailsState>(
                          builder: (context, state) {
                            return CustomButton(
                                title: 'Add to Cart',
                                onTap: () {
                                  final userBloc = context.read<UserBloc>();
                                  if (state is! AddingToCart) {
                                    context.read<ProductDetailsBloc>().add(
                                          AddToCartEvent(_currentProduct,
                                              currentUser, userBloc),
                                        );
                                  }
                                },
                                isLoading: state is AddingToCart,
                                color: const Color.fromRGBO(254, 216, 19, 1));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: CustomButton(
                          onTap: navigateToAddressScreen,
                          title: 'Buy Now',
                        ),
                      ),
                      verticalSpace(height: 10),
                      Container(
                        color: Colors.black12,
                        height: 5,
                        width: double.infinity,
                      ),
                      _currentProduct.about!.isNotEmpty &&
                              _currentProduct.description.isNotEmpty &&
                              _currentProduct.inTheBox!.isNotEmpty
                          ? Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Text(
                                    'Product details',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                verticalSpace(height: 20),
                                Container(
                                  color: Colors.black,
                                  height: 0.2,
                                  width: double.infinity,
                                ),
                              ],
                            )
                          : horizontalSpace(width: 0),
                      verticalSpace(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _currentProduct.about!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'About this item',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      verticalSpace(height: 4),
                                      Text(_currentProduct.about!),
                                    ],
                                  )
                                : horizontalSpace(width: 0),
                            verticalSpace(height: 20),
                            _currentProduct.description.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      verticalSpace(height: 4),
                                      Text(_currentProduct.description),
                                    ],
                                  )
                                : horizontalSpace(width: 0),
                            _currentProduct.inTheBox!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'What\'s in the box?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      verticalSpace(height: 4),
                                      Text(_currentProduct.inTheBox!),
                                    ],
                                  )
                                : horizontalSpace(width: 0),
                            verticalSpace(height: 24),
                            const Text(
                              'Rate The Product',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: RatingBar.builder(
                                      initialRating: myRating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      glow: true,
                                      glowColor: GlobalVariables.secondaryColor
                                          .withOpacity(0.4),
                                      unratedColor: Colors.grey.shade300,
                                      itemSize: 36,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star_rounded,
                                        color: GlobalVariables.secondaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        context.read<ProductDetailsBloc>().add(
                                              RateProductEvent(_currentProduct,
                                                  rating, currentUser),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )

                            // RatingBar.builder(
                            //   initialRating: myRating,
                            //   minRating: 1,
                            //   direction: Axis.horizontal,
                            //   allowHalfRating: true,
                            //   itemCount: 5,
                            //   itemPadding:
                            //       const EdgeInsets.symmetric(horizontal: 4),
                            //   itemBuilder: (context, _) => const Icon(
                            //     Icons.star,
                            //     color: GlobalVariables.secondaryColor,
                            //   ),
                            //   onRatingUpdate: (rating) {
                            //     context.read<ProductDetailsBloc>().add(
                            //           RateProductEvent(
                            //               _currentProduct, rating, currentUser),
                            //         );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
