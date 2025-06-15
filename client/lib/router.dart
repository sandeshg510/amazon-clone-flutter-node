import 'package:amazon_clone/features/account/widgets/my_orders_screen.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/presentation/views/sign_in_screen.dart';
import 'package:amazon_clone/features/auth/presentation/views/sign_up_screen.dart';
import 'package:amazon_clone/features/auth/presentation/views/welcome_screen.dart';
import 'package:amazon_clone/features/home/screens/products_catalog_by_ads.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/features/product_categories/appliances/screens/appliances_section_screen.dart';
import 'package:amazon_clone/features/product_categories/books/screens/books_section_screen.dart';
import 'package:amazon_clone/features/product_categories/data/repository/product_repository.dart';
import 'package:amazon_clone/features/product_categories/electronics/screens/electronics_section_screen.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:amazon_clone/features/product_categories/furniture/screens/furniture_section_screen.dart';
import 'package:amazon_clone/features/product_categories/groceries/screens/groceries_section_screen.dart';
import 'package:amazon_clone/features/product_categories/mobiles/screens/mobiles_section_screen.dart';
import 'package:amazon_clone/features/product_details/screens/fashion_product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/common/widgets/bottom_bar.dart';
import 'features/admin/blocs/admin_bloc.dart';
import 'features/admin/screens/add_products_screen.dart';
import 'features/admin/screens/products_screen.dart';
import 'features/admin/services/admin_services.dart';
import 'features/home/screens/home_screen.dart';
import 'features/product_categories/blocs/product_bloc/product_bloc.dart';
import 'features/product_categories/fashion/screens/fashion_category.dart';
import 'features/product_details/screens/product_details_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'models/order.dart';
import 'models/product.dart';

Route<dynamic> generateRoute(
    RouteSettings routeSettings, BuildContext context) {
  switch (routeSettings.name) {
    case WelcomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    case SignInScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignInScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case BottomBar.routeName:
      return MaterialPageRoute(builder: (_) => const BottomBar());
    case ProductsScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ProductsScreen());
    // case AddProductsScreen.routeName:
    //   return MaterialPageRoute(builder: (_) => const AddProductsScreen());
    // In generateRoute function
    case AdminScreen.routeName:
      final String token = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AdminBloc(
            adminServices: AdminServices(),
            authToken: token,
          )..add(FetchAllProductsEvent()),
          child: AdminScreen(token: token),
        ),
      );

    case AddProductsScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AdminBloc>(),
          child: const AddProductsScreen(),
        ),
      );

    case ProductDetailsScreen.routeName:
      Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
                product: product,
              ));
    case FashionProductDetailsScreen.routeName:
      Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          builder: (_) => FashionProductDetailsScreen(
                product: product,
              ));
    case SearchScreen.routeName:
      String searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => SearchScreen(
                searchQuery: searchQuery,
              ));

    case AddressScreen.routeName:
      String totalAmount = routeSettings.arguments as String;

      return MaterialPageRoute(
          builder: (_) => AddressScreen(
                totalAmount: totalAmount,
              ));

    case OrderDetailsScreen.routeName:
      Order order = routeSettings.arguments as Order;

      return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
                order: order,
              ));
    case FashionCategory.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (_) => ProductBloc(
                  productRepository: ProductRepository(),
                ),
                child: const FashionCategory(),
              ));

    case GroceriesSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const GroceriesSectionScreen()));
    case MobilesSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const MobilesSectionScreen()));
    case ElectronicsSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const ElectronicsSectionScreen()));

    case AppliancesSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const AppliancesSectionScreen()));
    case FurnitureSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const FurnitureSectionScreen()));
    case BooksSectionScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => ProductBloc(
                    productRepository: ProductRepository(),
                  ),
              child: const BooksSectionScreen()));

    case ProductsCatalogScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      final String category = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(FetchProductsByCategory(categories: [
              'Fashion',
              args['mainCategory'],
              args['subCategory']
            ])),
          child: const ProductsCatalogScreen(
            title: '',
          ),
        ),
      );
    case ProductsCatalogByAds.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;

      final mainCategory = args['mainCategory'] as String? ?? '';
      final subCategory = args['subCategory'] as String? ?? '';
      final subClassification = args['subClassification'] as String? ?? '';

      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(
              FetchProductsByCategory(
                categories: [
                  mainCategory,
                  subCategory,
                  subClassification,
                ].where((e) => e.isNotEmpty).toList(),
              ),
            ),
          child: const ProductsCatalogByAds(),
        ),
      );

    case MyOrdersScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MyOrdersScreen());

    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text('Screen does not exist!')),
              ));
  }
}
