import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/global_variables.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../models/order.dart';
import '../../search/screens/search_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  static const String routeName = '/order-details';
  final Order order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    currentStep = widget.order.status;
    super.initState();
  }

  void changeOrderStatus(int newStatus) async {
    try {
      await adminServices.changeOrderStatus(
        status: newStatus,
        orderId: widget.order.id,
        token: context.currentUser.token,
      );
      setState(() {
        currentStep = newStatus;
      });
      showSnackBar(context, 'Order status updated successfully!');
    } catch (e) {
      showSnackBar(context, 'Failed to update order status: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          height: 42,
                          margin: const EdgeInsets.only(left: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            child: TextFormField(
                              onFieldSubmitted: navigateToSearchScreen,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.only(top: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black38, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  hintText: 'Search Amazon.in',
                                  hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  prefixIcon: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 23,
                                      ),
                                    ),
                                  )),
                            ),
                          )),
                    ),
                    Row(
                      children: [
                        Container(
                            color: Colors.transparent,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Icon(Icons.mic)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View Order Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Order date :       ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}'),
                    Text('Order Id :           ${widget.order.id}'),
                    Text('Order total :      \$${widget.order.totalPrice}'),
                  ],
                ),
              ),
              verticalSpace(height: 10),
              const Text(
                'Purchase Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
                            height: 120,
                            width: 120,
                          ),
                          horizontalSpace(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Qty : ${widget.order.quantity[i]}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
              verticalSpace(height: 10),
              const Text(
                'Tracking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    Stepper(
                      currentStep: currentStep,
                      steps: [
                        Step(
                          title: const Text('Pending/Processing'),
                          content: const Text('Order is being processed'),
                          isActive: currentStep >= 0,
                          state: currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text('Shipped'),
                          content: const Text('Order has been shipped'),
                          isActive: currentStep >= 1,
                          state: currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text('Delivered'),
                          content: const Text('Order has been delivered'),
                          isActive: currentStep >= 2,
                          state: currentStep >= 2
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                      ],
                    ),
                    verticalSpace(height: 16),
                    if (currentStep < 2 &&
                        context.currentUser.type ==
                            'admin') // Only show buttons if not delivered
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (currentStep == 0) // Pending
                            ElevatedButton(
                              onPressed: () =>
                                  changeOrderStatus(1), // Mark as Shipped
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GlobalVariables.secondaryColor,
                              ),
                              child: const Text(
                                'Mark as Shipped',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          if (currentStep == 1) // Shipped
                            ElevatedButton(
                              onPressed: () =>
                                  changeOrderStatus(2), // Mark as Delivered
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GlobalVariables.secondaryColor,
                              ),
                              child: const Text(
                                'Mark as Delivered',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
