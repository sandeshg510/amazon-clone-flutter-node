// import 'package:amazon_clone/core/common/widgets/basics.dart';
// import 'package:amazon_clone/core/common/widgets/stars.dart';
// import 'package:amazon_clone/features/product_details/screens/fashion_product_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../constants/global_variables.dart';
// import '../../../core/common/widgets/loader.dart';
// import '../../search/screens/search_screen.dart';
// import '../blocs/category_products_bloc/category_products_bloc.dart';
// import '../blocs/category_products_bloc/category_products_state.dart';
//
// class FashionSectionScreen extends StatefulWidget {
//   final String category;
//   static const String routeName = '/fashion-section';
//   final VoidCallback onInit;
//
//   const FashionSectionScreen({
//     super.key,
//     required this.category,
//     required this.onInit,
//   });
//
//   @override
//   State<FashionSectionScreen> createState() => _FashionSectionScreenState();
// }
//
// class _FashionSectionScreenState extends State<FashionSectionScreen>
//     with CommonWidgets {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => widget.onInit());
//   }
//
//   void navigateToSearchScreen(String query) {
//     Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
//   }
//
//   final List<String> menCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Men'] ?? [];
//
//   final List<String> womenCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Women'] ?? [];
//   final List<String> kidsCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Kids'] ?? [];
//   final List<String> footwearCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Footwear'] ?? [];
//   final List<String> accessoriesCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Accessories'] ?? [];
//   final List<String> beautyCategories =
//       GlobalVariables.productHierarchy['Fashion']?['Beauty'] ?? [];
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: AppBar(
//             flexibleSpace: Container(
//               decoration:
//                   const BoxDecoration(gradient: GlobalVariables.appBarGradient),
//             ),
//             title: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                           height: 42,
//                           child: Material(
//                             borderRadius: BorderRadius.circular(7),
//                             child: TextFormField(
//                               onFieldSubmitted: navigateToSearchScreen,
//                               decoration: const InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   contentPadding: EdgeInsets.only(top: 10),
//                                   border: OutlineInputBorder(
//                                       borderSide: BorderSide.none,
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(7))),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.black38, width: 1),
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(7))),
//                                   hintText: 'Search Amazon.in',
//                                   hintStyle: TextStyle(
//                                       color: Colors.black45,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 17),
//                                   prefixIcon: InkWell(
//                                     child: Padding(
//                                       padding: EdgeInsets.only(left: 6.0),
//                                       child: Icon(
//                                         Icons.search,
//                                         color: Colors.black,
//                                         size: 23,
//                                       ),
//                                     ),
//                                   )),
//                             ),
//                           )),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                             color: Colors.transparent,
//                             alignment: Alignment.topLeft,
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: const Icon(Icons.mic)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )),
//       body: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
//         builder: (context, state) {
//           if (state is CategoryProductsLoading) {
//             return const Loader();
//           } else if (state is CategoryProductsLoaded) {
//             final productList = state.products;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Men',
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: menCategories.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                                 alignment: Alignment.center,
//                                 height: 40,
//                                 width: 90,
//                                 color: Colors.grey,
//                                 child: Text(menCategories[index]));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return horizontalSpace(width: 10);
//                           },
//                         ),
//                       ),
//                       verticalSpace(height: 10),
//                       const Text(
//                         'Women',
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: womenCategories.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                                 alignment: Alignment.center,
//                                 height: 40,
//                                 width: 90,
//                                 color: Colors.grey,
//                                 child: Text(womenCategories[index]));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return horizontalSpace(width: 10);
//                           },
//                         ),
//                       ),
//                       verticalSpace(height: 10),
//                       const Text(
//                         'Kids',
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: kidsCategories.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                                 alignment: Alignment.center,
//                                 height: 40,
//                                 width: 90,
//                                 color: Colors.grey,
//                                 child: Text(kidsCategories[index]));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return horizontalSpace(width: 10);
//                           },
//                         ),
//                       ),
//                       verticalSpace(height: 10),
//                     ],
//                   ),
//                 ),
//                 verticalSpace(height: 36),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 16.0),
//                   child: Text(
//                     'T-shirts, Shirts & Polos',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//                   ),
//                 ),
//                 verticalSpace(height: 24),
//                 Row(
//                   children: [
//                     horizontalSpace(width: 8),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 35,
//                         width: 120,
//                         color: const Color(0xfff8f3ed),
//                         child: const Text(
//                           'BestSellers',
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     horizontalSpace(width: 8),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 35,
//                         width: 120,
//                         color: const Color(0xfff8f3ed),
//                         child: const Text(
//                           'T-Shirts',
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     horizontalSpace(width: 8),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 35,
//                         width: 120,
//                         color: const Color(0xfff8f3ed),
//                         child: const Text(
//                           'Casual Shirts',
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 verticalSpace(height: 12),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                       child: Wrap(
//                         spacing: 0,
//                         runSpacing: 0,
//                         children: productList.map((product) {
//                           double totalRating = 0;
//                           double avgRating = 0;
//
//                           for (var ratingObj in product.ratings!) {
//                             totalRating += ratingObj.rating;
//
//                             if (totalRating != 0) {
//                               avgRating = totalRating / product.ratings!.length;
//                             }
//                           }
//                           return GestureDetector(
//                             onTap: () => Navigator.pushNamed(
//                               context,
//                               FashionProductDetailsScreen.routeName,
//                               arguments: product,
//                             ),
//                             child: Container(
//                               alignment: Alignment.topCenter,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       width: 0.6,
//                                       color: const Color(0xffe3e3e3))),
//                               width: size.width * 0.500 - 2,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Stack(children: [
//                                     const SizedBox(),
//                                     Image.network(
//                                       height: 260,
//                                       width: size.width * 0.5 - 2,
//                                       product.images[0],
//                                       fit: BoxFit.cover,
//                                     ),
//                                     if (product.ratings!.isEmpty)
//                                       const SizedBox()
//                                     else
//                                       Positioned(
//                                           bottom: 10,
//                                           left: 10,
//                                           child: Container(
//                                               alignment: Alignment.center,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   border: Border.all(
//                                                       width: 0.2,
//                                                       color: Colors.orange),
//                                                   borderRadius:
//                                                       BorderRadius.circular(4)),
//                                               height: 30,
//                                               width: 65,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.end,
//                                                 children: [
//                                                   Text(
//                                                     avgRating
//                                                         .toStringAsFixed(2),
//                                                     style: const TextStyle(
//                                                         fontSize: 11),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 2.0),
//                                                     child: Icon(
//                                                       Icons.star,
//                                                       size: 18,
//                                                       color: Colors
//                                                           .orange.shade600,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     product.ratings!.length
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontSize: 11),
//                                                   ),
//                                                 ],
//                                               )))
//                                   ]),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 5),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.brand,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         verticalSpace(height: 5),
//                                         Text(
//                                           product.name,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         verticalSpace(height: 10),
//                                         Row(
//                                           children: [
//                                             Stars(rating: avgRating),
//                                             horizontalSpace(width: 5),
//                                             Text(
//                                               product.ratings!.length
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.grey.shade500),
//                                             )
//                                           ],
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '\$${product.price}',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 5),
//                                             Text(
//                                               '\$${product.price + 500}',
//                                               style: TextStyle(
//                                                 color: Colors.grey.shade600,
//                                                 fontSize: 12,
//                                                 decoration:
//                                                     TextDecoration.lineThrough,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         verticalSpace(height: 2),
//                                         Container(
//                                           padding: const EdgeInsets.all(6),
//                                           decoration: const BoxDecoration(
//                                               color: Color(0xffb02703)),
//                                           child: const Text(
//                                             'Limited time deal',
//                                             style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.white),
//                                           ),
//                                         ),
//                                         verticalSpace(height: 8)
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else if (state is CategoryProductsError) {
//             return Center(child: Text('Error: ${state.message}'));
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
//
// // Material(
// // elevation: 1,
// // borderRadius: BorderRadius.circular(10),
// // child: Container(
// // alignment: Alignment.topCenter,
// // height: 340,
// // width: size.width * 0.4951,
// // decoration: BoxDecoration(
// // color: Colors.black,
// // borderRadius: BorderRadius.circular(8),
// // ),
// // child: Column(
// // children: [
// // Expanded(
// // flex: 9,
// // child: ClipRRect(
// // borderRadius: const BorderRadius.only(
// // topLeft: Radius.circular(8),
// // topRight: Radius.circular(8),
// // ),
// // child: Image.network(
// // product.images[0],
// // fit: BoxFit.contain,
// // ),
// // ),
// // ),
// // Expanded(
// // flex: 6,
// // child: Container(
// // alignment: Alignment.center,
// // decoration: BoxDecoration(
// // color: Colors.white,
// // border: Border.all(
// // width: 0.02, color: Colors.grey),
// // borderRadius: const BorderRadius.only(
// // bottomRight: Radius.circular(10),
// // bottomLeft: Radius.circular(10),
// // ),
// // ),
// // child: Text(
// // product.name,
// // textAlign: TextAlign.center,
// // style: const TextStyle(
// // fontSize: 10,
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // ),
// // ],
// // ),
// // ),
// // );
