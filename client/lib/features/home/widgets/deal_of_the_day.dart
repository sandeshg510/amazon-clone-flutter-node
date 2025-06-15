import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/deal_bloc/deal_bloc.dart';
import '../blocs/deal_bloc/deal_state.dart';

class DealOfTheDay extends StatelessWidget {
  const DealOfTheDay({super.key});

  void navigateToProductDetailsScreen(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealBloc, DealState>(
      builder: (context, state) {
        if (state.isLoading && state.dealOfTheDay == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.dealOfTheDay == null) {
          return const Text('No deal of the day available');
        }
        final product = state.dealOfTheDay;
        return GestureDetector(
          onTap: () => navigateToProductDetailsScreen(context, product),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 15),
                child: Text(
                  'Deal of the Day',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Image.network(
                  product!.images.first,
                  height: 235,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          '₹',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          height: 3,
                        )
                      ],
                    ),
                    Text(
                      product.price.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: product.images
                      .map((e) => Image.network(
                            e,
                            fit: BoxFit.fitWidth,
                            width: 100,
                            height: 100,
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15).copyWith(left: 15),
                child: Text(
                  'See in details',
                  style: TextStyle(color: Colors.cyan.shade800),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
