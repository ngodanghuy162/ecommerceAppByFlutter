import 'dart:io';

import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

// class ProductVariant {
//   String size;
//   String color;
//   double price;
//
//   ProductVariant({required this.size, required this.color, required this.price});
//
// }

class _SellProductScreenState extends State<SellProductScreen> {
  String selectedCategory = '';
  String brand_id = '';
  String image_url = '';
  String description = '';
  String discount_id = '';
  String name = '';
  List<ProductVariantModel> variants = [];
  List<String> variants_path = [];
  //double price = 0.0;
  static const List<String> list = <String>[
    'Sport',
    'Cloth',
    'Shoe',
    'Cosmetic',
    'Toy',
    'Furniture',
    'Jewelery',
    'Electronic'
  ];
  String dropdownValue = list.first;

  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() async {
        _image = pickedFile;
        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');

        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

        try {
          await referenceImageToUpload.putFile(File(_image!.path));
          image_url = await referenceImageToUpload.getDownloadURL();
          // setState(() {
          //   url = cloud_image_url;
          // });
        } catch (error) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    Get.put(ProductVariantController());

    return Scaffold(
      appBar: TAppBar(
        title: Text('Đăng Sản Phẩm'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownMenu<String>(
                hintText: 'Category',
                textStyle: TextStyle(
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
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    brand_id = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey),
                        )
                      : (_image!.path.contains('http') ? Image.network(_image!.path, fit: BoxFit.contain) : Image.file(File(_image!.path), fit: BoxFit.contain,))
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
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
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Discount_code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    discount_id = value;
                  });
                },
              ),
              SizedBox(height: 16),
              const Text(
                'Product variants',
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.black,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Variant ${index + 1}'),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Size',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            variants[index].size = value;
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            variants[index].color = value;
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
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
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
                onPressed: () {
                  setState(() {
                    // Add an empty variant when the button is pressed
                    variants.add(ProductVariantModel(size: '', color: '', price: 0.0));
                  });
                },
                child: Text('Add Variant'),
              ),

              SizedBox(height: 16),
              SizedBox(height: 16),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.orange)),
                onPressed: () async {
                  // Handle product submission logic here
                  print('Category: $selectedCategory');
                  print('Brand: $brand_id');
                  print('Name: $name');
                  print('Image: $image_url');
                  print('Description: $description');
                  print('Discount: $discount_id');
                  print('Variants: ${variants}');

                  for(int i = 0; i < variants.length; i++) {
                    variants_path.add(await ProductVariantController.instance.createProductVariant(variants[i]));
                  }
                  
                  ProductModel productModel = ProductModel(
                    product_category_id: selectedCategory,
                    brand_id: brand_id, 
                    description: description,
                    discount_id: discount_id,
                    image_url: image_url, 
                    name: name,
                    variants_path: variants_path,

                  );
                  
                  ProductController.instance.createProduct(productModel);

                },
                child: Text('Đăng Sản Phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
