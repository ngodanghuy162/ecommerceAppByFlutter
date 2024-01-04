import 'dart:io';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
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
  _CreateShopScreenState createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  XFile? _pickedImage;
  String? _imageUrl;
  late TextEditingController shopNameController;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  late TextEditingController voucherController;
  @override
  void initState() {
    super.initState();
    Get.put(ShopController());
    shopNameController = TextEditingController();
    voucherController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    shopNameController.dispose();
    voucherController.dispose();
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

  Future<String> _uploadImage() async {
    if (_pickedImage == null) {
      // Người dùng không chọn ảnh
      return "0";
    }

    try {
      // Tạo một thư mục "images" trong Firebase Storage
      final firebase_storage.Reference storageReference = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jgp');

      // Tải ảnh lên Firebase Storage
      await storageReference.putFile(File(_pickedImage!.path));

      // Lấy URL của ảnh đã tải lên
      String imageUrl = await storageReference.getDownloadURL();

      // Cập nhật UI hoặc hiển thị thông báo thành công
      setState(() {
        _imageUrl = imageUrl;
      });
      print('Ảnh đã tải lên và URL là: ${_imageUrl}');
      return imageUrl;
    } catch (e) {
      print('Lỗi tải ảnh lên Firebase Storage: $e');
      // Xử lý lỗi nếu cần thiết
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your UI components go here
            TextFormField(
              controller: shopNameController,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                // Open the image picker
                await _pickImage();
                String url = await _uploadImage();
                Get.snackbar("UpLoadImageOk", "Url la: $url");
              },
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10.0),
            // Display the picked image
            _pickedImage != null
                ? Image.file(
                    File(_pickedImage!.path),
                    height: 100,
                  )
                : Container(),
          
            TextButton(onPressed: () {}, child: Text("Add your shop address")),
            ElevatedButton(
                onPressed: () async {
                  String rs = await ShopController.instance.createShop(
                      ShopModel(
                          name: shopNameController.text,
                          owner: FirebaseAuth.instance.currentUser!.email!,
                          image: _imageUrl));
                  print("Dong 134 file create +Day la ket qua: $rs");
                  Get.to(() => const MyShopScreen());
                },
                child: const Row(
                  children: [
                    Text("Register Shop"),
                    Icon(Icons.app_registration)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
