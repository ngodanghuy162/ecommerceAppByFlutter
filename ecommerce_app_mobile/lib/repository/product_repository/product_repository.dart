import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createProduct(ProductModel productModel) async {
    await _db
        .collection('Product')
        .add(productModel.toJson())
        .whenComplete(
          () => Get.snackbar(
            'Thành công',
            'Bạn đã tạo sản phẩm mới',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ),
        )
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      print(error.toString());
    });
  }

  Future<List<ProductModel>> queryAllProductsFiltedBrand(String brandId) async {
    final snapshot = await _db
        .collection('Product')
        .where('brand_id', isEqualTo: brandId)
        .get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<List<ProductModel>> getAllProduct(String product) async {
    final snapshot = await _db.collection('Product').get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }
}
