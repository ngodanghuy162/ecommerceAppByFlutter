import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductVariantRepository extends GetxController {
  static ProductVariantRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createProductVariant(
      ProductVariantModel productVariantModel) async {
    var id = await _db
        .collection('ProductVariant')
        .add(productVariantModel.toJson())
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
    return id.path;
  }

  Future<List<ProductVariantModel>> queryAllProductVariants(
      String product) async {
    final snapshot = await _db.collection('ProductVariant').get();
    final productData =
        snapshot.docs.map((e) => ProductVariantModel.fromSnapShot(e)).toList();
    return productData;
  }
}
