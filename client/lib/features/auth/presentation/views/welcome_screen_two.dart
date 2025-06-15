import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/auth/presentation/widgets/new_custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreenTwo extends StatelessWidget with CommonWidgets {
  const WelcomeScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                verticalSpace(height: 10),
                Image.asset(
                    alignment: Alignment.center,
                    'assets/images/amazon_in.png',
                    height: 60,
                    width: size.width * 0.28),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.settings_outlined),
                horizontalSpace(width: 18),
                const Icon(Icons.notifications_outlined),
                horizontalSpace(width: 18),
                const Icon(Icons.search),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hello'),
                Row(
                  children: [
                    const Icon(CupertinoIcons.flag),
                    horizontalSpace(width: 5),
                    const Text('EN')
                  ],
                ),
              ],
            ),
            verticalSpace(height: 24),
            const Text(
              'Welcome to Amazon',
              style: TextStyle(fontSize: 24),
            ),
            verticalSpace(height: 24),
            NewCustomButton(title: 'Create Account'),
            verticalSpace(height: 12),
            NewCustomButton(
              color: Colors.white12,
              title: 'Sign in',
            ),
            verticalSpace(height: 38),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 68.0),
              child:
                  Text(maxLines: 2, 'Upto Rs 100 cashback on your first order'),
            ),
            verticalSpace(height: 36),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 68.0),
              child:
                  Text(maxLines: 2, 'Upto Rs 100 cashback on your first order'),
            ),
            verticalSpace(height: 36),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 68.0),
              child:
                  Text(maxLines: 2, 'Upto Rs 100 cashback on your first order'),
            ),
            verticalSpace(height: 36),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 68.0),
              child:
                  Text(maxLines: 2, 'Upto Rs 100 cashback on your first order'),
            )
          ],
        ),
      ),
    );
  }
}
