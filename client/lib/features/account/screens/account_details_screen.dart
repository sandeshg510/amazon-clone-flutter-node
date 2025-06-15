import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/core/common/widgets/common_app_bar.dart';
import 'package:amazon_clone/features/account/widgets/account_row.dart';
import 'package:amazon_clone/features/account/widgets/my_orders_screen.dart';
import 'package:amazon_clone/features/auth/presentation/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../../search/screens/search_screen.dart';

class AccountDetailsScreen extends StatelessWidget with CommonWidgets {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    void logout() async {
      try {
        context.read<AuthBloc>().add(Logout());
        Navigator.pushNamedAndRemoveUntil(
          context,
          WelcomeScreen.routeName,
          (route) => false,
        );
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(height: 12),
            const Text(
              ' Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            verticalSpace(height: 12),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 0.2)),
              child: Column(
                children: <Widget>[
                  verticalSpace(height: 7),
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, MyOrdersScreen.routeName),
                      child: const AccountRow(title: 'Your Orders')),
                  verticalSpace(height: 5),
                  const Divider(
                    indent: 0,
                    thickness: 0.2,
                  ),
                  const AccountRow(title: 'Subscribe & Save'),
                  verticalSpace(height: 4),
                  const Divider(
                    indent: 0,
                    thickness: 0.2,
                  ),
                  const AccountRow(title: 'Recalls and Product Safety Alerts'),
                  verticalSpace(height: 12)
                ],
              ),
            ),
            verticalSpace(height: 32),
            const Text(
              ' Account Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            verticalSpace(height: 12),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 0.2)),
              child: Column(
                children: [
                  verticalSpace(height: 7),
                  const AccountRow(title: 'Your Addresses'),
                  verticalSpace(height: 5),
                  const Divider(
                    indent: 0,
                    thickness: 0.2,
                  ),
                  AccountRow(
                    title: 'Logout',
                    onTap: () {
                      logout();
                    },
                  ),
                  verticalSpace(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
