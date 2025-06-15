import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/features/product_categories/fashion/screens/products_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/global_variables.dart';
import '../../../../core/common/widgets/common_app_bar.dart';
import '../../../../utils/assets_paths.dart';
import '../../../home/screens/products_catalog_by_ads.dart';
import '../../../home/widgets/sponsored_widget.dart';
import '../../../search/screens/search_screen.dart';
import '../../blocs/product_bloc/product_bloc.dart';

class MobilesSectionScreen extends StatelessWidget with CommonWidgets {
  static const String routeName = '/mobiles';

  const MobilesSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToSearchScreen(String query) {
      Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
    }

    final List<String> mobiles =
        GlobalVariables.productHierarchy['Mobiles']?.keys.toList() ?? [];

    // final Map<String, String> brandLogos = {
    //   'OnePlus':
    //       'https://upload.wikimedia.org/wikipedia/commons/6/6a/OnePlus_logo.svg',
    //   'Samsung':
    //       'https://cdn.iconscout.com/icon/free/png-512/free-samsung-logo-icon-download-in-svg-png-gif-file-formats--brand-mobile-logos-pack-icons-226432.png?f=webp&w=512',
    //   'iQOO':
    //       'https://upload.wikimedia.org/wikipedia/commons/d/d3/IQOO_logo.png',
    //   'Realme':
    //       'https://upload.wikimedia.org/wikipedia/commons/3/3e/Realme_logo.png',
    //   'Apple':
    //       'https://cdn.iconscout.com/icon/free/png-512/free-apple-logo-icon-download-in-svg-png-gif-file-formats--brand-mobile-logos-pack-icons-226435.png?f=webp&w=512',
    //   'MI':
    //       'https://upload.wikimedia.org/wikipedia/commons/2/29/Xiaomi_logo.svg',
    //   'Motorola':
    //       'https://upload.wikimedia.org/wikipedia/commons/5/5a/Motorola_logo.svg',
    //   'HONOR':
    //       'https://upload.wikimedia.org/wikipedia/commons/e/e8/Honor_Logo.svg',
    //   'Tecno':
    //       'https://upload.wikimedia.org/wikipedia/commons/4/45/Tecno_Logo.png',
    //   'Oppo':
    //       'https://upload.wikimedia.org/wikipedia/commons/3/3d/OPPO_logo_2019.png',
    //   'Vivo':
    //       'https://e7.pngegg.com/pngimages/532/396/png-clipart-logo-brand-mobile-phones-vivo-trademark-company-logo-blue-angle.png',
    //   'POCO':
    //       'https://upload.wikimedia.org/wikipedia/commons/3/37/Poco_Logo.svg',
    // };

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(height: 12),
            const Text(
              'Shop by brand',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalSpace(height: 30),
            Wrap(
              spacing: 19,
              runSpacing: 20,
              children: mobiles.map((brand) {
                final logoUrl = GlobalVariables.brandLogos[brand] ?? '';

                return GestureDetector(
                  onTap: () {
                    final productBloc = context.read<ProductBloc>();
                    productBloc.add(FetchProductsByCategory(
                        categories: ['Mobiles', brand]));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: productBloc,
                          child: const ProductsCatalogScreen(
                            title: '',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.pink.shade100, Colors.white],
                            center: Alignment.center,
                            radius: 0.9,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Container(
                          width: 78,
                          height: 78,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade500,
                                Colors.grey.shade50,
                                Colors.white, // Darker color at bottom
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(brand == 'Apple' ? 20 : 10.0),
                              child: Image.asset(
                                logoUrl,
                                fit: BoxFit.contain,
                                color: Colors.black87,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        brand,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            verticalSpace(height: 30),
            SponsoredWidget(
              image: ImagePaths.instance.mobilesAdPath,
              onTap: () => Navigator.pushNamed(
                context,
                ProductsCatalogByAds.routeName,
                arguments: {
                  'mainCategory': 'Mobiles',
                  'subCategory': 'Realme',
                  // 'subClassification': 'Bags',
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
