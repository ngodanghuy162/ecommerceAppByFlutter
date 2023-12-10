import 'dart:io';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  String selectedCategory = '';
  String brandName = '';
  String image_url = '';
  List<String> imageList_url = [];
  String description = '';
  int discount = 0;
  String name = '';
  List<ProductVariantModel> variants = [];
  List<String> variants_path = [];
  Color selectedColor = const Color(0xff443a49);

  //double price = 0.0;
  static const List<String> categoryList = <String>[
    'Sport',
    'Clothes',
    'Shoe',
    'Cosmetics',
    'Toy',
    'Furniture',
    'Jewelery',
    'Electronics'
  ];

  String dropdownValue = categoryList.first;

  final List<XFile?> _imageList = [];

  XFile? _image;

  Future<void> _pickImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() async {
        _image = pickedFile;
        _imageList.last = _image;
        //_imageList.add(_image);
        String uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}.jpg';

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');

        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

        try {
          await referenceImageToUpload.putFile(File(_image!.path));
          image_url = await referenceImageToUpload.getDownloadURL();
          setState(() {
            imageList_url.add(image_url);
          });

          // setState(() {
          //   imageList_url.add(image_url);
          // });
          // setState(() {
          //   url = cloud_image_url;
          // });
        } catch (error) {}
      });
    }
  }

  bool _isValidHexColor(String hexColor) {
    final hexRegex = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$');
    return hexRegex.hasMatch(hexColor);
  }

  void _openColorPicker(BuildContext context, int variantIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  variants[variantIndex].color = selectedColor.value
                      .toRadixString(16)
                      .substring(2)
                      .toUpperCase(); // Lưu mã màu dưới dạng HEX
                  print(variantIndex);
                  print(variants[variantIndex].color);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    Get.put(ProductVariantController());
    Get.put(ProductCategoryController());
    Get.put(BrandController());

    return Scaffold(
      appBar: const TAppBar(
        title: Text('Đăng Sản Phẩm'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu<String>(
                hintText: 'Category',
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
                width: 200,
                initialSelection: null,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                    selectedCategory = dropdownValue;
                  });
                },
                dropdownMenuEntries:
                    categoryList.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    brandName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image == null
                        ? const Center(
                            child: Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey),
                          )
                        : (_image!.path.contains('http')
                            ? Image.network(_image!.path, fit: BoxFit.contain)
                            : Image.file(
                                File(_image!.path),
                                fit: BoxFit.contain,
                              ))),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     height: 200,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: _image == null
              //         ? Center(
              //             child: Icon(Icons.camera_alt,
              //                 size: 40, color: Colors.grey),
              //           )
              //         : (_image!.path.contains('http') ? Image.network(_image!.path, fit: BoxFit.contain) : Image.file(File(_image!.path), fit: BoxFit.contain,))
              //   ),
              // ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Discount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    discount = value as int;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Product variants',
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.black,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Variant ${index + 1}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Size',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            variants[index].size = value;
                          });
                        },
                      ),

                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          _openColorPicker(context, index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.grey),
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          child: Row(
                            children: [
                              const Text('Pick Color',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(width: 16),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: _isValidHexColor(variants[index].color)
                                      ? Color(int.parse(
                                          '0xff${variants[index].color}'))
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors
                                          .black), // Add this line for border
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // TextField(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Color',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       variants[index].color = value;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            variants[index].price = double.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _imageList.length > index &&
                                    _imageList[index] == null
                                ? const Center(
                                    child: Icon(Icons.camera_alt,
                                        size: 40, color: Colors.grey),
                                  )
                                : (_imageList[index]!.path.contains('http')
                                    ? Image.network(_imageList[index]!.path,
                                        fit: BoxFit.contain)
                                    : Image.file(
                                        File(_imageList[index]!.path),
                                        fit: BoxFit.contain,
                                      ))),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                  minimumSize:
                      MaterialStatePropertyAll<Size>(Size(double.infinity, 50)),
                ),
                onPressed: () {
                  setState(() {
                    // Add an empty variant when the button is pressed
                    variants.add(ProductVariantModel(
                        size: '', color: '', price: 0.0, imageURL: '', id: ''));
                    _imageList.add(null);
                  });
                },
                child: const Text('Add Variant'),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.orange),
                  minimumSize:
                      MaterialStatePropertyAll<Size>(Size(double.infinity, 50)),
                ),
                onPressed: () async {
                  // Handle product submission logic here
                  print('Category: $selectedCategory');
                  print('Brand: $brandName');
                  print('Name: $name');
                  //print('Image: $image_url');
                  print('Description: $description');
                  print('Discount: $discount');
                  print('Variants: $variants');

                  final categoryResult = await ProductCategoryController
                      .instance
                      .getCategoryDocumentIdByName(selectedCategory);

                  for (int i = 0; i < variants.length; i++) {
                    variants[i].imageURL = imageList_url[i];
                    variants_path.add(await ProductVariantController.instance
                        .createProductVariant(variants[i]));
                  }

                  ProductController.instance.createProduct(
                    brand_id: brandName,
                    description: description,
                    discount: discount,
                    name: name,
                    product_category_id: selectedCategory,
                    variants_path: variants_path,
                  );
                },
                child: const Text('Đăng Sản Phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
