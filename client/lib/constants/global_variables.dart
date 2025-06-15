import 'package:flutter/material.dart';

String uri = 'https://amazon-clone-server-fbj4.onrender.com';
// String uri = 'https://amazon-clone-server1.onrender.com';

class GlobalVariables {
  static const String apiKey = '332ecc3870e9e286e918000fd79f829a';

  // Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30;

  // COLORS
  static const oldAppBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xff84d8e3),
      Color(0xff8fdddd),
      Color(0xff94dfd8),
      Color(0xff9ae2d7),
      Color(0xff9ce3d3),
      Color(0xffa5e6ce),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const addressAppBarGradient = LinearGradient(
    colors: [
      Color(0xffb6e8ef),
      Color(0xffb6e8ef),
      Color(0xffc3eee7),
      Color(0xffc5efe5),
      Color(0xffcbf1e2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const yellowColor = Color.fromRGBO(254, 216, 19, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static const Color fashionAppBarColor = Color(0xff161d27);
  static const Color fashionBodyColor = Color(0xfff4e7e1);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Groceries',
      'image': 'assets/images/groceries.png',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpg',
    },
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpg',
    },
    {
      'title': 'Electronics',
      'image': 'assets/images/electronics.png',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.png',
    },
    {
      'title': 'Furniture',
      'image': 'assets/images/furniture.png',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.png',
    },
  ];

  static const Map<String, String> electronicsIcons = {
    'Laptops': 'assets/images/laptops.png',
    'Audio': 'assets/images/audio.png',
    'Tablets': 'assets/images/tablets.png',
    'Smart Wearables': 'assets/images/smart wearables.png',
    'Camera': 'assets/images/camera.png',
    'Computer Accessories': 'assets/images/computer_accessories.png',
  };

  static const Map<String, String> appliancesIcons = {
    'Televisions': 'assets/images/televisions.png',
    'Refrigerators': 'assets/images/refrigerator.png',
    'Chimneys': 'assets/images/chimney.png',
    'Dishwashers': 'assets/images/dishwasher.png',
    'Air conditioners': 'assets/images/air_conditioner.png',
    'Washing Machines': 'assets/images/washing_machine.png',
    'Microwaves': 'assets/images/microwave.png',
  };

  static const Map<String, String> furnitureIcons = {
    'Mattress': 'assets/images/mattress.png',
    'Office': 'assets/images/office.png',
    'Sofas': 'assets/images/sofa.png',
    'Recliners': 'assets/images/recliner.png',
    'Beds and Wardrobes': 'assets/images/bed_wardrobe.png',
    'Dining': 'assets/images/dining.png',
    'Outdoor': 'assets/images/outdoor.png',
  };

  static const Map<String, String> booksIcons = {
    'Fiction': 'assets/images/fiction.png',
    'Non-fiction': 'assets/images/non-fiction.png',
  };

  static const Map<String, String> brandLogos = {
    'OnePlus': 'assets/images/oneplus.png',
    'Samsung': 'assets/images/samsung.png',
    'iQOO': 'assets/images/iqoo.png',
    'Realme': 'assets/images/realme.png',
    'Apple': 'assets/images/apple.png',
    'MI': 'assets/images/xiaomi.png',
    'Motorola': 'assets/images/motorola.png',
    'HONOR': 'assets/images/honor.png',
    'Tecno': 'assets/images/tecno.png',
    'Oppo': 'assets/images/oppo.png',
    'Vivo': 'assets/images/vivo.png',
    'POCO': 'assets/images/poco.png',
  };

  static const Map<String, String> fashionCategoryImages = {
    // Men's subcategories
    'Men-Casual':
        'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7',
    'Men-Formal':
        'https://img.freepik.com/premium-photo/indian-young-man-semi-formal-wear_416902-2335.jpg',
    'Men-Sports Wear':
        'https://img.ltwebstatic.com/images3_spmp/2023/12/02/a5/17015287562d5ee0ee4a9740a736990f3b1f758a3a_thumbnail_720x.jpg',
    'Men-Ethnic Wear':
        'https://img.freepik.com/premium-photo/two-indian-men-wears-ethnic-traditional-cloths-male-fashion-models-with-sherwani-kurta-pyjama-sitting-posing-wing-chair-sofa-against-brown-grunge-background-selective-focus_466689-45469.jpg',
    'Men-Inner wear':
        'https://assets.trendin.com/img/app/categorymedia/production/1/1577-134-12584.png',
    'Men-Sports shoes':
        'https://mynicefootwear.com/wp-content/uploads/2023/03/1678358057284-01.jpeg',
    'Men-Footwear':
        'https://www.beyoung.in/blog/wp-content/uploads/2023/01/Header-5.jpg',
    'Men-Watches':
        'https://media.rolex.com/image/upload/q_auto:eco/f_auto/t_v7-grid/c_limit,w_3840/v1/catalogue/2025/upright-bba-with-shadow/m126234-0051',
    'Men-Eyewear':
        'https://www.seasonbazaar.com/wp-content/uploads/2021/01/WhatsApp-Image-2020-11-08-at-00.34.35-2.jpeg',
    'Men-Jewellery':
        'https://brantashop.com/cdn/shop/articles/Untitled_design_1.png?v=1722532048&width=1100',
    'Men-Bags':
        'https://carrytrip.in/cdn/shop/files/bagpack_ec6e1e8a-4d26-4a8d-a8bc-ed2d2873a712.jpg?v=1731651379',
    // Women's subcategories
    'Women-Dresses':
        'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f',
    'Women-Ethnic Wear':
        'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1',
    'Women-Jewellery':
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f',
    'Women-Footwear':
        'https://images.unsplash.com/photo-1543163521-1bf539c55dd2',
    'Women-Handbags':
        'https://images.unsplash.com/photo-1554342872-034a06541bad',
    'Women-Beauty products':
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9',
    'Women-Lingerie':
        'https://www.amantelingerie.in/cdn/shop/files/Invisi_Support_Bra_1500x.jpg?v=1741172623',
    'Women-Watches':
        'https://www.jiomart.com/images/product/original/rvqtdza9wc/iloz-luxury-new-rose-gold-color-stylish-magnet-watch-girls-watches-for-women-stylish-branded-fashion-latest-new-design-girls-analog-watch-for-women-product-images-rvqtdza9wc-0-202210160102.jpg?im=Resize=(500,630)',

    // Kids' subcategories
    'Kids-Toys':
        'https://play-lh.googleusercontent.com/MZ4C6ddqkMFHFDiZf3Piy9zZldd6j2ULUh6oAQC_69hNUpv6SC2mosuPfhHmjI_HQJE',
    'Kids-Clothing':
        'https://img.freepik.com/free-photo/full-shot-kids-posing-together_23-2149853383.jpg?semt=ais_hybrid&w=740',
    'Kids-School Supplies':
        'https://www.shift4shop.com/2015/images/sell-online/digital-downloads/school-supply.png',
    'Kids-Shoes':
        'https://m.media-amazon.com/images/G/31/img21/shoes/2023/SS23/Herotaters/Kids/new-herotator-1._SX621_QL85_.jpg',
  };
  static const Map<String, String> mainCategoryImages = {
    'Men':
        'https://tse2.mm.bing.net/th?id=OIP.rydl1fJR91p04RqqLB-R_wHaE8&pid=Api&P=0&h=180',
    'Women':
        'https://i.pinimg.com/736x/20/58/92/205892a610c9c1e1a545f6d26e6e5dce.jpg',
    'Kids': 'https://www.go4india.net/images/kids-clothes-online-india.jpg',
    'Footwear': 'https://images.unsplash.com/photo-1549298916-f52d724204b4',
    'Accessories':
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f',
    'Beauty': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9',
  };

  static const Map<String, Map<String, List<String>>> productHierarchy = {
    'Groceries': {
      'Fruits and Vegetables': [],
      'Cooking pastes and Sauces': [],
      'Coffee & Tea & Juices': [],
      'Dry Fruits and Nuts': [],
      'Snacks': [],
      'Cooking Spices': [],
      'Cooking Oils': [],
      'Chocolate and Sweets': [],
      'Spreads': [],
      'Breakfast Foods': [],
      'Rice & Atta & Dal': [],
    },
    'Fashion': {
      'Men': [
        'Casual',
        'Formal',
        'Sports Wear',
        'Ethnic Wear',
        'Inner wear',
        'Sports shoes',
        'Footwear',
        'Watches',
        'Eyewear',
        'Jewellery',
        'Bags'
      ],
      'Women': [
        'Dresses',
        'Ethnic Wear',
        'Jewellery',
        'Footwear',
        'Handbags',
        'Beauty products',
        'Lingerie',
        'Watches'
      ],
      'Kids': [
        'Toys',
        'Clothing',
        'School Supplies',
        'Shoes',
      ],
    },
    'Mobiles': {
      'OnePlus': [],
      'Samsung': [],
      'iQOO': [],
      'Realme': [],
      'Apple': [],
      'MI': [],
      'Motorola': [],
      'HONOR': [],
      'Tecno': [],
      'Oppo': [],
      'Vivo': [],
      'POCO': [],
    },
    'Electronics': {
      'Laptops': [],
      'Audio': [],
      'Tablets': [],
      'Smart Wearables': [],
      'Camera': [],
      'Computer Accessories': [],
    },
    'Appliances': {
      'Televisions': [],
      'Refrigerators': [],
      'Chimneys': [],
      'Dishwashers': [],
      'Air conditioners': [],
      'Washing Machines': [],
      'Microwaves': [],
    },
    'Furniture': {
      'Mattress': [],
      'Office': [],
      'Sofas': [],
      'Recliners': [],
      'Beds and Wardrobes': [],
      'Dining': [],
      'Outdoor': [],
    },
    'Books': {
      'Fiction': [],
      'Non-fiction': [],
    },
  };

  static const List<String> subCategoriesRequiringSizes = [
    'Men',
    'Women',
    'Kids',
    'Footwear'
  ];

  static const Map<String, Map<String, List<String>>> fashionSizes = {
    'Men': {
      'Casual': ['S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
      'Formal': ['30', '32', '34', '36', '38', '40'],
      'Sports Wear': ['S', 'M', 'L', 'XL'],
      'Ethnic Wear': ['S', 'M', 'L', 'XL', '2XL'],
      'Inner wear': ['S', 'M', 'L', 'XL'],
      'Footwear': ['UK6', 'UK7', 'UK8', 'UK9', 'UK10', 'UK11'],
      'Sports shoes': ['UK6', 'UK7', 'UK8', 'UK9', 'UK10'],
    },
    'Women': {
      'Dresses': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      'Ethnic Wear': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      'Footwear': ['UK3', 'UK4', 'UK5', 'UK6', 'UK7', 'UK8'],
      'Lingerie': ['XS', 'S', 'M', 'L', 'XL'],
    },
    'Kids': {
      'Clothing': [
        '0-1Y',
        '1-2Y',
        '2-3Y',
        '3-4Y',
        '5-6Y',
        '7-8Y',
        '9-10Y',
        '11-12Y'
      ],
      'Shoes': ['UK1', 'UK2', 'UK3', 'UK4', 'UK5'],
    },
  };
}
