import 'package:amazon_clone/features/admin/blocs/admin_bloc.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/products_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/global_variables.dart';
import '../../../utils/assets_paths.dart';
import '../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../../auth/presentation/views/welcome_screen.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  final String token;

  const AdminScreen({super.key, required this.token});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  late final AdminBloc _adminBloc; // Add this

  @override
  void initState() {
    super.initState();
    _adminBloc = AdminBloc(
      adminServices: AdminServices(),
      authToken: widget.token,
    )..add(FetchAllProductsEvent()); // Initial fetch
  }

  @override
  void dispose() {
    _adminBloc.close(); // Close bloc when screen disposes
    super.dispose();
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  void logout() {
    context.read<AuthBloc>().add(Logout());
    Navigator.pushNamedAndRemoveUntil(
      context,
      WelcomeScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BlocProvider.value(
        value: _adminBloc,
        child: ProductsScreen(
          key: ValueKey('products_${_page}'), // Change key based on page index
        ),
      ),
      BlocProvider.value(
        value: _adminBloc,
        child: const AnalyticsScreen(),
      ),
      BlocProvider.value(
        value: _adminBloc,
        child: const OrdersScreen(),
      ),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Image(
                    alignment: Alignment.bottomCenter,
                    width: 120,
                    height: 45,
                    color: Colors.black,
                    image: AssetImage(ImagePaths.instance.brandNameLogoPath),
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      const Text(
                        'Admin',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: logout,
                        child: Container(
                          alignment: Alignment.topRight,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Sign out ',
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                color: Colors.brown,
                                Icons.logout,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: buildNavBarIcon(0, Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: buildNavBarIcon(1, Icons.analytics_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: buildNavBarIcon(2, Icons.all_inbox_outlined),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  Widget buildNavBarIcon(int index, IconData icon) {
    return Container(
      width: bottomBarWidth,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: bottomBarBorderWidth,
            color: _page == index
                ? GlobalVariables.selectedNavBarColor
                : GlobalVariables.backgroundColor,
          ),
        ),
      ),
      child: Icon(icon),
    );
  }
}
