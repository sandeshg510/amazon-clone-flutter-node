import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SponsoredWidget extends StatelessWidget with CommonWidgets {
  final String image;
  final void Function()? onTap;
  const SponsoredWidget({super.key, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
          ),
          verticalSpace(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Sponsored ',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const Icon(CupertinoIcons.exclamationmark_circle_fill,
                  size: 16, color: Colors.black54),
              horizontalSpace(width: 6)
            ],
          ),
          verticalSpace(height: 10),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
