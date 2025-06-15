import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/screens/account_details_screen.dart';
import 'package:amazon_clone/features/account/widgets/account_button.dart';
import 'package:amazon_clone/features/account/widgets/my_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/utils.dart';
import '../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../../auth/presentation/views/welcome_screen.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> with CommonWidgets {
  @override
  Widget build(BuildContext context) {
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

    bool isLoading = false;

    return isLoading
        ? const Loader()
        : Row(
            children: [
              AccountButton(
                title: 'Orders',
                onTap: () {
                  Navigator.pushNamed(context, MyOrdersScreen.routeName);
                },
              ),
              horizontalSpace(width: 8),
              AccountButton(
                title: 'Buy Again',
                onTap: () {},
              ),
              horizontalSpace(width: 8),
              AccountButton(
                  title: 'Account',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AccountDetailsScreen()));
                  }),
              horizontalSpace(width: 8),
              AccountButton(
                title: 'Logout',
                onTap: logout,
              ),
            ],
          );
  }
}
