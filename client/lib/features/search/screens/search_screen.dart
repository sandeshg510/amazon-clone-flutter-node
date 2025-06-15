import 'package:amazon_clone/core/common/widgets/common_app_bar.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/utils.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/loader.dart';
import '../../home/blocs/search/search_bloc.dart';
import '../../home/blocs/search/search_event.dart';
import '../../home/blocs/search/search_state.dart';
import '../../home/services/search_services.dart';
import '../../home/widgets/address_box.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../widgets/searched_product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.searchQuery});
  static const String routeName = '/search-screen';
  final String searchQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with CommonWidgets {
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    final token = context.currentUser.token;
    _searchBloc = SearchBloc(SearchServices());
    _searchBloc
        .add(FetchSearchedProducts(query: widget.searchQuery, token: token));
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen),
        ),
        body: BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchError) {
              showSnackBar(context, state.message);
            }
          },
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Loader();
              } else if (state is SearchLoaded) {
                return Column(
                  children: [
                    const AddressBox(),
                    verticalSpace(height: 2),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailsScreen.routeName,
                                arguments: product,
                              );
                            },
                            child: SearchedProduct(product: product),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return verticalSpace(height: 18);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox(); // No UI for SearchInitial
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 42,
            margin: const EdgeInsets.only(left: 15),
            child: Material(
              borderRadius: BorderRadius.circular(7),
              child: TextFormField(
                onFieldSubmitted: navigateToSearchScreen,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(top: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  hintText: 'Search Amazon.in',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Icon(Icons.search, color: Colors.black, size: 23),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Icon(Icons.mic),
        ),
      ],
    );
  }
}
