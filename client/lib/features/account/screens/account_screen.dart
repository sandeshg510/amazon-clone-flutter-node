import 'package:amazon_clone/features/account/widgets/account_body.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/common_app_bar.dart';
import '../../search/screens/search_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
        body: const AccountBody());
  }
}
