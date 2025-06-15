import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/auth/presentation/views/sign_in_screen.dart';
import 'package:amazon_clone/features/auth/presentation/views/sign_up_screen.dart';
import 'package:amazon_clone/features/auth/presentation/widgets/new_custom_button.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget with CommonWidgets {
  const WelcomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(height: size.height * 0.2),
          Center(
            child: Image.asset(
                width: size.width * 0.53,
                ImagePaths.instance.brandNameLogoPath),
          ),
          verticalSpace(height: 32),
          const Center(
            child: Text(
              'Sign in to your account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          verticalSpace(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'View your wish list',
                  style: TextStyle(fontSize: 15),
                ),
                verticalSpace(height: 10),
                const Text(
                  'Find & reorder past purchases',
                  style: TextStyle(fontSize: 15),
                ),
                verticalSpace(height: 10),
                const Text(
                  'Track your purchases',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          verticalSpace(height: 28),
          NewCustomButton(
            title: 'Already a customer? Sign in',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            },
          ),
          verticalSpace(height: 10),
          NewCustomButton(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
            },
            title: 'New to amazon? Create an account',
            color: Colors.grey.shade50,
          ),
          // verticalSpace(height: 10),
          // NewCustomButton(
          //   title: 'Skip sign in',
          //   color: Colors.grey.shade50,
          // ),
          // verticalSpace(height: 12),
        ],
      ),
    ));
  }
}
