import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants/global_variables.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/stars.dart';
import '../../../models/product.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/product_carousel.dart';

class FashionProductDetailsScreen extends StatefulWidget {
  const FashionProductDetailsScreen({super.key, required this.product});

  static const String routeName = '/fashion-product-details';
  final Product product;

  @override
  State<FashionProductDetailsScreen> createState() =>
      _FashionProductDetailsScreenState();
}

class _FashionProductDetailsScreenState
    extends State<FashionProductDetailsScreen> with CommonWidgets {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    double totalRating = 0;

    for (var ratingObj in widget.product.ratings!) {
      totalRating += ratingObj.rating;

      if (ratingObj.userId == context.currentUser.id) {
        myRating = ratingObj.rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.ratings!.length;
    }

    super.initState();
  }

  void addToCart() {
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Stars(rating: avgRating),
                          horizontalSpace(width: 5),
                          Text(widget.product.ratings!.length.toString()),
                        ],
                      ),
                      verticalSpace(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            ProductCarousel(product: widget.product),
            verticalSpace(height: 16),
            Container(
              color: Colors.grey.shade200,
              height: 5,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(height: 16),
                  Row(
                    children: [
                      const Text('Colour: '),
                      Text(
                        '${widget.product.colour}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  verticalSpace(height: 8),
                  const Text('Size:'),
                  verticalSpace(height: 12),
                  SizedBox(
                    height: 45,
                    child: ListView.separated(
                      itemCount: widget.product.sizes!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            widget.product.sizes![index],
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return horizontalSpace(width: 10);
                      },
                    ),
                  ),
                  verticalSpace(height: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: const Color(0xffb02703),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      'Limited time deal',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  verticalSpace(height: 8),
                  RichText(
                      text: TextSpan(
                          text: "-62 % ",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xffb02703),
                          ),
                          children: [
                        TextSpan(
                          text: "${widget.product.price}",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        const TextSpan(
                          text: " ₹",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ])),
                  verticalSpace(height: 12),
                  const Text('FREE delivery'),
                  verticalSpace(height: 8),
                  Text(
                    'In Stock',
                    style:
                        TextStyle(fontSize: 15, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
            verticalSpace(height: 16),
            Container(
              color: Colors.grey.shade200,
              height: 5,
              width: double.infinity,
            ),
            verticalSpace(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
              child: CustomButton(
                title: 'Add to Cart',
                onTap: addToCart,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: CustomButton(
                title: 'Buy Now',
                color: Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            verticalSpace(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
              width: double.infinity,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                'Product details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpace(height: 20),
            Container(
              color: Colors.black,
              height: 0.2,
              width: double.infinity,
            ),
            verticalSpace(height: 12),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About this item',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  verticalSpace(height: 4),
                  Text(widget.product.about!),
                  verticalSpace(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  verticalSpace(height: 4),
                  Text(widget.product.description),
                  verticalSpace(height: 500),
                  const Text(
                    'Rate The Product',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  RatingBar.builder(
                      initialRating: myRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: GlobalVariables.secondaryColor,
                        );
                      },
                      onRatingUpdate: (rating) {
                        productDetailsServices.rateProduct(
                          context: context,
                          product: widget.product,
                          rating: rating,
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
