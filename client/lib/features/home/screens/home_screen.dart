import 'package:amazon_clone/core/common/widgets/common_app_bar.dart';
import 'package:amazon_clone/features/home/blocs/deal_bloc/deal_bloc.dart';
import 'package:amazon_clone/features/home/screens/products_catalog_by_ads.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/home/widgets/advertising_widget.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_the_day.dart';
import 'package:amazon_clone/features/home/widgets/sponsored_widget.dart';
import 'package:amazon_clone/features/home/widgets/top_categories.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/basics.dart';
import '../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../../product_categories/blocs/product_bloc/product_bloc.dart';
import '../../product_categories/data/repository/product_repository.dart';
import '../blocs/deal_bloc/deal_event.dart';
import '../data/repository/home_repository.dart';
import '../widgets/best_deal_for_you.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CommonWidgets {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  late final DealBloc _dealBloc; // keep a single instance

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated) {
      final token = authState.user.token;

      final repo = HomeRepository(token: token); // implements getDealOfTheDay()
      _dealBloc = DealBloc(repo)
        ..add(FetchDealOfTheDay(token))
        ..add(FetchBestDealForYou(token));
    }
  }

  @override
  void dispose() {
    _dealBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dealBloc,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AddressBox(),
                verticalSpace(height: 10),
                const TopCategories(),
                verticalSpace(height: 10),
                BlocProvider(
                  create: (_) =>
                      ProductBloc(productRepository: ProductRepository()),
                  child: const CarouselImages(),
                ),
                const BestDealForYou(),
                SponsoredWidget(
                  image: ImagePaths.instance.sponsoredImagePath,
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProductsCatalogByAds.routeName,
                    arguments: {
                      'mainCategory': 'Fashion',
                      'subCategory': 'Women',
                      'subClassification': 'Watches',
                    },
                  ),
                ),
                AdvertisingWidget(image: ImagePaths.instance.deliveryPath),
                SponsoredWidget(
                  image: ImagePaths.instance.kellogsAdPath,
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProductsCatalogByAds.routeName,
                    arguments: {
                      'mainCategory': 'Groceries',
                      'subCategory': 'Breakfast Foods',
                      // 'subClassification': 'Watches',
                    },
                  ),
                ),
                verticalSpace(height: 10),
                const DealOfTheDay(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
