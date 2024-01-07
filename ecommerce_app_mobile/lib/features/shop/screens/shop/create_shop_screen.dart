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
      return imageUrl;
    } catch (e) {
      print('Lỗi tải ảnh lên Firebase Storage: $e');
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Shop'),
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
                // ignore: unused_local_variable
                String url = await _uploadImage();
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10.0),
            // Display the picked image
            _pickedImage != null
                ? Image.file(
                    File(_pickedImage!.path),
                    height: 100,
                  )
                : Container(),
            //dieu khoan dang ki
            const Text(
              'Cam Kết Đồng Ý',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Chào mừng bạn đến với ứng dụng đăng ký bán hàng của chúng tôi. Trước khi tiếp tục, hãy đọc kỹ và cam kết đồng ý với các điều khoản sau:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '1. Bạn đồng ý cung cấp thông tin chính xác và đầy đủ trong quá trình đăng ký.',
              style: TextStyle(fontSize: 16.0),
            ),
            const Text(
              '2. Bạn cam kết tuân thủ các quy định và điều kiện của ứng dụng.',
              style: TextStyle(fontSize: 16.0),
            ),
            // Thêm các điều khoản khác tùy theo yêu cầu của bạn
            const SizedBox(height: 16.0),
            const Text(
              '3.Kê khai đảm bảo rõ ràng nguồn gốc sản phẩm.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '4.Không bán hàng cấm, hàng giả, hàng kém chất lượng.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '5.Bằng cách chấp nhận và đăng ký, bạn hiểu và chấp nhận tất cả các điều khoản và điều kiện.',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                Checkbox(
                    value: isTicked,
                    onChanged: (newValue) {
                      setState(() {
                        isTicked = newValue!;
                      });
                    }),
                const Text('Bạn đã đọc kỹ các điều khoản.'),
              ],
            ),
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
                    Get.snackbar("Thất bại",
                        "Vui lòng tích vào ô đồng ý với các điều khoản.",
                        borderColor: Colors.red, colorText: Colors.white);
                  }
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
