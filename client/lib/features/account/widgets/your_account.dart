import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/loader.dart';
import '../../../models/order.dart';

class YourAccount extends StatefulWidget {
  const YourAccount({super.key});

  @override
  State<YourAccount> createState() => _OrdersState();
}

class _OrdersState extends State<YourAccount> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  void fetchOrders() async {
    List<Order> fetchedOrders =
        await accountServices.fetchOrders(context: context);
    setState(() {
      orders = fetchedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Account',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    orders!.isEmpty
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                  color: GlobalVariables.selectedNavBarColor),
                            )),
                  ],
                ),
                orders!.isEmpty
                    ? const SizedBox()
                    : Container(
                        height: 170,
                        padding:
                            const EdgeInsets.only(left: 10, top: 20, right: 0),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orders!.length,
                            itemBuilder: ((context, index) {
                              final order = orders![index];

                              if (order.products.isEmpty ||
                                  order.products[0].images.isEmpty) {
                                return const SizedBox();
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, OrderDetailsScreen.routeName,
                                      arguments: order);
                                },
                                child: SingleProduct(
                                    image: order.products[0].images[0]),
                              );
                            })),
                      )
              ],
            ),
          );
  }
}
