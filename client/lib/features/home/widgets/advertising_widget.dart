import 'package:flutter/material.dart';

class AdvertisingWidget extends StatelessWidget {
  final String image;
  const AdvertisingWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        color: Colors.grey.shade200,
        child: Image(image: AssetImage(image)));
  }
}
