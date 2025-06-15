import 'dart:io';

import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/widgets/admin_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../core/common/widgets/basics.dart';
import '../../../core/common/widgets/common_app_bar.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../search/screens/search_screen.dart';
import '../blocs/admin_bloc.dart';

class AddProductsScreen extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductsScreen({super.key});

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen>
    with CommonWidgets {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController colourController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController inBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();

    checkPermissions();
    _updateSubcategories(); // initialize dependent lists
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    brandController.dispose();
    colourController.dispose();
    aboutController.dispose();
    inBoxController.dispose();
    super.dispose();
  }

  void _updateSubcategories() {
    const hierarchy = GlobalVariables.productHierarchy;
    subCategoryList = hierarchy[category]?.keys.toList() ?? [];

    // Safety check: ensure subCategoryList is not empty before assigning
    if (subCategoryList.isNotEmpty) {
      // Make sure we assign a value that actually exists in the list
      subCategory = subCategoryList.first;
      _updateSubClassifications();
    } else {
      // Clear values if there are no subcategories
      subCategory = '';
      subClassification = '';
      availableSizes = [];
      selectedSizes = [];
    }
  }

  void _updateSubClassifications() {
    const hierarchy = GlobalVariables.productHierarchy;
    subClassificationList = hierarchy[category]?[subCategory] ?? [];

    // Safety check: ensure subClassificationList is not empty before assigning
    if (subClassificationList.isNotEmpty) {
      // Make sure we assign a value that actually exists in the list
      subClassification = subClassificationList.first;
    } else {
      subClassification = '';
    }

    _updateAvailableSizes();
  }

  void _updateAvailableSizes() {
    setState(() {
      // Default to empty lists
      availableSizes = [];
      selectedSizes = [];

      // Only try to get sizes if we're in the Fashion category and have valid subcategory and subclassification
      if (category == 'Fashion' &&
          subCategory.isNotEmpty &&
          subClassification.isNotEmpty) {
        const sizesMap = GlobalVariables.fashionSizes;

        // Print debug information
        print('Accessing sizes for: $subCategory > $subClassification');
        print('Available subcategories: ${sizesMap.keys.join(', ')}');
        if (sizesMap.containsKey(subCategory)) {
          print(
              'Available subclassifications for $subCategory: ${sizesMap[subCategory]?.keys.join(', ')}');
        }

        // Safely access the nested map
        if (sizesMap.containsKey(subCategory) &&
            sizesMap[subCategory]!.containsKey(subClassification)) {
          final sizes = sizesMap[subCategory]![subClassification]!;
          availableSizes = sizes;
          print('Found sizes: ${sizes.join(', ')}');
        } else {
          print('No sizes found for $subCategory > $subClassification');
        }
      }
    });
  }

  String category = 'Mobiles';
  String subCategory = '';
  String subClassification = '';
  List<String> selectedSizes = [];

  List<String> subCategoryList = [];
  List<String> subClassificationList = [];
  List<String> availableSizes = [];

  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  void checkPermissions() async {
    final storageStatus = await Permission.storage.status;
    final photoStatus = await Permission.photos.status;

    print("Storage permission: $storageStatus");
    print("Photos permission: $photoStatus");
  }

  // Update the _compressImage method
  Future<File?> _compressImage(File file) async {
    try {
      final directory = await getTemporaryDirectory();
      final targetPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : file; // Fallback to original
    } catch (e) {
      debugPrint('Image compression error: $e');
      return file; // Return original if compression fails
    }
  }

  // Future<void> _pickAssets() async {
  //   try {
  //     final List<AssetEntity>? assets = await AssetPicker.pickAssets(
  //       context,
  //       pickerConfig: const AssetPickerConfig(
  //         maxAssets: 10,
  //         requestType: RequestType.image,
  //       ),
  //     );
  //
  //     if (assets != null) {
  //       final List<File> selectedImages = [];
  //       for (AssetEntity asset in assets) {
  //         try {
  //           final file = await asset.file;
  //           if (file != null) {
  //             selectedImages.add(file);
  //           }
  //         } catch (e) {
  //           debugPrint('Error loading image: $e');
  //         }
  //       }
  //       setState(() {
  //         images = selectedImages;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error picking images: $e');
  //   }
  // }

  Future<void> _pickAssets() async {
    try {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
        ),
      );

      if (assets != null) {
        final List<File> compressedImages = [];

        for (AssetEntity asset in assets) {
          try {
            final file = await asset.file;
            if (file != null) {
              final compressedFile = await _compressImage(file);
              if (compressedFile != null) {
                compressedImages.add(compressedFile);
              }
            }
          } catch (e) {
            debugPrint('Error loading or compressing image: $e');
          }
        }

        setState(() {
          images = compressedImages;
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

// Modified sellProducts function
  Future<void> sellProducts({
    required String token,
    required String name,
    required List<File> images,
    required double price,
    required double quantity,
    required String category,
    required String subCategory,
    required List<String> sizes,
    String? brand,
    String? description,
    String? subClassification,
    String? colour,
    String? about,
    String? inTheBox,
  }) async {
    try {
      // Upload whatever images we have
      final imageUrls = await _uploadProductImages(images, name);
    } catch (e) {
      debugPrint('Error in sellProducts: $e');
    }
  }

// Simplified upload function
  Future<List<String>> _uploadProductImages(
      List<File> images, String productName) async {
    final List<String> imageUrls = [];
    for (File image in images) {
      try {
        imageUrls.add('uploaded_url_placeholder');
      } catch (e) {
        debugPrint('Error uploading ${image.path}: $e');
        // Add placeholder even if upload fails
        imageUrls.add('error_placeholder');
      }
    }
    return imageUrls;
  }

  void selectImages() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        await _pickAssets();
      } else {
        _handlePermissionDenied();
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        await _pickAssets();
      } else {
        _handlePermissionDenied();
      }
    }
  }

  void _handlePermissionDenied() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permission denied. Please enable access in settings.'),
      ),
    );
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    void sellProduct() {
      if (_addProductFormKey.currentState!.validate() &&
          images.isNotEmpty &&
          subCategory.isNotEmpty) {
        context.read<AdminBloc>().add(AddProductEvent(
            name: productNameController.text.trim(),
            description: descriptionController.text.trim(),
            price: double.parse(priceController.text.trim()),
            quantity: double.parse(quantityController.text.trim()),
            category: category,
            subCategory: subCategory,
            images: images,
            subClassification: subClassification,
            sizes: selectedSizes,
            brand: brandController.text.trim(),
            colour: colourController.text.trim(),
            about: aboutController.text.trim(),
            inTheBox: inBoxController.text.trim()));
      }
    }

    return BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is ProductOperationLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Loader(),
            );
          }
          if (state is ProductAddSuccess) {
            // Close loader first
            Navigator.of(context).pop();
            // Then navigate back
            Navigator.of(context).pop();
            showSnackBar(context, 'Product added successfully!');
          }
          if (state is ProductOperationFailure) {
            Navigator.pop(context); // Close loading dialog
            showSnackBar(context, state.error);
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: CommonAppBar(onFieldSubmitted: navigateToSearchScreen)),
          body: SingleChildScrollView(
              child: Form(
                  key: _addProductFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        verticalSpace(height: 20),
                        images.isNotEmpty
                            ? CarouselSlider(
                                items: images.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        FutureBuilder<Uint8List>(
                                      future: i.readAsBytes(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            height: 200,
                                          );
                                        }
                                        return Container(
                                          color: Colors.grey[200],
                                          height: 200,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 200,
                                  enableInfiniteScroll: false,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImages();
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        verticalSpace(height: 10),
                                        Text(
                                          'Select Product Images',
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        verticalSpace(height: 30),
                        AdminTextField(
                          controller: productNameController,
                          hintText: 'Product Name',
                          title: 'Product Name *',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          controller: brandController,
                          hintText: 'Brand',
                          title: 'Brand *',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          isRequired: false,
                          controller: colourController,
                          hintText: 'Colour',
                          title: 'Colour',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          controller: priceController,
                          hintText:
                              'Enter only numbers! Don\'t use commas & \$, ₹.',
                          title: 'Price *',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          controller: inBoxController,
                          maxLines: 5,
                          isRequired: false,
                          hintText: 'What\'s in the box?',
                          title: 'What\'s in the box?',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          maxLines: 7,
                          isRequired: false,
                          controller: aboutController,
                          hintText: 'About',
                          title: 'About',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          maxLines: 5,
                          isRequired: false,
                          controller: descriptionController,
                          hintText: 'Description',
                          title: 'Description',
                        ),
                        verticalSpace(height: 10),
                        AdminTextField(
                          controller: quantityController,
                          hintText: 'Quantity',
                          title: 'Quantity *',
                        ),
                        verticalSpace(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButton(
                              value: category,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: GlobalVariables.productHierarchy.keys
                                  .map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  category = newValue!;
                                  subCategory = '';
                                  subClassification = '';
                                  _updateSubcategories();
                                });
                              }),
                        ),
                        verticalSpace(height: 10),
                        if (subCategoryList.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton(
                                value:
                                    subCategory.isNotEmpty ? subCategory : null,
                                hint: const Text('Select Subcategory'),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: subCategoryList.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    subCategory = newValue!;
                                    subClassification = '';
                                    _updateSubClassifications();
                                  });
                                }),
                          ),
                        if (subClassificationList.isNotEmpty)
                          SizedBox(
                              width: double.infinity,
                              child: DropdownButton(
                                value: subClassification.isNotEmpty
                                    ? subClassification
                                    : null,
                                hint: const Text('Select subClassification'),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: subClassificationList.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    subClassification = newValue!;
                                    _updateAvailableSizes();
                                  });
                                },
                              )),
                        verticalSpace(height: 8),
                        if (category == 'Fashion' && availableSizes.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Sizes',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              verticalSpace(height: 4),
                              Wrap(
                                spacing: 8,
                                children: availableSizes.map((size) {
                                  final isSelected =
                                      selectedSizes.contains(size);
                                  return FilterChip(
                                    label: Text(size),
                                    selected: isSelected,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedSizes = [
                                            ...selectedSizes,
                                            size
                                          ]; // new list
                                        } else {
                                          selectedSizes = selectedSizes
                                              .where((s) => s != size)
                                              .toList(); // new list
                                        }
                                        print('Selected sizes: $selectedSizes');
                                      });
                                    },
                                    selectedColor: Colors.blue.shade200,
                                    checkmarkColor: Colors.white,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        verticalSpace(height: 10),
                        CustomButton(
                          title: 'Sell',
                          onTap: () {
                            if (images.isEmpty) {
                              showSnackBar(
                                  context, 'Please select at least one image');
                              return;
                            }
                            sellProduct();
                          },
                        ),
                        verticalSpace(height: 30),
                      ],
                    ),
                  ))),
        ));
  }
}
