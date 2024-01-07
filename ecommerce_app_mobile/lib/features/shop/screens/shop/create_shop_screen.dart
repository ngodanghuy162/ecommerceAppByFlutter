import 'dart:io';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/shop_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateShopScreenState createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  bool isTicked = false;
  XFile? _pickedImage;
  String? _imageUrl;
  late TextEditingController shopNameController;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    shopNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    shopNameController.dispose();
  }

  Future<bool> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
      return true;
    }
    return false;
  }

  Future<bool> _pickImageByCamera() async {
    XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource
          .camera, // Sử dụng ImageSource.camera để chọn ảnh từ camera
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
      return true;
    }
    return false;
  }

  Future<String> _uploadImage() async {
    if (_pickedImage == null) {
      // User did not pick an image
      return "0";
    }

    try {
      // Create a directory named "images" in Firebase Storage
      final firebase_storage.Reference storageReference = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image to Firebase Storage
      await storageReference.putFile(File(_pickedImage!.path));

      // Get the URL of the uploaded image
      String imageUrl = await storageReference.getDownloadURL();

      // Update UI or display a success message
      setState(() {
        _imageUrl = imageUrl;
      });
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ShopController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .start, // Display from the beginning of the Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your shop name:',
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 10.0),
              // Your UI components go here
              TextFormField(
                controller: shopNameController,
                decoration: const InputDecoration(labelText: 'Enter name....'),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Open the image picker
                      await _pickImage();
                      // ignore: unused_local_variable
                      String url = await _uploadImage();
                    },
                    child: const Text(' Upload shop image  '),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Open the image picker
                      await _pickImageByCamera();
                      // ignore: unused_local_variable
                      String url = await _uploadImage();
                    },
                    child: const Text('  Take photo shop image '),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // Display the picked image
              _pickedImage != null
                  ? Image.file(
                      File(_pickedImage!.path),
                      height: 100,
                    )
                  : Container(),
              // Selling commitment
              const Text(
                'Selling Commitment',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome to our shop registration. Before continuing, please read and agree to the following terms:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '1. You agree to provide accurate and complete information during registration.',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                '2. You commit to comply with the rules and conditions of the application.',
                style: TextStyle(fontSize: 16.0),
              ),
              // Add other terms as needed
              const SizedBox(height: 16.0),
              const Text(
                '3. Clearly declare the origin of the products.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '4. Do not sell prohibited items, fake goods, or low-quality goods.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '5. By accepting and registering, you understand and accept all terms and conditions.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                      value: isTicked,
                      onChanged: (newValue) {
                        setState(() {
                          isTicked = newValue!;
                        });
                      }),
                  const Text('I have read and agreed to the terms.'),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    if (isTicked) {
                      // ignore: unused_local_variable
                      String rs = await ShopController.instance.createShop(
                          ShopModel(
                              name: shopNameController.text,
                              owner: FirebaseAuth.instance.currentUser!.email!,
                              image: _imageUrl));
                      Get.to(() => const MyShopScreen());
                    } else {
                      print("Unchecked but tried to register");
                      Get.snackbar(
                        'Failed',
                        'Please check the agreement box before registering.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                        colorText: Colors.red,
                      );
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(child: Text("Register Shop")),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.app_registration),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
