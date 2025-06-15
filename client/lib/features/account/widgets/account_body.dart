import 'package:amazon_clone/features/account/widgets/orders.dart';
import 'package:amazon_clone/features/account/widgets/top_buttons.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/basics.dart';
import 'buy_again.dart';

class AccountBody extends StatelessWidget with CommonWidgets {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(children: [
          verticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    color: Colors.grey,
                  ),
                  horizontalSpace(width: 5),
                  const Text(
                    'Hello, ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
              Row(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications_none_outlined),
                          horizontalSpace(width: 18),
                          Image.asset(height: 18, ImagePaths.instance.flagPath),
                          const Text(' EN')
                        ],
                      )),
                ],
              ),
            ],
          ),
          verticalSpace(height: 20),
          const TopButtons(),
          verticalSpace(height: 30),
          const Orders(), verticalSpace(height: 20),

          const BuyAgain(),
          // const YourLists(),
          // const YourAccount()
        ]),
      ),
    );
  }
}
