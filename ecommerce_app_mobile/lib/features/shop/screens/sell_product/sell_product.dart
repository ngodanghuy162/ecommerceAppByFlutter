import 'dart:io';

import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class ProductVariant {
  String size;
  String color;
  double price;

  ProductVariant({required this.size, required this.color, required this.price});

  @override
  String toString() {
    return 'ProductVariant(size: $size, color: $color, price: $price)';
  }
}

class _SellProductScreenState extends State<SellProductScreen> {
  String selectedCategory = '';
  String title = '';
  String imageURL = '';
  String description = '';
  List<ProductVariant> variants = [];
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
      setState(() {
        _image = pickedFile;
        // if(_image!.path.contains('http')) {
        //   imageURL = toString(_image!.path) as String;
        // } else {
        //   imageURL = _image!.path;
        // }
        imageURL = _image!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    title = value;
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
              // TextField(
              //   decoration: InputDecoration(
              //     labelText: 'Product Variants',
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       variants = value.split(',');
              //     });
              //   },
              // ),
              const Text(
                'Product variants',
                style: TextStyle(
                  fontSize: 16,
                  color: TColors.black,
                ),
              ),
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
                onPressed: () {
                  setState(() {
                    // Add an empty variant when the button is pressed
                    variants.add(ProductVariant(size: '', color: '', price: 0.0));
                  });
                },
                child: Text('Add Variant'),
              ),

              SizedBox(height: 16),
              // TextField(
              //   decoration: InputDecoration(
              //     labelText: 'Price',
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       price = double.parse(value);
              //     });
              //   },
              //   keyboardType: TextInputType.number,
              // ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle product submission logic here
                  print('Category: $selectedCategory');
                  print('Title: $title');
                  print('Image: $imageURL');
                  print('Description: $description');
                  print('Variants: ${variants}');
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
