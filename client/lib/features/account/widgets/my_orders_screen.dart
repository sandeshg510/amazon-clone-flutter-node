import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/core/common/widgets/common_app_bar.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/auth/presentation/widgets/new_custom_button.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/bottom_bar.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../models/order.dart';
import '../../search/screens/search_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  static const String routeName = '/my-orders';
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with CommonWidgets {
  List<Order>? orders;
  bool _isLoading = true;
  String? _errorMessage;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await accountServices.fetchOrders(context: context);
      if (mounted) {
        setState(() {
          orders = fetchedOrders;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
          orders = [];
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders: ${e.toString()}')),
      );
    }
  }

  Widget _buildOrderItems() {
    if (orders == null || orders!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hi! You have no recent orders.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            NewCustomButton(
              title: 'Return to Home Page',
              onTap: () => Navigator.pushNamed(context, BottomBar.routeName),
            ),
          ],
        ),
      );
    }
    final reversedOrders = orders!.reversed.toList();

    return Flexible(
      child: SizedBox(
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: reversedOrders.length,
          itemBuilder: (context, index) {
            final order = reversedOrders[index];
            if (order.products.isEmpty || order.products[0].images.isEmpty) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
                onTap: () => Navigator.pushNamed(
                      context,
                      OrderDetailsScreen.routeName,
                      arguments: order,
                    ),
                child: Row(
                  children: [
                    Image.network(
                        height: 120, width: 120, order.products[0].images[0]),
                    horizontalSpace(width: 30),
                    if (order.status.toString() == '0')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending/Processing',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.orange.shade600,
                                fontWeight: FontWeight.bold),
                          ),
                          verticalSpace(height: 6),
                          const Text(
                            'Seller is processing your order.',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    if (order.status.toString() == '1')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipped',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold),
                          ),
                          verticalSpace(height: 6),
                          const Text(
                            'Your order will be delivered soon.',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    if (order.status.toString() == '2')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivered',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.bold),
                          ),
                          verticalSpace(height: 6),
                          const Text(
                            'Package was handed to resident.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                  ],
                )

                // SingleProduct(image: order.products[0].images[0]),
                );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 0.8,
              color: Colors.blueGrey.shade50,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Loader();
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            const SizedBox(height: 20),
            NewCustomButton(
              title: 'Retry',
              onTap: fetchOrders,
            ),
          ],
        ),
      );
    }
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          verticalSpace(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Your Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          verticalSpace(height: 8),
          Container(
            height: 5,
            color: Colors.grey.shade200,
          ),
          verticalSpace(height: 5),
          const Center(
            child: Text(
              'Past three months',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          verticalSpace(height: 5),
          Container(
            height: 2,
            color: Colors.blueGrey.shade50,
          ),
          verticalSpace(height: 12),
          _buildOrderItems(),
          verticalSpace(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 0.8,
            color: Colors.blueGrey.shade50,
          ),
          Center(
            child: Text(
              'You have reached the end of your orders',
              style: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 02,
            color: Colors.blueGrey.shade50,
          ),
        ],
      ),
    );
  }
}
