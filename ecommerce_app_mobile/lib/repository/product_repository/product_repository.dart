import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/brands_controller/brands_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final brandController = Get.put(BrandsController());

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

  Future<List<ProductModel>> queryAllProductByName(String keySearch) async {
    final snapshot = await _db
        .collection('Product')
        .where('name', isGreaterThanOrEqualTo: keySearch)
        .where('name', isLessThan: keySearch + 'z')
        .get();
    log("key: $keySearch :::" + snapshot.toString());
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }
}
