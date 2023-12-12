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
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      print(error.toString());
    });
    return id.id;
  }

  Future<List<ProductVariantModel>> queryAllProductVariants(
      String productId) async {
    final snapshot = await _db
        .collection('ProductVariant')
        .where('product_id', isEqualTo: productId)
        .get();
    final productData =
        snapshot.docs.map((e) => ProductVariantModel.fromSnapShot(e)).toList();
    return productData;
  }

  // Future<ProductVariantModel> queryVariantByID(String variantsID) async {
  //   final snapshot = await _db
  //       .collection('ProductVariant')
  //       .where(document.getElementById(fK3ddutEpD2qQqRMXNW5)

  //       .get();
  //   final productData = ProductVariantModel.fromSnapShot(snapshot);
  //   return productData;
  // }

  Future<List<ProductVariantModel>> queryVariants(
      List<dynamic> variantsIDs) async {
    final query = _db
        .collection('ProductVariant')
        .where(FieldPath.documentId, whereIn: variantsIDs);
    final snapshot = await query.get();
    return snapshot.docs
        .map((e) => ProductVariantModel.fromSnapShot(e))
        .toList();
  }
}
