import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/material.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    return Container(
      height: 45,
      decoration:
          const BoxDecoration(gradient: GlobalVariables.addressAppBarGradient),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Icon(
            Icons.add_location_outlined,
            size: 20,
            weight: 0.1,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              'Delivery to ${user.name} - ${user.address}',
              // 'Delivery to ${user.name} - Lokmat Square, Ramdaspeth, Nagpur, Maharashtra, 440012',
              style: const TextStyle(
                  fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
            ),
          )),
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 2, right: 5),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
