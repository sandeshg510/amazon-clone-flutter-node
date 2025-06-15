// import 'package:amazon_clone/core/common/widgets/basics.dart';
// import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../constants/global_variables.dart';
// import '../../../core/common/widgets/loader.dart';
//
// class CategoryDealsScreen extends StatefulWidget {
//   final String category;
//   static const String routeName = '/category-deals';
//   final VoidCallback onInit;
//
//   const CategoryDealsScreen({
//     super.key,
//     required this.category,
//     required this.onInit,
//   });
//
//   @override
//   State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
// }
//
// class _CategoryDealsScreenState extends State<CategoryDealsScreen>
//     with CommonWidgets {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => widget.onInit());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: GlobalVariables.fashionBodyColor,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50),
//         child: AppBar(
//           flexibleSpace: const DecoratedBox(
//             decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
//           ),
//           title: Text(widget.category),
//         ),
//       ),
//       body:  Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 widget.category == 'Fashion'
//                     ? verticalSpace(height: 5)
//                     : Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 10),
//                         child: Text(
//                           'Keep shopping for ${widget.category}',
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                       ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 1.0),
//                       child: Wrap(
//                         spacing: 4,
//                         runSpacing: 4,
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
//                               ProductDetailsScreen.routeName,
//                               arguments: product,
//                             ),
//                             child: Container(
//                               alignment: Alignment.topCenter,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               width: size.width * 0.497 - 2,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Stack(children: [
//                                     const SizedBox(),
//                                     ClipRRect(
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(8),
//                                         topRight: Radius.circular(8),
//                                       ),
//                                       child: Image.network(
//                                         height: 260,
//                                         width: size.width * 0.5 - 2,
//                                         product.images[0],
//                                         fit: BoxFit.cover,
//                                       ),
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
//                                         horizontal: 15, vertical: 5),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.name,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         Text(
//                                           product.description,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                               color: Colors.grey.shade600,
//                                               fontSize: 13),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '\$${product.price}',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.red.shade800,
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
//                                         verticalSpace(height: 2)
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
