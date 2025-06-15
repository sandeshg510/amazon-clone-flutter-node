import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/my_orders_screen.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/auth/presentation/widgets/new_custom_button.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/bottom_bar.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
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
          print(orders);
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
    print(reversedOrders);

    return Container(
      height: 170,
      padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
            child: SingleProduct(image: order.products[0].images[0]),
          );
        },
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MyOrdersScreen.routeName);
                  },
                  child: Text(
                    'See all',
                    style:
                        TextStyle(color: GlobalVariables.selectedNavBarColor),
                  ),
                ),
              ],
            ),
          ),
          _buildOrderItems(),
        ],
      ),
    );
  }
}
