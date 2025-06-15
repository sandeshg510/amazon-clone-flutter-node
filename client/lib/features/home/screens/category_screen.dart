import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../search/screens/search_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen(
      {super.key, required this.category, required this.onInit});
  static const String routeName = '/fashion-section';
  final String category;
  final VoidCallback onInit;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with CommonWidgets {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onInit());
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  final List<String> menCategories =
      GlobalVariables.productHierarchy['Fashion']?['Men'] ?? [];

  final List<String> womenCategories =
      GlobalVariables.productHierarchy['Fashion']?['Women'] ?? [];
  final List<String> kidsCategories =
      GlobalVariables.productHierarchy['Fashion']?['Kids'] ?? [];
  final List<String> footwearCategories =
      GlobalVariables.productHierarchy['Fashion']?['Footwear'] ?? [];
  final List<String> accessoriesCategories =
      GlobalVariables.productHierarchy['Fashion']?['Accessories'] ?? [];
  final List<String> beautyCategories =
      GlobalVariables.productHierarchy['Fashion']?['Beauty'] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Column(
              children: [
                Row(
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black38, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  hintText: 'Search Amazon.in',
                                  hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  prefixIcon: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 23,
                                      ),
                                    ),
                                  )),
                            ),
                          )),
                    ),
                    Row(
                      children: [
                        Container(
                            color: Colors.transparent,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Icon(Icons.mic)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Men',
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: menCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 90,
                      color: Colors.yellow,
                      child: Text(menCategories[index]));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return horizontalSpace(width: 10);
                },
              ),
            ),
            verticalSpace(height: 10),
            const Text(
              'Women',
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: womenCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 90,
                      color: Colors.yellow,
                      child: Text(womenCategories[index]));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return horizontalSpace(width: 10);
                },
              ),
            ),
            verticalSpace(height: 10),
            const Text(
              'Kids',
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kidsCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 90,
                      color: Colors.yellow,
                      child: Text(kidsCategories[index]));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return horizontalSpace(width: 10);
                },
              ),
            ),
            verticalSpace(height: 10),
          ],
        ),
      ),
    );
  }
}
