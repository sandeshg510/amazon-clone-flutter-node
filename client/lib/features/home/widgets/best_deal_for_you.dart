import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/deal_bloc/deal_bloc.dart';
import '../blocs/deal_bloc/deal_state.dart';

class BestDealForYou extends StatelessWidget {
  const BestDealForYou({super.key});

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
        if (state.isLoading && state.bestDeals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.bestDeals.isEmpty) {
          return const Text('No best deals available');
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 1),
          color: Colors.cyan.shade50,
          height: 183,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              final product = state.bestDeals[index];

              double totalRating = 0;
              double avgRating = 0;

              for (var ratingObj in product.ratings!) {
                totalRating += ratingObj.rating;

                if (totalRating != 0) {
                  avgRating = totalRating / product.ratings!.length;
                }
              }
              return GestureDetector(
                onTap: () {
                  navigateToProductDetailsScreen(context, product);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 8, bottom: 12, top: 14, right: 2),
                  padding: const EdgeInsets.only(top: 8, left: 5, bottom: 3),
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 01,
                          spreadRadius: 01,
                          color: Colors.black12,
                          offset: Offset(1, 3))
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' best deal for you',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Image.network(
                          product.images[0],
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Row(
                        children: [
                          Text(avgRating.toStringAsFixed(1)),
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange.shade600,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
