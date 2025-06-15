import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/loader.dart';
import '../../../models/order.dart';
import '../blocs/admin_bloc.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/admin-orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(FetchAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is OrderOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is OrderOperationLoading) {
          return const Loader();
        }

        if (state is OrdersLoadSuccess) {
          return _buildOrdersList(state.orders);
        }

        return const Center(child: Text('No orders found'));
      },
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: orders.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () => _navigateToOrderDetails(context, order),
          child: _buildOrderItem(order),
        );
      },
    );
  }

  Widget _buildOrderItem(Order order) {
    final hasImages =
        order.products.isNotEmpty && order.products[0].images.isNotEmpty;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          Expanded(
            child: hasImages
                ? SingleProduct(image: order.products[0].images[0])
                : const Placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Order #${order.id.length >= 8 ? order.id.substring(0, 8) : order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context, Order order) {
    Navigator.pushNamed(
      context,
      OrderDetailsScreen.routeName,
      arguments: order,
    );
  }
}
