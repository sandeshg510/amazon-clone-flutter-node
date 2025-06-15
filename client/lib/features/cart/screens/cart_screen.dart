import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/core/common/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/bloc/user_bloc/user_bloc.dart';
import '../../../constants/bloc/user_bloc/user_state.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../address/screens/address_screen.dart';
import '../../home/widgets/address_box.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            return const Loader();
          } else if (state is UserLoaded) {
            final user = state.user;

            int sum = 0;
            for (var item in user.cart) {
              sum += item['quantity'] * item['product']['price'] as int;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddressBox(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subtotal ',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Text(
                        '₹',
                        style: TextStyle(
                          height: 1.8,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$sum',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  '   EMI Available',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                if (sum > 499)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                horizontalSpace(width: 10),
                                const Text(
                                  '₹499 ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            verticalSpace(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                  size: 20,
                                ),
                                Text(
                                  ' Your order is eligible for FREE Delivery.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(height: 16),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    onTap: () => navigateToAddressScreen(sum.toInt()),
                    color: GlobalVariables.yellowColor,
                    title: 'Proceed to Buy (${user.cart.length} items)',
                  ),
                ),
                verticalSpace(height: 10),
                Container(
                  color: Colors.black12.withOpacity(0.08),
                  height: 1,
                ),
                verticalSpace(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: user.cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = user.cart[index];
                      return CartProduct(cartItem: cartItem);
                    },
                  ),
                )
              ],
            );
          } else if (state is UserError) {
            return Center(child: Text(state.error.toString()));
          }

          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }
}

// import 'package:amazon_clone/core/common/widgets/loader.dart';
// import 'package:amazon_clone/features/address/screens/address_screen.dart';
// import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
// import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
// import 'package:amazon_clone/features/home/widgets/address_box.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../constants/bloc/user_bloc/user_bloc.dart';
// import '../../../constants/bloc/user_bloc/user_state.dart';
// import '../../../constants/global_variables.dart';
// import '../../../core/common/widgets/basics.dart';
// import '../../../core/common/widgets/custom_button.dart';
// import '../../search/screens/search_screen.dart';
//
// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> with CommonWidgets {
//   void navigateToSearchScreen(String query) {
//     Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
//   }
//
//   void navigateToAddressScreen(int sum) {
//     Navigator.pushNamed(
//       context,
//       AddressScreen.routeName,
//       arguments: sum.toString(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userState = context.watch<UserBloc>().state;
//     if (userState is! UserLoaded) return const Loader(); // Or loading screen
//
//     final user = userState.user;
//
//     int sum = 0;
//     user.cart
//         .map((e) => sum += e['quantity'] * e['product']['price'] as int)
//         .toList();
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
//                       child: Container(
//                           height: 42,
//                           margin: const EdgeInsets.only(left: 15),
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
//       body:
//       BlocBuilder<UserBloc, UserState>(
//         builder: (context, state) {
//       if (state is UserInitial) {
//         return const Loader();
//       } else if (state is UserLoaded) {
//         final user = state.user;
//
//         Column(
//         children: [
//           const AddressBox(),
//           const CartSubtotal(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CustomButton(
//                 onTap: () {
//                   navigateToAddressScreen(sum);
//                 },
//                 color: Colors.yellow.shade800,
//                 title: 'Proceed to Buy (${user.cart.length} items)'),
//           ),
//           verticalSpace(height: 10),
//           Container(
//             color: Colors.black12.withOpacity(0.08),
//             height: 1,
//           ),
//           verticalSpace(height: 5),
//           Expanded(
//             child: ListView.builder(
//               itemCount: user.cart.length,
//               itemBuilder: (context, index) {
//                 return CartProduct(index: index);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
